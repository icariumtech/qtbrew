#include "brewingcontroller.h"

#include <QThread>
#include <QTimer>

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

    QThread m_temp_thread;

    Data();
    ~Data();
};

Controller::Controller() : QObject(), d(new Data)
{
}

Controller::~Controller()
{

}

Controller::Data::Data() :
    m_hlt_element(6),
    m_boil_element(13),
    m_water_pump(19),
    m_wort_pump(26),
    m_hlt_temp(0, 0),
    m_mash_lower_temp(0, 1),
    m_mash_upper_temp(0, 2),
    m_boil_temp(0, 3)
{
    m_hlt_temp.moveToThread(&m_temp_thread);
    m_mash_lower_temp.moveToThread(&m_temp_thread);
    m_mash_upper_temp.moveToThread(&m_temp_thread);
    m_boil_temp.moveToThread(&m_temp_thread);
    m_temp_thread.start();

    QTimer::singleShot(0, &m_hlt_temp, &TempSensor::Init);
    QTimer::singleShot(0, &m_mash_lower_temp, &TempSensor::Init);
    QTimer::singleShot(0, &m_mash_upper_temp, &TempSensor::Init);
    QTimer::singleShot(0, &m_boil_temp, &TempSensor::Init);
}

Controller::Data::~Data()
{
    m_temp_thread.quit();
    m_temp_thread.wait();
}

}

