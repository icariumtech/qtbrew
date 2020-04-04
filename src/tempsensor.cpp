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
const uint8_t MAX31856_CONFIG_REG = 0x00;
const uint8_t MAX31856_CONFIG_BIAS = 0x80;
const uint8_t MAX31856_CONFIG_MODEAUTO = 0x40;
const uint8_t MAX31856_CONFIG_MODEOFF = 0x00;
const uint8_t MAX31856_CONFIG_1SHOT = 0x20;
const uint8_t MAX31856_CONFIG_3WIRE = 0x10;
const uint8_t MAX31856_CONFIG_FAULTSTAT = 0x02;

const uint8_t MAX31856_RTDMSB_REG = 0x01;

const double RTD_A = 3.9083e-3;
const double RTD_B = -5.775e-7;

const unsigned char SPI_BPW = 8;
const unsigned int SPI_SPEED = 500000;

enum NumWires
{
  MAX31865_2WIRE = 0,
  MAX31865_3WIRE = 1,
  MAX31865_4WIRE = 0
};
}

namespace Brewing
{

class TempSensor::Data
{
public:
    int m_spi_fd;
    QString m_device;
    double m_temp = qQNaN();
    QTimer *m_timer_p;

    bool ConfigureSpi();
    bool SetWires(NumWires wires);
    bool EnableBias(bool enable);
    bool AutoConvert(bool enable);
    void ClearFault();

    double ReadTemp();
    double ReadRtd();

    int WriteRegister8(uint8_t reg, uint8_t value);
    int ReadRegister8(uint8_t reg, uint8_t &value);
    int ReadRegister16(uint8_t reg, uint16_t &value);
    int SpiReadWrite(uint8_t *data, int len);
};

TempSensor::TempSensor(uint8_t device, uint8_t cs) : QObject(), d(new Data)
{
    d->m_device = QString("/dev/spidev%1.%2").arg(device).arg(cs);
}

TempSensor::~TempSensor()
{
    close(d->m_spi_fd);
}

double TempSensor::Temp() const
{
    return d->m_temp;
}

void TempSensor::Init()
{
    if (!d->ConfigureSpi()) { return; }

    if (!d->SetWires(MAX31865_3WIRE)) { return; }
    if (!d->EnableBias(false)) { return; }
    if (!d->AutoConvert(false)) { return; }
    d->ClearFault();

    uint8_t value;
    d->ReadRegister8(0x30, value);

    d->m_timer_p = new QTimer(this);
    d->m_timer_p->setInterval(1000);
    connect(d->m_timer_p, &QTimer::timeout, this, &TempSensor::ComputeTemp);
    d->m_timer_p->start();
}

void TempSensor::ComputeTemp()
{
    double temp = d->ReadTemp();
    if (d->m_temp != temp)
    {
        d->m_temp = temp;
        emit TempChanged(d->m_temp);
    }
}

bool TempSensor::Data::ConfigureSpi()
{
    int retval = -1;
    unsigned char spi_mode = SPI_MODE_1;
    unsigned char spi_bpw = SPI_BPW;
    unsigned int spi_speed = SPI_SPEED;

    m_spi_fd = open(m_device.toStdString().c_str(), O_RDWR);
    if (m_spi_fd <= 0)
    {
        qWarning() << "Could not open SPI device:" << m_device;
        return false;
    }

    retval = ioctl(m_spi_fd, SPI_IOC_WR_MODE, &spi_mode);
    if (retval < 0)
    {
        qWarning() << "Could not set SPI Mode (WR)";
        return false;
    }

    retval = ioctl(m_spi_fd, SPI_IOC_RD_MODE, &spi_mode);
    if(retval < 0)
    {
        qWarning() << "Could not set SPIMode (RD)";
        return false;
    }

    retval = ioctl(m_spi_fd, SPI_IOC_WR_BITS_PER_WORD, &spi_bpw);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI bitsPerWord (WR)";
        return false;
    }

    retval = ioctl(m_spi_fd, SPI_IOC_RD_BITS_PER_WORD, &spi_bpw);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI bitsPerWord(RD): " << retval;
        return false;
    }

    retval = ioctl(m_spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &spi_speed);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI speed (WR)";
        return false;
    }

    retval = ioctl(m_spi_fd, SPI_IOC_RD_MAX_SPEED_HZ, &spi_speed);
    if(retval < 0)
    {
        qWarning() << "Could not set SPI speed (RD)";
        return false;
    }

    return true;
}

bool TempSensor::Data::SetWires(NumWires wires)
{
    uint8_t config = 0;
    int retval = ReadRegister8(MAX31856_CONFIG_REG, config);
    if (retval < 0)
    {
        qWarning() << "Could not read config register";
        return false;
    }

    if (wires == MAX31865_3WIRE)
    {
        config |= MAX31856_CONFIG_3WIRE;
    }
    else
    {
        config &= ~MAX31856_CONFIG_3WIRE;
    }

    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval < 0)
    {
        qWarning() << "Could not set wire configuration";
        return false;
    }
    return true;
}

