#include "setpointgraph.h"

#include <QtCharts/QXYSeries>

namespace Ui
{

class SetpointGraph::Data
{
public:
    QVector<QPointF> m_setpoint_points;
    QtCharts::QXYSeries *m_setpoint_series_p = nullptr;
    QtCharts::QXYSeries *m_temp_series_p = nullptr;
};

SetpointGraph::SetpointGraph() : QObject(), d(new Data)
{
    d->m_setpoint_points.append(QPointF(0,0));
    d->m_setpoint_points.append(QPointF(180, 0));
}

SetpointGraph::~SetpointGraph()
{

}

void SetpointGraph::setSetpoint(double setpoint)
{
    if (d->m_setpoint_series_p)
    {
        d->m_setpoint_points[0].setY(setpoint * 1.8 + 32);
        d->m_setpoint_points[1].setY(setpoint * 1.8 + 32);
        d->m_setpoint_series_p->replace(d->m_setpoint_points);
    }
}

void SetpointGraph::registerSetpointSeries(QtCharts::QAbstractSeries *series_p)
{
    d->m_setpoint_series_p = qobject_cast<QtCharts::QXYSeries*>(series_p);
    d->m_setpoint_series_p->replace(d->m_setpoint_points);
}

void SetpointGraph::registerTempSeries(QtCharts::QAbstractSeries *series_p)
{
    d->m_temp_series_p = qobject_cast<QtCharts::QXYSeries*>(series_p);
}

} // namespace Ui
