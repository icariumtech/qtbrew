#pragma once

#include <memory>

#include <QString>

namespace Brewing
{

class Relay
{
public:
    Relay(int gpio, const QString name);
    virtual ~Relay();

    void setEnable(bool enable);
    bool enabled() const;

private:
    class Data;
    std::unique_ptr<Data> d;
};

} // namespace Brewing
