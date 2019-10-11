#pragma once

#include <QObject>
#include <QScopedPointer>

namespace Brewing
{

class Controller : public QObject
{
    Q_OBJECT

public:
    Controller();
    virtual ~Controller();

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Brewing
