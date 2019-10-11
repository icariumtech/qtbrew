#pragma once

#include <QObject>
#include <QScopedPointer>

namespace Brewing { class Controller; }

namespace Ui
{

class Controller : public QObject
{
    Q_OBJECT

public:
    Controller(Brewing::Controller *controller_p);
    virtual ~Controller();

private:
    class Data;
    QScopedPointer<Data> d;
};

} // namespace Ui
