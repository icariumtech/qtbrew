#pragma once

#include <QObject>

namespace Brewing
{

class TempSensor : public QObject
{
    Q_OBJECT

public:
    TempSensor(uint8_t device, uint8_t cs);
    virtual ~TempSensor();

    double GetTemp() const;

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
