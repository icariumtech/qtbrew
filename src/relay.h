#pragma once

#include <memory>

#include <QObject>

namespace Brewing
{

class Relay : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled
               NOTIFY enabledChanged)
public:
    Relay(int gpio, const QString name);
    virtual ~Relay();

    void setEnabled(bool enable);
    bool enabled() const;

signals:
    void enabledChanged(bool enabled);

private:
    class Data;
    std::unique_ptr<Data> d;
};

} // namespace Brewing
