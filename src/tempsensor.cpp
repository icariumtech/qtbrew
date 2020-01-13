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
const uint8_t MAX31856_CONFIG_24WIRE = 0x00;
const uint8_t MAX31856_CONFIG_FAULTSTAT = 0x02;
const uint8_t MAX31856_CONFIG_FILT50HZ = 0x01;
const uint8_t MAX31856_CONFIG_FILT60HZ = 0x00;

const uint8_t MAX31856_RTDMSB_REG = 0x01;
const uint8_t MAX31856_RTDLSB_REG = 0x02;
const uint8_t MAX31856_HFAULTMSB_REG = 0x03;
const uint8_t MAX31856_HFAULTLSB_REG = 0x04;
const uint8_t MAX31856_LFAULTMSB_REG = 0x05;
const uint8_t MAX31856_LFAULTLSB_REG = 0x06;
const uint8_t MAX31856_FAULTSTAT_REG = 0x07;

const uint8_t MAX31865_FAULT_HIGHTHRESH = 0x80;
const uint8_t MAX31865_FAULT_LOWTHRESH = 0x40;
const uint8_t MAX31865_FAULT_REFINLOW = 0x20;
const uint8_t MAX31865_FAULT_REFINHIGH = 0x10;
const uint8_t MAX31865_FAULT_RTDINLOW = 0x08;
const uint8_t MAX31865_FAULT_OVUV = 0x04;

const double RTD_A = 3.9083e-3;
const double RTD_B = -5.775e-7;

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
    int WriteRegisterN(uint8_t *values_p, uint32_t len);
    int ReadRegister8(uint8_t reg, uint8_t &value);
    int ReadRegister16(uint8_t reg, uint16_t &value);
    int ReadRegisterN(uint8_t reg, uint8_t *rx_p, uint32_t len);
};

TempSensor::TempSensor(uint8_t device, uint8_t cs) : QObject(), d(new Data)
{
    d->m_device = QString("/dev/spidev%1.%2").arg(device).arg(cs);
}

TempSensor::~TempSensor()
{
    close(d->m_spi_fd);
}

double TempSensor::GetTemp() const
{
    return d->ReadTemp();
}

void TempSensor::Init()
{
    if (!d->ConfigureSpi()) { return; }

    if (!d->SetWires(MAX31865_3WIRE)) { return; }
    if (!d->EnableBias(false)) { return; }
    if (!d->AutoConvert(false)) { return; }
    d->ClearFault();
}

bool TempSensor::Data::ConfigureSpi()
{
    int retval = -1;
    unsigned char spi_mode = SPI_MODE_1;
    unsigned char spi_bpw = 8;
    unsigned int spi_speed = 500000;

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
        qWarning() << "Could not set SPI bitsPerWord(RD)";
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
    if (retval != 1)
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

    if (retval != 2)
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
    if (retval != 1)
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

    if (retval != 2)
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
    if (retval != 1)
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

    if (retval != 2)
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
    if (retval != 1)
    {
        qWarning() << "Could not read config register";
        return;
    }

    config &= ~0x2C;
    config |= MAX31856_CONFIG_FAULTSTAT;
    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval != 2)
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
    if (retval != 1)
    {
        qWarning() << "Could not read config register";
        return qQNaN();
    }
    config |= MAX31856_CONFIG_1SHOT;
    retval = WriteRegister8(MAX31856_CONFIG_REG, config);

    if (retval != 2)
    {
        qWarning() << "Could not set one shot";
        return qQNaN();
    }

    retval = ReadRegister16(MAX31856_RTDMSB_REG, rtd);
    if (retval != 2)
    {
        qWarning() << "Could not get rtd register";
        return qQNaN();
    }
    rtd >>= 1;

    return static_cast<double>(rtd);
}

int TempSensor::Data::WriteRegister8(uint8_t reg, uint8_t value)
{
    uint8_t buff[2];
    buff[0] = reg;
    buff[1] = value;
    return WriteRegisterN(buff, 2);
}

int TempSensor::Data::WriteRegisterN(uint8_t *values_p, uint32_t len)
{
    struct spi_ioc_transfer spi_xfer;
    spi_xfer.tx_buf = (unsigned long)values_p;
    spi_xfer.rx_buf = 0;
    spi_xfer.len = len;
    spi_xfer.delay_usecs = 0;
    spi_xfer.speed_hz = 10000;

    return 0;
}

int TempSensor::Data::ReadRegister8(uint8_t reg, uint8_t &value)
{
    int retval = ReadRegisterN(reg, &value, 1);
    return retval;
}

int TempSensor::Data::ReadRegister16(uint8_t reg, uint16_t &value)
{
    uint8_t buff[2];
    int retval = ReadRegisterN(reg, buff, 2);
    value = static_cast<uint16_t>(buff[0] << 8);
    value |= buff[1];
    return retval;
}

int TempSensor::Data::ReadRegisterN(uint8_t reg, uint8_t *rx_p, uint32_t len)
{
//    if (!m_spi_p)
//    {
//        return EXIT_FAILURE;
//    }

//    return libsoc_spi_rw(m_spi_p, &reg, rx_p, len);
    return 0;
}

} // namespace Brewing
