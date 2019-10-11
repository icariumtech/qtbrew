#include "relay.h"

#include <gpiod.h>

#include <QDebug>

namespace Brewing
{

Relay::Relay(int gpio) : m_gpio_num(gpio)
{
    gpiod_ctxless_set_value("/dev/gpiochip0", m_gpio_num, 0,
                            false, "qtbrew", nullptr, nullptr);
}

Relay::~Relay()
{

}

void Relay::setEnable(bool enable)
{
    int retval = gpiod_ctxless_set_value("/dev/gpiochip0", m_gpio_num,
                    enable ? 1 : 0, false, "qtbrew", nullptr, nullptr);
    if (retval < 0)
    {
        qWarning() << "Failed to set gpio " << m_gpio_num << " value";
    }
}

bool Relay::enabled() const
{
    int retval = gpiod_ctxless_get_value("/dev/gpiochip0", m_gpio_num,
                                         false, "qtbrew");
    if (retval < 0)
    {
        qWarning() << "Failed to get gpio " << m_gpio_num << " value";
    }
    return retval == 1;
}

} // namespace Brewing
