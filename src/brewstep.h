#pragma once

#include <QAbstractState>
#include <QScopedPointer>

namespace Brewing
{

class Step : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(double setpoint READ setpoint WRITE setSetpoint
               NOTIFY setpointChanged)
    Q_PROPERTY(double volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(int timerInerval READ timerInterval WRITE setTimerInterval
               NOTIFY timerIntervalChanged)
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(bool complete READ complete WRITE setComplete
               NOTIFY completeChanged)

public:
    Step(const QString &name);
    virtual ~Step();

    QString name() const;
    double setpoint() const;
    double volume() const;
    int timerInterval() const;
    bool active() const;
    bool complete() const;

    void setSetpoint(double setpoint);
    void setVolume(double volume);
    void setTimerInterval(int seconds);
    void setActive(bool active);
    void setComplete(bool complete);

signals:
    void nameChanged(QString name);
    void setpointChanged(double setpoint);
    void volumeChanged(double volume);
    void timerIntervalChanged(double seconds);
    void activeChanged(bool active);
    void completeChanged(bool complete);

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Brewing
