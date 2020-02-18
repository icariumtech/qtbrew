#include <QFont>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include "brewingcontroller.h"
#include "uicontroller.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QApplication::setFont(QFont("Roboto Slab"));

    Brewing::Controller controller;
    Ui::Controller ui(&controller);
    (void)ui;

    return app.exec();
}
