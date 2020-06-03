#include "brewstep.h"

namespace Brewing
{

class Step::Data
{
public:
    QString m_name;
    double m_setpoint;
    double m_volume;
    int m_timer_interval;
    bool m_active;
    bool m_complete;

    Data(const QString &name) :
        m_name(name),
        m_setpoint(qQNaN()),
        m_volume(qQNaN()),
        m_timer_interval(0),
        m_active(false),
        m_complete(false)
    {
    }
};

Step::Step(const QString &name) : QObject(), d(new Data(name))
{

}

Step::~Step()
{

}

QString Step::name() const
{
    return d->m_name;
}

double Step::setpoint() const
{
    return d->m_setpoint;
}

double Step::volume() const
{
    return d->m_volume;
}

int Step::timerInterval() const
{
    return d->m_timer_interval;
}

bool Step::active() const
{
    return d->m_active;
}

bool Step::complete() const
{
    return d->m_complete;
}

void Step::setSetpoint(double setpoint)
{
    if (d->m_setpoint != setpoint)
    {
        d->m_setpoint = setpoint;
        emit setpointChanged(setpoint);
    }
}

void Step::setVolume(double volume)
{
    if (d->m_volume != volume)
    {
        d->m_volume = volume;
        emit volumeChanged(volume);
    }
}

void Step::setTimerInterval(int seconds)
{
    d->m_timer_interval = seconds;
}

void Step::setActive(bool active)
{
    if (d->m_active != active)
    {
        d->m_active = active;
        emit activeChanged(active);
    }
}

void Step::setComplete(bool complete)
{
    if (d->m_complete != complete)
    {
        d->m_active = false;
        d->m_complete = complete;
        emit completeChanged(complete);
        emit activeChanged(false);
    }
}

} // namespace Brewing
