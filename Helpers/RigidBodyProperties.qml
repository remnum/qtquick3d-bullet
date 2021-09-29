import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id:root
    property var pickedObj:0
    property var rigidObj:pickedObj.rigidObject
    property var boundaryModel:pickedObj.boundaryModel
    property var objectModel:pickedObj.objectModel
    property int pixelsize:12

    function update() {
        boundaryModel.position.x = parseFloat(boundary_model_pos_x.value)
        boundaryModel.position.y = parseFloat(boundary_model_pos_y.value)
        boundaryModel.position.z = parseFloat(boundary_model_pos_z.value)

        boundaryModel.scale.x = parseFloat(boundary_model_scale_x.value/10.0)
        boundaryModel.scale.y = parseFloat(boundary_model_scale_y.value/10.0)
        boundaryModel.scale.z = parseFloat(boundary_model_scale_z.value/10.0)

        objectModel.position.x = parseFloat(object_model_pos_x.value)
        objectModel.position.y = parseFloat(object_model_pos_y.value)
        objectModel.position.z = parseFloat(object_model_pos_z.value)


        objectModel.scale.x = parseFloat(object_model_scale_x.value/10.0)
        objectModel.scale.y = parseFloat(object_model_scale_y.value/10.0)
        objectModel.scale.z = parseFloat(object_model_scale_z.value/10.0)
    }


   function updateBoundaryColor(bcolor) {
       boundaryModel.mcolor = bcolor
   }

    onPickedObjChanged: {
        if(pickedObj != null) {
            boundaryModel = pickedObj.boundaryModel
            objectModel = pickedObj.objectModel

            boundary_model_pos_x.value = boundaryModel.position.x
            boundary_model_pos_x.value = boundaryModel.position.y
            boundary_model_pos_x.value = boundaryModel.position.z

            boundary_model_scale_x.value = boundaryModel.scale.x* 10.0
            boundary_model_scale_y.value = boundaryModel.scale.y* 10.0
            boundary_model_scale_z.value = boundaryModel.scale.z* 10.0

            object_model_pos_x.value  = objectModel.position.x
            object_model_pos_y.value  = objectModel.position.y
            object_model_pos_z.value  = objectModel.position.z


            object_model_scale_x.value  = objectModel.scale.x* 10.0
            object_model_scale_y.value  = objectModel.scale.y* 10.0
            object_model_scale_z.value  = objectModel.scale.z* 10.0

            rigidObj = pickedObj.rigidObject
            combo_type.currentIndex = rigidObj.type
            combo_shape.currentIndex = rigidObj.shape
            combo_action.currentIndex = rigidObj.actionType
            combo_ctype.currentIndex = rigidObj.collisionActionType
            mass.text = rigidObj.mass
            force.text = rigidObj.force
            power.text = rigidObj.maxPower
            switch_simulation.checked = rigidObj.simulation
            boudaryColorOpacity.value = boundaryModel.colorOpacity
            if(!rigidObj.simulation)
                boundary_model_pos_row.enabled = true
            else
                boundary_model_pos_row.enabled = false


        }
    }

    TabBar {
        id: bar

        anchors.fill: parent

        TabButton {
            text: qsTr("Physics")
        }
        TabButton {
            text: qsTr("Scale")
        }

    }

    StackLayout {
        anchors.fill: parent
        anchors.topMargin: 25
        currentIndex: bar.currentIndex
        Rectangle{
            id: homeTab
            color: "#222222"
            radius: 8
            border.width: 1
            border.color: "#FFFFFF"

            Column{
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                Text{
                    width: parent.width
                    height: 20
                    text: "Type"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                }

                ComboBox {
                    id:combo_type
                    width: parent.width
                    height: 20
                    editable: false
                    font.pixelSize: pixelsize
                    model: ListModel {
                        id: model_type
                        ListElement { text: "STATIC" }
                        ListElement { text: "DYNAMIC" }
                        ListElement { text: "KINEMATIC" }
                        ListElement { text: "KINEMATIC_COLLISON" }
                    }
                }

                Text{
                    width: parent.width
                    height: 20
                    text: "Shape"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                }

                ComboBox {
                    id:combo_shape
                    width: parent.width
                    height: 20
                    editable: false
                    font.pixelSize: pixelsize

                    model: ListModel {
                        id: model_shape
                        ListElement { text: "BOX" }
                        ListElement { text: "SPHERE" }
                        ListElement { text: "CONE" }
                        //                    ListElement { text: "MESH" }
                    }
                }

                Text{
                    width: parent.width
                    height: 20
                    text: "Action"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                }

                ComboBox {
                    id:combo_action
                    width: parent.width
                    height: 20
                    editable: false
                    font.pixelSize: pixelsize

                    model: ListModel {
                        id: model_action
                        ListElement { text: "NONE" }
                        ListElement { text: "DELETE" }
                        ListElement { text: "ACTION" }
                        ListElement { text: "ACTION DELETE" }
                        ListElement { text: "ACTION EXPLOSION" }
                        ListElement { text: "POWER LOSS STATIC" }
                        ListElement { text: "POWER LOSS DELETE" }
                        ListElement { text: "POWER LOSS ACTION STATIC" }
                        ListElement { text: "POWER LOSS ACTION DELETE" }
                        ListElement { text: "TURN STATIC" }
                    }

                }

                Text{
                    width: parent.width
                    height: 20
                    text: "Collision Type"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                }

                ComboBox {
                    id:combo_ctype
                    width: parent.width
                    height: 20
                    editable: false
                    font.pixelSize: pixelsize

                    model: ListModel {
                        id: model_ctype
                        ListElement { text: "ACTIVE" }
                        ListElement { text: "PASSIVE" }
                    }
                }
                Row{
                    width: parent.width
                    height: 30
                    spacing: width*0.05

                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Mass"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            TextInput{
                                id:mass
                                anchors.fill: parent
                                text: "0.0"
                                color: "#0000FF"
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: pixelsize
                                onFocusChanged:
                                    if(focus)
                                        selectAll();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Force"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            TextInput{
                                id:force
                                anchors.fill: parent
                                text: "0.0"
                                color: "#0000FF"
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: pixelsize
                                onFocusChanged:
                                    if(focus)
                                        selectAll();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Power"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            TextInput{
                                id:power
                                anchors.fill: parent
                                text: "0.0"
                                color: "#0000FF"
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: pixelsize
                                onFocusChanged:
                                    if(focus)
                                        selectAll();
                            }
                        }
                    }
                }
                Row{
                    width: parent.width
                    height: 20
                    spacing: 5
                    Text{
                        width: parent.width * 0.5
                        height: parent.height
                        text: "Simulation"
                        color: "#FFFFFF"
                        font.pixelSize: pixelsize
                        verticalAlignment: Text.AlignVCenter
                    }
                    Switch{
                        id:switch_simulation
                        width: parent.width * 0.5
                        height: parent.height
                        checked: false
                    }
                }

                Row{
                    width: parent.width
                    height: 20
                    spacing: 5
                    Button{
                        width: parent.width*0.5-3
                        height: 20
                        text: "Cancel"
                        onClicked: {
                            pickedObj.isPicked = false
                            root.visible  = false
                            pickedObj = null;
                        }
                    }

                    Button{
                        width: parent.width*0.5-3
                        height: 20
                        text: "Update"
                        onClicked: {
                            rigidObj.type = combo_type.currentIndex
                            rigidObj.shape = combo_shape.currentIndex
                            rigidObj.actionType =  combo_action.currentIndex
                            rigidObj.collisionActionType = combo_ctype.currentIndex
                            rigidObj.mass = parseFloat(mass.text)
                            rigidObj.force= parseFloat(force.text)
                            rigidObj.maxPower =  parseInt(power.text)
                            rigidObj.simulation = switch_simulation.checked
                            pickedObj.isPicked = false
                            root.visible  = false
                            pickedObj = null;
                        }
                    }
                }
            }
        }

        Rectangle{
            id: discoverTab
            color: "#222222"
            radius: 8
            border.width: 1
            border.color: "#FFFFFF"

            Column{
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5
                Text{
                    width: parent.width
                    height: 15
                    text: "object model position"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                    verticalAlignment: Text.AlignBottom
                }

                Row{
                    width: parent.width
                    height: 30
                    spacing: width*0.05

                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "X"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:object_model_pos_x
                                anchors.fill: parent
                                from: -10000.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Y"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:object_model_pos_y
                                anchors.fill: parent
                                from: -10000.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Z"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:object_model_pos_z
                                anchors.fill: parent
                                from: -10000.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                }




                Text{
                    width: parent.width
                    height: 15
                    text: "object model scale"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                    verticalAlignment: Text.AlignBottom
                }
                Row{
                    width: parent.width
                    height: 30
                    spacing: width*0.05

                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "X"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:object_model_scale_x
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Y"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:object_model_scale_y
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Z"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:object_model_scale_z
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                }


                Text{
                    width: parent.width
                    height: 15
                    text: "boundary model position"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                    verticalAlignment: Text.AlignBottom
                }
                Row{
                    id:boundary_model_pos_row
                    width: parent.width
                    height: 30
                    spacing: width*0.05

                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "X"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:boundary_model_pos_x
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Y"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:boundary_model_pos_y
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Z"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:boundary_model_pos_z
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                }


                Text{
                    width: parent.width
                    height: 15
                    text: "boundary model scale"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                    verticalAlignment: Text.AlignBottom
                }
                Row{
                    width: parent.width
                    height: 30
                    spacing: width*0.05

                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "X"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:boundary_model_scale_x
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Y"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:boundary_model_scale_y
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                    Column{
                        width: parent.width*0.3
                        height: parent.height
                        spacing: 5
                        Text{
                            width: parent.width
                            height: 10
                            text: "Z"
                            color: "#FFFFFF"
                            font.pixelSize: pixelsize
                        }
                        Rectangle{
                            width: parent.width
                            height: parent.height * 0.5
                            color: "#888888"
                            SpinBox{
                                id:boundary_model_scale_z
                                anchors.fill: parent
                                from: 0.0
                                to:10000.0
                                stepSize: 1.0
                                font.pixelSize: pixelsize
                                editable: true
                                onValueModified:
                                    root.update();
                            }
                        }
                    }
                }


                Text{
                    width: parent.width
                    height: 15
                    text: "Boundary Model Color"
                    color: "#FFFFFF"
                    font.pixelSize: pixelsize
                    verticalAlignment: Text.AlignBottom
                }

                Row{
                    width: parent.width
                    height: 20
                    spacing: width*0.05

                    Button{
                        width: parent.width *0.3
                        height: parent.height
                        background: Rectangle {
                               anchors.fill: parent
                               color: "#FFFF00"
                               border.width: 1
                               radius: 8
                           }
                        onClicked:
                            updateBoundaryColor("#FFFF00")
                    }

                    Button{
                        width: parent.width *0.3
                        height: parent.height
                        background: Rectangle {
                               anchors.fill: parent
                               color: "#00FF00"
                               border.width: 1
                               radius: 8
                           }
                        onClicked:
                            updateBoundaryColor("#00FF00")
                    }

                    Button{
                        width: parent.width*0.3
                        height: parent.height
                        background: Rectangle {
                               anchors.fill: parent
                               color: "#0000FF"
                               border.width: 1
                               radius: 8
                           }
                        onClicked:
                            updateBoundaryColor("#0000FF")
                    }
                }
                Row{
                    width: parent.width
                    height: 20
                    spacing: width*0.05
                    Text{
                        width: parent.width *0.25
                        height: 15
                        text: "opacity"
                        color: "#FFFFFF"
                        font.pixelSize: pixelsize
                        verticalAlignment: Text.AlignBottom
                    }

                    Slider{
                        id:boudaryColorOpacity
                        width: parent.width * 0.7
                        height: 15
                        from: 1.0
                        to:0.0
                        stepSize: -0.1
                        onValueChanged:
                            boundaryModel.colorOpacity = value

                    }
                }
            }
        }
    }
}
