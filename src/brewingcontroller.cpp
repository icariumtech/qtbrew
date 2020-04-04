#include "brewingcontroller.h"

#include <QDebug>
#include <QThread>
#include <QTimer>

#include "pid.h"
#include "relay.h"
#include "tempsensor.h"

namespace Brewing
{

class Controller::Data
{
public:
    Relay m_hlt_element;
    Relay m_boil_element;

    Relay m_water_pump;
    Relay m_wort_pump;

    TempSensor m_hlt_temp;
    TempSensor m_mash_lower_temp;
    TempSensor m_mash_upper_temp;
    TempSensor m_boil_temp;

    Pid m_hlt_pid;
    Pid m_mash_pid;
    Pid m_boil_pid;

    QThread m_pid_thread;

    Data();
    ~Data();
};

Controller::Controller() : QObject(), d(new Data)
{
}

Controller::~Controller()
{

}

TempSensor *Controller::HltTempSensor()
{
    return &d->m_hlt_temp;
}

TempSensor *Controller::MashLowerTempSensor()
{
    return &d->m_mash_lower_temp;
}

TempSensor *Controller::MashUpperTempSensor()
{
    return &d->m_mash_upper_temp;
}

TempSensor *Controller::BoilTempSensor()
{
    return &d->m_boil_temp;
}

Relay *Controller::WaterPump()
{
    return &d->m_water_pump;
}

Relay *Controller::WortPump()
{
    return &d->m_wort_pump;
}

Controller::Data::Data() :
    m_hlt_element(27, "hlt"),
    m_boil_element(26, "boil"),
    m_water_pump(13, "water"),
    m_wort_pump(21, "wort"),
    m_hlt_temp(0, 0),
    m_mash_lower_temp(0, 1),
    m_mash_upper_temp(0, 2),
    m_boil_temp(0, 3),
    m_hlt_pid("hlt", &m_hlt_temp, &m_hlt_element),
    m_mash_pid("mash", &m_mash_lower_temp, &m_hlt_element),
    m_boil_pid("boil", &m_boil_temp, &m_boil_element)
{
    QTimer::singleShot(0, &m_hlt_temp, &TempSensor::Init);
    QTimer::singleShot(0, &m_mash_lower_temp, &TempSensor::Init);
    QTimer::singleShot(0, &m_boil_temp, &TempSensor::Init);

    m_hlt_pid.moveToThread(&m_pid_thread);
    m_mash_pid.moveToThread(&m_pid_thread);
    m_boil_pid.moveToThread(&m_pid_thread);
    m_pid_thread.start();
}

Controller::Data::~Data()
{
    m_pid_thread.quit();
    m_pid_thread.wait();
}

}

