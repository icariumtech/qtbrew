#include "tempsensor.h"

#include <cmath>
#include <fcntl.h>
#include <linux/spi/spidev.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include <QDebug>
#include <QThread>
#include <QTimer>

namespace
{
/* RTD data, RTD current, and measurement reference
   voltage. The ITS-90 standard is used; other RTDs
   may have coefficients defined by the DIN 43760 or
   the U.S. Industrial (American) standard. */
#define RTD_A_ITS90         3.9080e-3
#define RTD_A_USINDUSTRIAL  3.9692e-3
#define RTD_A_DIN43760      3.9848e-3
#define RTD_B_ITS90         -5.870e-7
#define RTD_B_USINDUSTRIAL  -5.8495e-7
#define RTD_B_DIN43760      -5.8019e-7
/* RTD coefficient C is required only for temperatures
   below 0 deg. C.  The selected RTD coefficient set
   is specified below. */
#define SELECT_RTD_HELPER(x) x
#define SELECT_RTD(x) SELECT_RTD_HELPER(x)
#define RTD_A         SELECT_RTD(RTD_A_ITS90)
#define RTD_B         SELECT_RTD(RTD_B_ITS90)

#define RTD_RESISTANCE_PT100   100 /* Ohm */
#define RTD_RESISTANCE_PT1000 1000 /* Ohm */

const uint8_t CONFIG_RD_ADDR = 0x00;
const uint8_t CONFIG_WR_ADDR = 0x80;
const uint8_t THRESHOLD_WR_ADDR = 0x83;
const uint8_t RTD_RD_ADDR = 0x01;

/* Configure:
     V_BIAS enabled
     Auto-conversion
     1-shot disabled
     3-wire enabled
     Fault detection:  automatic delay
     Fault status:  auto-clear
     50 Hz filter
     Low threshold:  0x0000
     High threshold:  0x7fff
*/
const uint8_t CONFIGURATION = 0xD3;
const uint8_t THREASHOLDS[] = {0x00, 0x00, 0x7f, 0xff};
}

namespace Brewing
{

class TempSensor::Data
{
public:
    int m_spi_fd;
    double m_temp = qQNaN();
    QTimer *m_timer_p;

    int Write(uint8_t reg, uint8_t value);
    int Write(uint8_t reg, uint16_t value);
    int Write(uint8_t reg, const uint8_t *values_p, uint32_t len);
    int Write(uint8_t *rx_p, uint32_t len);
    int Read(uint8_t reg, uint8_t &value);
    int Read(uint8_t reg, uint16_t &value);
    int Read(uint8_t reg, uint8_t *rx_p, uint32_t len);
};

TempSensor::TempSensor(uint8_t device, uint8_t cs) : QObject(), d(new Data)
{
    int retval = 0;
    unsigned char spi_mode = SPI_MODE_0;
    unsigned char spi_bpw = 8;
    unsigned int spi_speed = 1000000;
    QString dev_device = QString("/dev/spidev%1.%2").arg(device).arg(cs);
    d->m_spi_fd = open(dev_device.toStdString().c_str(), O_RDWR);
    if (d->m_spi_fd < 0)
    {
        qWarning() << "Failed to open spi device:" << dev_device;
        return;
    }

    retval = ioctl(d->m_spi_fd, SPI_IOC_WR_MODE, &spi_mode);
    if(retval < 0)
    {
        qWarning() << "Could not set SPIMode (WR)..." << dev_device;
        return;
    }

    retval = ioctl(d->m_spi_fd, SPI_IOC_RD_MODE, &spi_mode);
    if(retval < 0)
    {
        qWarning() << "Could not set SPIMode (RD)..." << dev_device;
        return;
    }

    retval = ioctl(d->m_spi_fd, SPI_IOC_WR_BITS_PER_WORD, &spi_bpw);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI bitsPerWord (WR)..." << dev_device;
        return;
    }

