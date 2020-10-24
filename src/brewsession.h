#pragma once

#include <QObject>
#include <QScopedPointer>

#include <brewstep.h>

namespace Brewing
{

typedef QList<Step*> BrewSteps;

class BrewSession : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString recipeName READ recipeName NOTIFY recipeNameChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(bool finished READ finished NOTIFY finishedChanged)
    Q_PROPERTY(double setpoint READ setpoint NOTIFY setpointChanged )
    Q_PROPERTY(int elapsedTimeSec READ elapsedTimeSec
               NOTIFY elapsedTimeSecChanged)
    Q_PROPERTY(int volume READ volume NOTIFY volumeChanged)

public:
    BrewSession();
    virtual ~BrewSession();

    QString recipeName() const;

    QList<QObject*> steps();

    bool running() const;
    bool finished() const;
    double setpoint() const;
    int elapsedTimeSec() const;
    int volume() const;

public slots:
    void begin();
    void nextStep();

signals:
    void recipeNameChanged(QString name);
    void stepsChanged();
    void runningChanged(bool running);
    void finishedChanged(bool finished);
    void setpointChanged(double setpoint);
    void elapsedTimeSecChanged(int seconds);
    void volumeChanged(int volume);

protected:
    void timerEvent(QTimerEvent *event) override;

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Brewing
