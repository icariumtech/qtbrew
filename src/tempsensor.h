#pragma once

#include <QObject>

namespace Brewing
{

class TempSensor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double temp READ Temp NOTIFY TempChanged)

public:
    TempSensor(uint8_t device, uint8_t cs);
    virtual ~TempSensor();

    double Temp() const;

public slots:
    void Init();

signals:
    void TempChanged(double temp);

private slots:
    void ComputeTemp();

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Brewing