bool TempSensor::Data::EnableBias(bool enable)
{
    uint8_t config = 0;
    int retval = ReadRegister8(MAX31856_CONFIG_REG, config);
    if (retval < 0)
    {
        qWarning() << "Could not read config register";
        return false;
    }

    if (enable)
    {
        config |= MAX31856_CONFIG_BIAS;
    }
    else
    {
        config &= ~MAX31856_CONFIG_BIAS;
    }

    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval < 0)
    {
        qWarning() << "Could not set bias";
        return false;
    }
    return true;
}

bool TempSensor::Data::AutoConvert(bool enable)
{
    uint8_t config = 0;
    int retval = ReadRegister8(MAX31856_CONFIG_REG, config);
    if (retval < 0)
    {
        qWarning() << "Could not read config register";
        return false;
    }

    if (enable)
    {
        config |= MAX31856_CONFIG_MODEAUTO;
    }
    else
    {
        config &= ~MAX31856_CONFIG_MODEOFF;
    }

    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval < 0)
    {
        qWarning() << "Could not set auto convert";
        return false;
    }
    return true;
}

void TempSensor::Data::ClearFault()
{
    uint8_t config = 0;
    int retval = ReadRegister8(MAX31856_CONFIG_REG, config);
    if (retval < 0)
    {
        qWarning() << "Could not read config register";
        return;
    }

    config &= ~0x2C;
    config |= MAX31856_CONFIG_FAULTSTAT;
    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval < 0)
    {
        qWarning() << "Could not set auto convert";
    }
}

double TempSensor::Data::ReadTemp()
{
    double Z1, Z2, Z3, Z4, Rt, temp;
    double ref_resistor = 430;
    double rtd_nominal = 100;

    Rt = ReadRtd();
    if (qIsNaN(Rt))
    {
        return qQNaN();
    }

    Rt /= 32768;
    Rt *= ref_resistor;

    Z1 = -RTD_A;
    Z2 = RTD_A * RTD_A - (4 * RTD_B);
    Z3 = (4 * RTD_B) / rtd_nominal;
    Z4 = 2 * RTD_B;

    temp = Z2 + (Z3 * Rt);
    temp = (sqrt(temp) + Z1) / Z4;

    if (temp >= 0)
      return temp;

    Rt /= rtd_nominal;
    Rt *= 100; // normalize to 100 ohm

    float rpoly = Rt;

    temp = -242.02;
    temp += 2.2228 * rpoly;
    rpoly *= Rt; // square
    temp += 2.5859e-3 * rpoly;
    rpoly *= Rt; // ^3
    temp -= 4.8260e-6 * rpoly;
    rpoly *= Rt; // ^4
    temp -= 2.8183e-8 * rpoly;
    rpoly *= Rt; // ^5
    temp += 1.5243e-10 * rpoly;

    return temp;
}

double TempSensor::Data::ReadRtd()
{
    uint8_t config;
    uint16_t rtd;

    ClearFault();
    EnableBias(true);
    QThread::msleep(10);

    int retval = ReadRegister8(MAX31856_CONFIG_REG, config);
    if (retval < 0)
    {
        qWarning() << "Could not read config register";
        return qQNaN();
    }
    config |= MAX31856_CONFIG_1SHOT;
    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval < 0)
    {
        qWarning() << "Could not set one shot";
        return qQNaN();
    }

    retval = ReadRegister16(MAX31856_RTDMSB_REG, rtd);
    if (retval < 0)
    {
        qWarning() << "Could not get rtd register";
        return qQNaN();
    }
    rtd >>= 1;

    if (rtd == 0x7FFF)
    {
        return qQNaN();
    }
    return static_cast<double>(rtd);
}

int TempSensor::Data::WriteRegister8(uint8_t reg, uint8_t value)
{
    uint8_t buff[2];
    buff[0] = reg | 0x80;
    buff[1] = value;

    return SpiReadWrite(buff, 2);
}

int TempSensor::Data::ReadRegister8(uint8_t reg, uint8_t &value)
{
    uint8_t buff[2] = {0, 0};
    buff[0] = reg & 0x7f;
    int retval = SpiReadWrite(buff, 2);
    value = buff[1];
    return retval;
}

int TempSensor::Data::ReadRegister16(uint8_t reg, uint16_t &value)
{
    uint8_t buff[3] = {0, 0, 0};
    reg &= 0x7F;
    buff[0] = reg & 0x7f;
    int retval = SpiReadWrite(buff, 3);
    if (retval < 0)
    {
        return retval;
    }

    value = buff[1];
    value <<= 8;
    value |= buff[2];

    return retval;
}

int TempSensor::Data::SpiReadWrite(uint8_t *data, int len)
{
    int retval = 0;
    struct spi_ioc_transfer spi_xfer;

    QByteArray ba_before((char*)data, len);

    memset (&spi_xfer, 0, sizeof (spi_xfer)) ;

    spi_xfer.tx_buf        = (unsigned long)data ;
    spi_xfer.rx_buf        = (unsigned long)data ;
    spi_xfer.len           = len ;
    spi_xfer.delay_usecs   = 0 ;
    spi_xfer.speed_hz      = SPI_SPEED ;
    spi_xfer.bits_per_word = SPI_BPW ;

    retval = ioctl(m_spi_fd, SPI_IOC_MESSAGE(1), &spi_xfer);

    QByteArray ba_after((char*)data, len);

    return retval;
}

} // namespace Brewing
