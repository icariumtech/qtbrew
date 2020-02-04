#pragma once

#include <QObject>

namespace Brewing
{

class Relay;
class TempSensor;

class Pid : public QObject
{
    Q_OBJECT

public:
    Pid(QString name, TempSensor *sensor_p, Relay *relay_p);
    virtual ~Pid();

    void SetEnabled(bool enable);
    void SetSetpoint(double degrees_c);

    double Kp();
    double Ki();
    double Kd();

private slots:
    void Compute();

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Brewing

