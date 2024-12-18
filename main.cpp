#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QApplication>
#include "hc_trans.h"
#include "server/service.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Service::instance();
    Service::instance()->registerQmlTypes();

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("DataConversionTools", "Main");
    return app.exec();
}
