import QtQuick 2.0
Rectangle{
    id:root
    color: "#66008800"
    border.width: 1
    border.color: "#FFFFFF"
    radius: 10
    property vector3d position:Qt.vector3d(0.0,0.0,0.0)
    onPositionChanged:{
        var x_val = width*0.0001 *position.x
        var y_val = height*0.0001 *position.z
        pointer.x = width*0.5+x_val-pointer.width*0.5
        pointer.y = height*0.5+y_val-pointer.height*0.5
    }
    Rectangle {
        id:pointer
        width: 8
        height: 8
        radius: width*0.5
        color: "#FF0000"
    }
    Text {
        id: position_text
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        text: "X: "+position.x.toFixed(0) +"\nY: "+position.y.toFixed(0) + "\nZ: "+position.z.toFixed(0)
        font.pixelSize: 14
        color: "#FFFFFF"
    }
}

