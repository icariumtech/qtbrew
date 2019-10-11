#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include "brewingcontroller.h"
#include "uicontroller.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QGuiApplication::setFont(QFont("Roboto"));

    Brewing::Controller controller;
    Ui::Controller ui(&controller);
    (void)ui;

    return app.exec();
}
