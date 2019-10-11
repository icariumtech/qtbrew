#include "brewingcontroller.h"

#include "relay.h"

namespace Brewing
{

class Controller::Data
{
public:
    Relay m_hlt_element;
    Relay m_boil_element;

    Relay m_water_pump;
    Relay m_wort_pump;

    Data();
};

Controller::Controller() : QObject(), d(new Data)
{
}

Controller::~Controller()
{

}

Controller::Data::Data() :
    m_hlt_element(20),
    m_boil_element(21),
    m_water_pump(23),
    m_wort_pump(24)
{

}

}

