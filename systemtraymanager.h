#ifndef SYSTEMTRAYMANAGER_H
#define SYSTEMTRAYMANAGER_H

#include <QObject>
#include <QSystemTrayIcon>
#include <QMenu>
#include <QVariant>

class SystemTrayManager : public QObject {
    Q_OBJECT
public:
    explicit SystemTrayManager(QObject *parent = nullptr);
    Q_INVOKABLE void setMainWindow(QObject* window);

private:
    void setupSystemTray();
    QSystemTrayIcon* trayIcon = nullptr;
    QObject* m_mainWindow = nullptr;
};

#endif // SYSTEMTRAYMANAGER_H