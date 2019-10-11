#include "uicontroller.h"

#include <QQmlApplicationEngine>

#include "brewingcontroller.h"

namespace Ui
{

class Controller::Data
{
public:
    QQmlApplicationEngine m_engine;

    Data(Brewing::Controller *controller_p);
};

Controller::Controller(Brewing::Controller *controller_p) :
    QObject(), d(new Data(controller_p))
{

}

Controller::~Controller()
{

}

Controller::Data::Data(Brewing::Controller *controller_p)
{
    (void)controller_p;
    m_engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
}

} // namespace Ui
