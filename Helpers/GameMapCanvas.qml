import QtQuick 2.0
Rectangle{
    id:root
    color: "#66008800"
    border.width: 1
    border.color: "#FFFFFF"
    radius: 10
    property vector3d position:Qt.vector3d(0.0,0.0,0.0)
    onPositionChanged:{
        mapPointer.requestPaint();
    }


    Canvas {
        id: mapPointer
        antialiasing:true
        anchors.fill: parent
        onPaint: {
            var ctx = getContext('2d')
            var x_val = width*0.0001 *position.x
            var y_val = height*0.0001 *position.z
            var center_x = width*.5
            var center_y = height*.5
            ctx.reset();
            ctx.lineCap = "square"
            ctx.lineWidth = 1
            ctx.strokeStyle = "#FFFFFF"

            ctx.beginPath()
            ctx.lineWidth = 1
            ctx.moveTo(0,center_y+y_val)
            ctx.lineTo(width,center_y+y_val)
            ctx.stroke()


            ctx.beginPath()
            ctx.lineWidth = 1
            ctx.moveTo(center_x+x_val,0)
            ctx.lineTo(center_x+x_val,height)
            ctx.stroke()
        }
    }
}

