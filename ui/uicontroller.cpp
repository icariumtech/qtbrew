#include "uicontroller.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>

#include "brewingcontroller.h"
#include "tempsensor.h"
#include "radialbar.h"
#include "relay.h"

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

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");

    QScreen *screen_p = qApp->primaryScreen();
    int dpi = screen_p->logicalDotsPerInch() * screen_p->devicePixelRatio();
    qreal dp = dpi / 160.0;

    m_engine.rootContext()->setContextProperty("dp", dp);
    m_engine.rootContext()->setContextProperty(
                "hlt", controller_p->HltTempSensor());
    m_engine.rootContext()->setContextProperty(
                "mashLower", controller_p->MashLowerTempSensor());
    m_engine.rootContext()->setContextProperty(
                "mashUpper", controller_p->MashUpperTempSensor());
    m_engine.rootContext()->setContextProperty(
                "boil", controller_p->BoilTempSensor());

    m_engine.rootContext()->setContextProperty(
                "waterPump", controller_p->WaterPump());
    m_engine.rootContext()->setContextProperty(
                "wortPump", controller_p->WortPump());

    m_engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
}

} // namespace Ui
