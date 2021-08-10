import QtQuick
import QtQuick3D

Item {
    id: root
    property Node controlledObject: undefined
    property Node mouseControlledObject: undefined

    property real speed: 1
    property real shiftSpeed: 3

    property real forwardSpeed: 5
    property real backSpeed: 5
    property real rightSpeed: 5
    property real leftSpeed: 5
    property real upSpeed: 5
    property real downSpeed: 5
    property real xSpeed: 0.1
    property real ySpeed: 0.1

    property real zoom: 10.0
    property real zoomSign: 1.0

    property bool xInvert: false
    property bool yInvert: true

    property bool mouseEnabled: true
    property bool keysEnabled: true

    readonly property bool inputsNeedProcessing: status.moveForward | status.moveBack
                                                 | status.moveLeft | status.moveRight
                                                 | status.moveUp | status.moveDown
                                                 | status.useMouse


    property alias acceptedButtons: dragHandler.acceptedButtons

    implicitWidth: parent.width
    implicitHeight: parent.height
    focus: keysEnabled

    onEnabledChanged: {
        if(enabled === false){
            focus = false
            updateTimer.running = false
        }
        else{
            focus = true
            updateTimer.running = true
        }
    }


    DragHandler {
        id: dragHandler
        target: null
        enabled: mouseEnabled
        onCentroidChanged: {
            mouseMoved(Qt.vector2d(centroid.position.x, centroid.position.y));
        }

        onActiveChanged: {
            if (active)
                mousePressed(Qt.vector2d(centroid.position.x, centroid.position.y));
            else
                mouseReleased(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
    }

    WheelHandler {
        target: null
        enabled: mouseEnabled
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
                     if(event.angleDelta.y > 0) {
                         zoomSign = 1.0
                     }
                     else {
                         zoomSign = -1.0
                     }
                 }
        onActiveChanged: {
            if (active)
                status.useWheel = true;
            else
                status.useWheel = false
        }
    }

    function mousePressed(newPos) {
        status.currentPos = newPos
        status.lastPos = newPos
        status.useMouse = true;
    }

    function mouseReleased(newPos) {
        status.useMouse = false;
    }

    function mouseMoved(newPos) {
        status.currentPos = newPos;
    }



    Keys.onPressed: (event)=> { if (keysEnabled) handleKeyPress(event) }
    Keys.onReleased: (event)=> { if (keysEnabled) handleKeyRelease(event) }

    signal  emitFire();
    signal  emitThrowBomb();
    signal  emitMissle();



    function forwardPressed() {
        status.moveForward = true
        status.moveBack = false
    }

    function forwardReleased() {
        status.moveForward = false
    }

    function backPressed() {
        status.moveBack = true
        status.moveForward = false
    }

    function backReleased() {
        status.moveBack = false
    }

    function rightPressed() {
        status.moveRight = true
        status.moveLeft = false
    }

    function rightReleased() {
        status.moveRight = false
    }

    function leftPressed() {
        status.moveLeft = true
        status.moveRight = false
    }

    function leftReleased() {
        status.moveLeft = false
    }

    function upPressed() {
        status.moveUp = true
        status.moveDown = false
    }

    function upReleased() {
        status.moveUp = false
    }

    function downPressed() {
        status.moveDown = true
        status.moveUp = false
    }

    function downReleased() {
        status.moveDown = false
    }

    function shiftPressed() {
        status.shiftDown = true
    }

    function shiftReleased() {
        status.shiftDown = false
    }

    function handleKeyPress(event)
    {
        switch (event.key) {
        case Qt.Key_W:
        case Qt.Key_Up:
            forwardPressed();
            break;
        case Qt.Key_S:
        case Qt.Key_Down:
            backPressed();
            break;
        case Qt.Key_A:
        case Qt.Key_Left:
            leftPressed();
            break;
        case Qt.Key_D:
        case Qt.Key_Right:
            rightPressed();
            break;
        case Qt.Key_R:
        case Qt.Key_PageUp:
            upPressed();
            break;
        case Qt.Key_F:
        case Qt.Key_PageDown:
            downPressed();
            break;
        case Qt.Key_Shift:
            shiftPressed();
            break;

        case Qt.Key_Control:
            emitThrowBomb();
            break;

        case Qt.Key_Space:
            emitFire();
            break;

        case Qt.Key_Alt:
            emitMissle();
            break;
        }
    }

    function handleKeyRelease(event)
    {
        switch (event.key) {
        case Qt.Key_W:
        case Qt.Key_Up:
            forwardReleased();
            break;
        case Qt.Key_S:
        case Qt.Key_Down:
            backReleased();
            break;
        case Qt.Key_A:
        case Qt.Key_Left:
            leftReleased();
            break;
        case Qt.Key_D:
        case Qt.Key_Right:
            rightReleased();
            break;
        case Qt.Key_R:
        case Qt.Key_PageUp:
            upReleased();
            break;
        case Qt.Key_F:
        case Qt.Key_PageDown:
            downReleased();
            break;
        case Qt.Key_Shift:
            shiftReleased();
            break;


        }
    }

    Timer {
        id: updateTimer
        interval: 16
        repeat: true
        running: true// root.inputsNeedProcessing
        onTriggered: {
            processInputs();
        }
    }

    function processInputs()
    {
        //   if (root.inputsNeedProcessing)
        status.processInput();
    }

    QtObject {
        id: status

        property bool moveForward: false
        property bool moveBack: false
        property bool moveLeft: false
        property bool moveRight: false
        property bool moveUp: false
        property bool moveDown: false
        property bool shiftDown: false
        property bool useMouse: false
        property bool useWheel: false



        property vector2d lastPos: Qt.vector2d(0, 0)
        property vector2d currentPos: Qt.vector2d(0, 0)

        function updatePosition(vector, speed, position)
        {
            if (shiftDown)
                speed *= shiftSpeed;
            else
                speed *= root.speed

            var direction = vector;
            var velocity = Qt.vector3d(direction.x * speed,
                                       direction.y * speed,
                                       direction.z * speed);
            controlledObject.position = Qt.vector3d(position.x + velocity.x,
                                                    position.y + velocity.y,
                                                    position.z + velocity.z);
        }

        function negate(vector) {
            return Qt.vector3d(-vector.x, -vector.y, -vector.z)
        }

        function processInput() {
            if (controlledObject == undefined)
                return;

            if (moveForward)
                forwardSpeed += 0.2
            else if (moveBack)
                forwardSpeed -= 0.2
            if(forwardSpeed > 4.0)
                forwardSpeed = 4.0
            else if(forwardSpeed <0.2)
                forwardSpeed = 0.2
            updatePosition(controlledObject.forward, forwardSpeed, controlledObject.position);

            if (moveRight){
                controlledObject.rotate(-1.0 * rightSpeed,Qt.vector3d(0.0,1.0,0.0),Node.ParentSpace);
                if(controlledObject.eulerRotation.z  >= 30)
                    controlledObject.eulerRotation.z  = 30
                else
                    controlledObject.eulerRotation.z += 1.0

            }
            else if (moveLeft){
                controlledObject.rotate(leftSpeed,Qt.vector3d(0.0,1.0,0.0),Node.ParentSpace);
                if(controlledObject.eulerRotation.z  <= -30)
                    controlledObject.eulerRotation.z  = -30
                else
                    controlledObject.eulerRotation.z -= 1.0
            }

            if (moveDown){
                if(controlledObject.eulerRotation.x  >= 90)
                    controlledObject.eulerRotation.x  = 90
                else
                    controlledObject.eulerRotation.x -= 1.0
            }
            else if (moveUp){
                if(controlledObject.eulerRotation.x  <= -90)
                    controlledObject.eulerRotation.x  = -90
                else
                    controlledObject.eulerRotation.x += 1.0
            }


            if(!moveDown && !moveUp){
                if(controlledObject.eulerRotation.x  < -1.0)
                    controlledObject.eulerRotation.x += 1.0
                else if(controlledObject.eulerRotation.x  >1.0)
                    controlledObject.eulerRotation.x -= 1.0

                else
                    controlledObject.eulerRotation.x  = 0.0
            }


            if(!moveLeft && !moveRight){
                if(controlledObject.eulerRotation.z  < -0.4)
                    controlledObject.eulerRotation.z += 0.4
                else if(controlledObject.eulerRotation.z  >0.4)
                    controlledObject.eulerRotation.z -= 0.4

                else
                    controlledObject.eulerRotation.z  = 0.0
            }

            if (useMouse) {
                // Get the delta
                var rotationVector = mouseControlledObject.eulerRotation;
                var delta = Qt.vector2d(lastPos.x - currentPos.x,
                                        lastPos.y - currentPos.y);
                // rotate x
                var rotateX = delta.x * xSpeed
                if (xInvert)
                    rotateX = -rotateX;
                rotationVector.y += rotateX;

                // rotate y
                var rotateY = delta.y * -ySpeed
                if (yInvert)
                    rotateY = -rotateY;
                rotationVector.x += rotateY;
                mouseControlledObject.setEulerRotation(rotationVector);
                lastPos = currentPos;

            }
            if(useWheel){
                mouseControlledObject.position=
                        Qt.vector3d(
                            mouseControlledObject.position.x +mouseControlledObject.forward.x*zoom*zoomSign
                            ,mouseControlledObject.position.y +mouseControlledObject.forward.y*zoom*zoomSign
                            ,mouseControlledObject.position.z +mouseControlledObject.forward.z*zoom*zoomSign)
            }
        }
    }
}
