#include <QApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QLocale>
#include <QTranslator>
#include <QQmlContext>
#include "systemtraymanager.h"

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
#include <QDesktopWidget>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("frares@gmail.com");
    QCoreApplication::setApplicationName("Transparent Clock");
    QCoreApplication::setApplicationVersion("0.4.0");
    
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);
    QIcon icon(":/icon/clock");

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "TransparentClock_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    SystemTrayManager trayManager;
    QQmlApplicationEngine engine;
    
    engine.rootContext()->setContextProperty("systemTrayManager", &trayManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);
    app.setWindowIcon(icon);

    return app.exec();
}

