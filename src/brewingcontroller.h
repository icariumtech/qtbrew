#pragma once

#include <QObject>
#include <QScopedPointer>

namespace Brewing
{

class TempSensor;
class Relay;
class BrewSession;

class Controller : public QObject
{
    Q_OBJECT

public:
    Controller();
    virtual ~Controller();

    TempSensor *HltTempSensor();
    TempSensor *MashLowerTempSensor();
    TempSensor *MashUpperTempSensor();
    TempSensor *BoilTempSensor();

    Relay *WaterPump();
    Relay *WortPump();

    BrewSession *Session();

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Brewing
