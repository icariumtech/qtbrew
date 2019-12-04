#include "pid.h"

#include <QDebug>
#include <QElapsedTimer>
#include <QSettings>
#include <QTimer>

#include "relay.h"
#include "tempsensor.h"

namespace Brewing
{

class Pid::Data
{
public:
    QString m_name;
    bool m_enabled;
    QTimer *m_timer_p;

    Relay *m_relay_p;
    TempSensor *m_sensor_p;

    double m_disp_kp;
    double m_disp_ki;
    double m_disp_kd;

    double m_kp;
    double m_ki;
    double m_kd;

    double m_setpoint;

    double m_last_input;

    double m_output;
    double m_output_sum;

    double m_out_min = 0;
    double m_out_max = 50;

    int m_counter = 0;

    void SetTunings();
};

Pid::Pid(QString name, TempSensor *sensor_p, Relay *relay_p) : d(new Data)
{
    d->m_name = name;
    d->m_enabled = false;

    d->m_sensor_p = sensor_p;
    d->m_relay_p = relay_p;

    d->m_timer_p = new QTimer(this);
    d->m_timer_p->setInterval(100);
    connect(d->m_timer_p, &QTimer::timeout, this, &Pid::Compute);

    d->SetTunings();
}

Pid::~Pid()
{

}

void Pid::SetEnabled(bool enable)
{
    if (enable != d->m_enabled)
    {
        d->m_enabled = enable;
        if (enable)
        {
            QTimer::singleShot(0, d->m_timer_p, SLOT(start));
        }
        else
        {
            QTimer::singleShot(0, d->m_timer_p, SLOT(stop));
        }
    }
}

void Pid::Compute()
{
    double input = d->m_sensor_p->GetTemp();

    if (qIsNaN(input))
    {
        d->m_relay_p->setEnable(false);
        return;
    }

    double error = d->m_setpoint - input;
    double dInput = (input - d->m_last_input);
    d->m_output_sum += (d->m_ki * error);

    if(d->m_output_sum > d->m_out_max)
    {
        d->m_output_sum = d->m_out_max;
    }
    else if(d->m_output_sum < d->m_out_min)
    {
        d->m_output_sum = d->m_out_min;
    }

    double output;
    output = d->m_kp * error;

    output += d->m_output_sum - d->m_kd * dInput;

    if(output > d->m_out_max)
    {
        output = d->m_out_max;
    }
    else if(output < d->m_out_min)
    {
        output = d->m_out_min;
    }
    d->m_output = output;

    d->m_last_input = input;

    d->m_counter++;
    if (d->m_counter >= d->m_out_max)
    {
        d->m_counter = 0;
    }

    d->m_relay_p->setEnable(d->m_counter <= d->m_output);
}

void Pid::SetSetpoint(double degrees_c)
{
    d->m_setpoint = degrees_c;
}

double Pid::Kp()
{
    return  d->m_disp_kp;
}

double Pid::Ki()
{
    return  d->m_disp_ki;
}

double Pid::Kd()
{
    return  d->m_disp_kd;
}

void Pid::Data::SetTunings()
{
    QSettings settings;
    double kp = settings.value(m_name + "/kp", 2).toDouble();
    double ki = settings.value(m_name + "/ki", 5).toDouble();
    double kd = settings.value(m_name + "/kd", 1).toDouble();

    m_disp_kp = kp;
    m_disp_ki = ki;
    m_disp_kd = kd;

    double sample_in_sec = static_cast<double>(m_timer_p->interval()) / 1000;
    m_kp = kp;
    m_ki = ki * sample_in_sec;
    m_kd = kd / sample_in_sec;
}

} // namespace Brewing
