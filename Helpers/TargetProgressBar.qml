import QtQuick
import QtQuick.Controls

ProgressBar {
    id: control
    value: 0.0
    padding: 2

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: "#00000000"
        radius: 3
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: 2
            color: "#FF0000"
        }
    }
}
