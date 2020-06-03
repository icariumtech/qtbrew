#include "uicontroller.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>

#include "brewingcontroller.h"
#include "brewsession.h"
#include "tempsensor.h"
#include "radialbar.h"
#include "relay.h"
#include "setpointgraph.h"

namespace Ui
{

class Controller::Data
{
public:
    QQmlApplicationEngine m_engine;
    SetpointGraph m_setpoint_graph;

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

    QObject::connect(controller_p->Session(),
                     &Brewing::BrewSession::setpointChanged,
                     &m_setpoint_graph, &SetpointGraph::setSetpoint);

    QQmlContext *ctxt = m_engine.rootContext();

    ctxt->setContextProperty("dp", dp);

    ctxt->setContextProperty("hlt", controller_p->HltTempSensor());
    ctxt->setContextProperty("mashLower", controller_p->MashLowerTempSensor());
    ctxt->setContextProperty("mashUpper", controller_p->MashUpperTempSensor());
    ctxt->setContextProperty("boil", controller_p->BoilTempSensor());

    ctxt->setContextProperty("waterPump", controller_p->WaterPump());
    ctxt->setContextProperty("wortPump", controller_p->WortPump());

    ctxt->setContextProperty("brewSession", controller_p->Session());
    ctxt->setContextProperty("brewStepsModel",
        QVariant::fromValue(controller_p->Session()->steps()));

    ctxt->setContextProperty("tempData", &m_setpoint_graph);

    m_engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
}

} // namespace Ui