    retval = ioctl(d->m_spi_fd, SPI_IOC_RD_BITS_PER_WORD, &spi_bpw);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI bitsPerWord(RD)..." << dev_device;
        return;
    }

    retval = ioctl(d->m_spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &spi_speed);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI speed (WR)..." << dev_device;
        return;
    }

    retval = ioctl(d->m_spi_fd, SPI_IOC_RD_MAX_SPEED_HZ, &spi_speed);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI speed (RD)..." << dev_device;
        return;
    }

    QTimer::singleShot(0, this, &TempSensor::Init);
}

TempSensor::~TempSensor()
{
    close(d->m_spi_fd);
}

double TempSensor::GetTemp() const
{
    return d->m_temp;
}

void TempSensor::Init()
{
    int retval = EXIT_SUCCESS;
    uint8_t config_value = 0;
    if (d->m_spi_fd < 0)

    {
        qWarning() << "Failed to initialize spi device.";
        return;
    }

    retval |= libsoc_spi_set_bits_per_word(d->m_spi_p, BITS_8);
    retval |= libsoc_spi_set_mode(d->m_spi_p, MODE_3);

    QThread::msleep(100);

    retval |= d->Write(CONFIG_WR_ADDR, CONFIGURATION);
    retval |= d->Read(CONFIG_RD_ADDR, config_value);
    qDebug() << "Config Read: " << QString::number(config_value, 16);


    retval |= d->Write(THRESHOLD_WR_ADDR, THREASHOLDS, sizeof(THREASHOLDS));

    if (retval != EXIT_SUCCESS)
    {
        qWarning() << "Failed to configure spi device " <<
                      d->m_spi_p->spi_dev << d->m_spi_p->chip_select;
        return;
    }

    d->m_timer_p = new QTimer(this);
    connect(d->m_timer_p, &QTimer::timeout, this, &TempSensor::ReadTemp);
    d->m_timer_p->start(1000);
}

void TempSensor::ReadTemp()
{
    uint16_t resistance;
    int retval = d->Read(RTD_RD_ADDR, resistance);
    if (retval)
    {
        d->m_temp = qQNaN();
        return;
    }

    static const double a2   = 2.0 * RTD_B;
    static const double b_sq = RTD_A * RTD_A;
    double c = 1.0 - resistance / RTD_RESISTANCE_PT1000;
    double D = b_sq - 2.0 * a2 * c;
    d->m_temp = (-RTD_A + sqrt(D)) / a2;
}

int TempSensor::Data::Write(uint8_t reg, uint8_t value)
{
    uint8_t buff[2];
    buff[0] = reg;
    buff[1] = value;
    return Write(buff, 2);
}

int TempSensor::Data::Write(uint8_t reg, uint16_t value)
{
    uint8_t buff[3];
    buff[0] = reg;
    buff[1] = (value >> 8) & 0x00ff;
    buff[2] = value & 0x00ff;
    return Write(buff, 3);
}

int TempSensor::Data::Write(uint8_t reg, const uint8_t *values_p, uint32_t len)
{
    uint8_t buff[256];
    buff[0] = reg;
    for (uint32_t i = 0; i < len; i++)
    {
        buff[i+1] = values_p[i];
    }
    return Write(buff, len + 1);
}

int TempSensor::Data::Write(uint8_t *rx_p, uint32_t len)
{
    if (!m_spi_p)
    {
        return EXIT_FAILURE;
    }

    return libsoc_spi_write(m_spi_p, rx_p, len);
}

int TempSensor::Data::Read(uint8_t reg, uint8_t &value)
{
    int retval = Read(reg, &value, 1);
    return retval;
}

int TempSensor::Data::Read(uint8_t reg, uint16_t &value)
{
    uint8_t buff[2];
    int retval = Read(reg, buff, 2);
    value = static_cast<uint16_t>(buff[0] << 8);
    value |= buff[1];
    return retval;
}

int TempSensor::Data::Read(uint8_t reg, uint8_t *rx_p, uint32_t len)
{
    if (!m_spi_p)
    {
        return EXIT_FAILURE;
    }

    return libsoc_spi_rw(m_spi_p, &reg, rx_p, len);
}

} // namespace Brewing
