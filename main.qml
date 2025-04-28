import QtQuick
import QtQuick.Window

Window {
    id: clock
    width: 128
    height: width
    x: 1600
    y: 800
    opacity: 1
    visible: true
    color: "#00000000"
    maximumHeight: width
    minimumHeight: width
    maximumWidth: width
    minimumWidth: width
    visibility: Window.Windowed

    // Store default position
    property int defaultX: 0
    property int defaultY: 0
    property bool isMovable: false

    flags: {
        var baseFlags = Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        return isMovable ? baseFlags : baseFlags | Qt.WindowTransparentForInput
    }

    title: qsTr("")

    property int hours
    property int minutes
    property int seconds
    property real shift
    property bool night: false
    property bool internationalTime: false // true for international time, false for local

    function timeChanged() {
        var date = new Date
        hours = internationalTime ? date.getUTCHours() + Math.floor(
                                        clock.shift) : date.getHours()
        night = (hours < 7 || hours > 19)
        minutes = internationalTime ? date.getUTCMinutes(
                                          ) + ((clock.shift % 1) * 60) : date.getMinutes()
        seconds = date.getUTCSeconds()

        // seconds++
        // minutes = seconds/10
        // hours = minutes/4
        second.rotationSecondAngle = clock.seconds * 6
        minute.rotationMinuteAngle = clock.minutes * 6
        hour.rotationHourAngle = (clock.hours * 30) + (clock.minutes * 0.5)
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: clock.timeChanged()
    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        drag.target: isMovable ? parent : undefined
        drag.filterChildren: true
        onClicked: {
            if (!isMovable) {
                mouse.accepted = false
            }
        }
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        antialiasing: true
        color: "#0fff7f00"
        radius: 64
        border.width: 0
    }

    ListModel {
        id: inclinationModel
        ListElement {
            angle: 0
            size: "big"
        }
        ListElement {
            angle: 30
            size: "small"
        }
        ListElement {
            angle: 60
            size: "small"
        }
        ListElement {
            angle: 90
            size: "big"
        }
        ListElement {
            angle: 120
            size: "small"
        }
        ListElement {
            angle: 150
            size: "small"
        }
        ListElement {
            angle: 180
            size: "big"
        }
        ListElement {
            angle: 210
            size: "small"
        }
        ListElement {
            angle: 240
            size: "small"
        }
        ListElement {
            angle: 270
            size: "big"
        }
        ListElement {
            angle: 300
            size: "small"
        }
        ListElement {
            angle: 330
            size: "small"
        }
    }

    Repeater {
        model: inclinationModel
        Rectangle {
            id: tick
            width: 4
            height: (model.size == "big") ? 10 : 6
            x: 64 - width / 2
            y: 2
            color: "#3f000000"
            border.width: 0.5
            border.color: "#3fffff00"
            antialiasing: true
            transform: Rotation {
                origin.x: tick.width / 2
                origin.y: 64 - tick.y
                angle: model.angle
            }
        }
    }

    Rectangle {
        id: hour
        width: 4
        height: 64 - 30
        x: 64 - width / 2
        y: 64 - height
        color: "#3f00007f"
        border.width: 0.5
        border.color: "#3fffff00"
        antialiasing: true

        property alias rotationHourAngle: rotation_hour.angle

        transform: Rotation {
            id: rotation_hour
            origin.x: hour.width / 2
            origin.y: 64 - hour.y
            angle: 0
            Behavior on angle {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }
    }

    Rectangle {
        id: minute
        width: 4
        height: 64 - 4
        x: 64 - width / 2
        y: 64 - height
        color: "#3f00007f"
        border.width: 0.5
        border.color: "#3fffff00"
        antialiasing: true

        property alias rotationMinuteAngle: rotation_minute.angle

        transform: Rotation {
            id: rotation_minute
            origin.x: minute.width / 2
            origin.y: 64 - minute.y
            angle: 0
            Behavior on angle {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }
    }

    Rectangle {
        id: second
        width: 2
        height: 64 - 4
        x: 64 - width / 2
        y: 64 - height
        color: "#3f00007f"
        border.width: 0
        antialiasing: true

        property alias rotationSecondAngle: rotation_second.angle

        transform: Rotation {
            id: rotation_second
            origin.x: second.width / 2
            origin.y: 64 - second.y
            angle: 0
            Behavior on angle {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }
    }

    Component.onCompleted: {
        // Screen handling is different between Qt 5 and Qt 6
        var screenWidth, screenHeight
        if (Screen.width === undefined) {
            // Qt 5: use Screen.desktopAvailableWidth
            screenWidth = Screen.desktopAvailableWidth
            screenHeight = Screen.desktopAvailableHeight
        } else {
            // Qt 6: use Screen.width
            screenWidth = Screen.width
            screenHeight = Screen.height
        }

        clock.x = screenWidth - 150
        clock.y = screenHeight - 200
        defaultX = clock.x
        defaultY = clock.y
        timeChanged()
        systemTrayManager.setMainWindow(clock)
    }

    // Functions called from C++
    function setMovable(movable) {
        isMovable = movable
    }

    function resetPosition() {
        clock.x = defaultX
        clock.y = defaultY
    }
}
