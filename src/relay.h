#pragma once

namespace Brewing
{

class Relay
{
public:
    Relay(int gpio);
    virtual ~Relay();

    void setEnable(bool enable);
    bool enabled() const;

private:
    bool m_gpio_num;
};

} // namespace Brewing
