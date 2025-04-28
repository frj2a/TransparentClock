#include "systemtraymanager.h"
#include <QMetaObject>
#include <QApplication>

SystemTrayManager::SystemTrayManager(QObject *parent)
    : QObject(parent)
{
}

void SystemTrayManager::setMainWindow(QObject* window)
{
    m_mainWindow = window;
    setupSystemTray();
}

void SystemTrayManager::setupSystemTray()
{
    if (!QSystemTrayIcon::isSystemTrayAvailable())
        return;

    trayIcon = new QSystemTrayIcon(this);
    trayIcon->setIcon(QIcon(":/icon/clock"));

    QMenu* trayMenu = new QMenu();
    
    QAction* moveAction = trayMenu->addAction("Enable Movement");
    moveAction->setCheckable(true);
    connect(moveAction, &QAction::toggled, this, [this](bool checked) {
        QMetaObject::invokeMethod(m_mainWindow, "setMovable",
            Q_ARG(QVariant, checked));
    });

    trayMenu->addAction("Reset Position", this, [this]() {
        QMetaObject::invokeMethod(m_mainWindow, "resetPosition");
    });

    trayMenu->addSeparator();
    trayMenu->addAction("Quit", qApp, &QCoreApplication::quit);

    trayIcon->setContextMenu(trayMenu);
    trayIcon->show();
}
