#include "relay.h"

#include <linux/gpio.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#include <QDebug>
#include <QString>

namespace Brewing
{

class Relay::Data
{
public:
    int m_fd;
    struct gpiohandle_request m_request;
    struct gpiohandle_data m_data;
};

Relay::Relay(int gpio, const QString name) : d(new Data)
{
    d->m_fd = open("/dev/gpiochip0", O_RDONLY);
    if (d->m_fd == -1)
    {
        qWarning() << "Failed to open /dev/gpiochip0";
    }

    d->m_request.lineoffsets[0] = gpio;
    d->m_request.lines = 1;
    d->m_request.flags = GPIOHANDLE_REQUEST_OUTPUT |
            GPIOHANDLE_REQUEST_ACTIVE_LOW;
    strcpy(d->m_request.consumer_label, name.toUtf8().data());
    if (ioctl(d->m_fd, GPIO_GET_LINEHANDLE_IOCTL, &d->m_request) == -1)
    {
        qWarning() << "Failed to get line" << name <<
                      "at offset" << QString::number(gpio);
    }
    setEnabled(false);
}

Relay::~Relay()
{

}

void Relay::setEnabled(bool enable)
{
    d->m_data.values[0] = enable ? 1 : 0;

    int retval = ioctl(d->m_request.fd,
                       GPIOHANDLE_SET_LINE_VALUES_IOCTL, &d->m_data);
    if (retval < 0)
    {
        qWarning() << "Failed to set gpio " <<
                      d->m_request.lineoffsets[0] << " value";
    }
    emit enabledChanged(enable);
}

bool Relay::enabled() const
{
    return d->m_data.values[0] == 1;
}

} // namespace Brewing
