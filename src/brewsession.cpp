#include "brewsession.h"

#include <QStateMachine>

#include "brewstep.h"

namespace Brewing
{

class BrewSession::Data
{
public:
    BrewSteps m_steps;
    int m_current_idx;
    int m_seconds;
    bool m_elapsed;

    Data() : m_current_idx(-1), m_seconds(0)
    {

    }

    ~Data()
    {
        qDeleteAll(m_steps);
    }

    Step *CurrentStep()
    {
        if ((m_current_idx >= 0) && (m_current_idx < m_steps.count()))
        {
            return m_steps[m_current_idx];
        }
        return nullptr;
    }
};

BrewSession::BrewSession() : QObject(), d(new Data)
{
    Step *mash_in_p = new Step("Mash In");
    mash_in_p->setSetpoint(73.9);
    mash_in_p->setTimerInterval(600);
    d->m_steps.append(mash_in_p);

    Step *mash_p = new Step("Mash");
    mash_p->setSetpoint(68.4);
    mash_p->setTimerInterval(3600);
    d->m_steps.append(mash_p);

    Step *mash_out_p = new Step("Mash Out");
    mash_out_p->setSetpoint(79.5);
    d->m_steps.append(mash_out_p);

    Step *sparge_p = new Step("Sparge");
    sparge_p->setSetpoint(79.5);
    d->m_steps.append(sparge_p);

    Step *boil_p = new Step("Boil");
    boil_p->setSetpoint(100);
    boil_p->setTimerInterval(60000);
    d->m_steps.append(boil_p);

    Step *cool_p = new Step("Cool");
    cool_p->setSetpoint(18.4);
    d->m_steps.append(cool_p);
}

BrewSession::~BrewSession()
{

}

QList<QObject*> BrewSession::steps()
{
    QList<QObject*> objects;
    for (int i = 0; i < d->m_steps.count(); ++i)
    {
        objects.append(d->m_steps[i]);
    }
    return objects;
}

bool BrewSession::running() const
{
    return (d->m_current_idx >= 0) &&
            (d->m_current_idx < d->m_steps.count());
}

bool BrewSession::finished() const
{
    return d->m_current_idx == d->m_steps.count();
}

double BrewSession::setpoint() const
{
    if (running())
    {
        return d->m_steps[d->m_current_idx]->setpoint();
    }
    return qQNaN();
}

int BrewSession::elapsedTimeSec() const
{
    return d->m_seconds;
}

int BrewSession::volume() const
{
    if (running())
    {
        return d->m_steps[d->m_current_idx]->volume();
    }
    return 0;
}

void BrewSession::timerEvent(QTimerEvent *event)
{

}

void BrewSession::begin()
{
    if (running() || (d->m_current_idx == d->m_steps.count()))
    {
        return;
    }
    d->m_current_idx = 0;
    d->m_steps[d->m_current_idx]->setActive(true);
    emit setpointChanged(d->m_steps[d->m_current_idx]->setpoint());
    emit runningChanged(running());
}

void BrewSession::nextStep()
{
    if (!running())
    {
        return;
    }
    d->m_steps[d->m_current_idx++]->setComplete(true);
    if (d->m_current_idx < d->m_steps.count())
    {
        d->m_steps[d->m_current_idx]->setActive(true);
        emit setpointChanged(d->m_steps[d->m_current_idx]->setpoint());
    }
    else
    {
        emit finishedChanged(d->m_current_idx == d->m_steps.count());
    }
}

} // namespace Brewing
