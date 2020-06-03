#pragma once

#include <QObject>
#include <QtCharts/QAbstractSeries>

#include <memory>

namespace Ui
{

class SetpointGraph : public QObject
{
    Q_OBJECT

public:
    SetpointGraph();
    virtual ~SetpointGraph();

public slots:
    void setSetpoint(double setpoint);
    void registerSetpointSeries(QtCharts::QAbstractSeries *series_p);
    void registerTempSeries(QtCharts::QAbstractSeries *series_p);

private:
    class Data;
    std::unique_ptr<Data> d;
};

} // namespace Ui
