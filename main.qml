import QtQuick
import QtQuick.Window
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.Effects
import QtQuick3D.AssetUtils
import QtQuick3D.Particles3D
import QtQuick.Controls

import LandShape 1.0

import QBulletPhysics 1.0
import QBulletRigidBody 1.0
import QBulletRay 1.0
import CharacterControlBody 1.0
import LandMeshPointer 1.0

import QBulletVehicle 1.0


import QtMultimedia
import "./Controllers"
import "./Helpers"
import "./Rigidbodies"
import "./Models"
import "./Characters"
import "./ParticlesLibrary"
import "./js/generateFunctions.js" as Genefunc

Window {
    id:main_root
    visible: true
    width: 640
    height: 480
    visibility: Window.FullScreen

    property int i:0
    property int j:0
    property int control_mode:0
    property var objs:[]
    property var testobjs:[]
    property int fd_count:0
    property double sound_volume : slider_volume.value
    property bool sound_mute: false
    property var currentController:0;

    property var listToDestroy:[]
    property var terrainTiles : []


    Component.onCompleted: {
        currentController = plane.controller
        plane.controller.enabled = true
        plane.controller.focus = true


    }






    //    QBulletRay{
    //        system: phy
    //        fromNode: plane_bound
    //        length: 1000
    //        type: QBulletRay.NodeWithLength
    //        mode: QBulletRay.Normal
    //        onPointHitted: (point)=> {
    //                           target_sign.position = point
    //                       }
    //    }


//    PlaneRigidBody{
//        id:plane
//        parent:view.scene
//        position: Qt.vector3d(0.0,250.0,160.0)
//    }
    CharacterRigidBody{
        id:plane
        parent:view.scene
        position: Qt.vector3d(0.0,250.0,160.0)
    }

    //    MachineGunRigidBody{
    //        id:mgun
    //        parent:view.scene
    //        position: Qt.vector3d(0.0,250.0,-160.0)
    //    }


    Timer {
        id:destroyTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            for(var i=0 ;i <listToDestroy.length;i++) {
                listToDestroy.pop().destroy()
            }
        }
    }

    Timer {
        id:phyTimer
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            phy.updateFrame()
        }
    }

    QBulletPhysics{
        id:phy
        onBodiesCountChanged:(count)=> {
                                 objects_count_text.text = "Objects : "+count
                             }
        Component.onCompleted: {
            phyTimer.running = true
            for(var i=0;i<1;i++){
                var row = parseInt(i/4)
                var col = i%4
                Genefunc.generateTerrian(row*600,col*600)
            }


           // Genefunc.generateHouse()
            Genefunc.generateBlocks()
            Genefunc.generateTower()
        }
    }

    //    VehicleRigidBody{
    //        id:mgun
    //        parent:view.scene
    //        position: Qt.vector3d(0.0,250.0,-160.0)
    //    }


    //    QBulletVehicle{
    //        id :v1
    //    }


    View3D {
        id:view
        anchors.fill: parent
        focus: true
        antialiasing: true
        camera:cam1

        PerspectiveCamera {
            id:cam1
            pivot: Qt.vector3d(0.0,0,-800.0)
            position: Qt.vector3d(0.0,300.0,0.0)
            eulerRotation: Qt.vector3d(-45.0,180.0,0.0)
//            frustumCullingEnabled:true
        }

        DirectionalLight {
            id:light
            position: Qt.vector3d(2000.0,2000.0,0.0)
            eulerRotation: Qt.vector3d(270,0.0,45.0)
            brightness: 2
            castsShadow: checkbox_shadow.checked? true : false
            shadowMapQuality: Light.ShadowMapQualityLow
            shadowFactor: 50
        }

        environment: SceneEnvironment {
            id: sceneEnvironment
            clearColor: "#444488"
            backgroundMode: SceneEnvironment.Color
            aoSampleRate: 30
        }

        Keys.onTabPressed: {
            control_mode++
            if(control_mode >=2)
                control_mode = 0;

            switch(control_mode){
            case 0:
                Genefunc.setContoller(plane)
                break;
            case 1:
                Genefunc.setContoller(mgun)
                break;
            }
        }

//        Keys.onDigit0Pressed:   {
//            explosionParticles.emitter.burst(50,500,Qt.vector3d(0.0,0.0,-300))
//            explosionParticles.emitter.burst(150,2000,Qt.vector3d(0.0,50.0,-300))
//            explosionParticles.emitter.burst(10,2000,Qt.vector3d(0.0,150.0,-300))
//        }

//        Keys.onDigit1Pressed:   {
//            var obj = terrainTiles.pop()
//            console.log(obj)
//            console.log(terrainTiles.length)
//            obj.visible = false
//        }

//        TargetSign{
//            id:target_sign
//        }

        ParticlesExplosion1{
            id:explosionParticles
        }

    }




    DebugView {
        source: view
        anchors.top: parent.top
        anchors.right: parent.right
    }

    Text {
        id: objects_count_text
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40
        font.pixelSize : 32
        text: "Objects : " + 0
        color: "yellow"
    }

    CheckBox{
        z:10
        id:checkbox_shadow
        text: "<font color=\"white\">Shadow</font>"
        checked: false
        onPressed:
            currentController.enabled = false

        onReleased:
            currentController.enabled = true
    }
    CheckBox{
        z:10
        id:checkbox_texture
        anchors.left: checkbox_shadow.right
        anchors.top: checkbox_shadow.top
        text: "<font color=\"white\">Texture</font>"
        checked: false
        onPressed:
            currentController.enabled = false

        onReleased:
            currentController.enabled = true
    }

    Image {
        id: terrain_texture
        anchors.bottom: parent.top
        anchors.right: parent.left
        source: "file:../qtquick3d_plane_pybullet/assets/images/terran.jpg"
    }
    Image {
        id: chess_texture
        anchors.bottom: parent.top
        anchors.right: parent.left
        source: "file:../qtquick3d_plane_pybullet/assets/images/chess.jpg"
    }
    //    GameMapRect{
    //        anchors.bottom: parent.bottom
    //        anchors.right: parent.right
    //        width: 160
    //        height: 120
    //        position: plane_bound.position
    //    }

//    Rectangle{
//        id:targetSigne
//        anchors.horizontalCenter:parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: parent.height * 11 / 20
//        visible:false
//        width: 100
//        height: 100
//        color: "#00000000"
//        border.width: 2
//        border.color: "#888888"
//        radius: width * 0.5
//    }

    Slider{
        z:10
        id:slider_volume
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to:1.0
        width: 200
        height: 20
        value: 0.5

        onValueChanged:{
            currentController.enabled = false
            currentController.enabled = true
        }
    }

    RigidBodyProperties{
        z:99
        id:bodyProp
        width: 200
        height: 315
        visible: false

        onVisibleChanged: {
            if(!visible){
                currentController.enabled = false
                currentController.enabled = true
            }
        }
    }
    AxisHelper{
        id:axis
        visible: false
      //  scale: Qt.vector3d(0.1,0.1,0.1)
         gridOpacity: 0.0
    }



    MouseArea {
        z:9
        anchors.fill: view

        onClicked: (mouse)=>{
                       if ((mouse.button == Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier)) {
                           var result = view.pick(mouse.x, mouse.y);
                           if (result.objectHit) {
                               var pickedObject = result.objectHit;
                               pickedObject.isPicked = !pickedObject.isPicked;
                               if(pickedObject.isPicked) {
                                   axis.parent = pickedObject
                                   axis.visible = true
                                   bodyProp.pickedObj = pickedObject
                                   bodyProp.visible = true
                                   bodyProp.x = mouse.x
                                   if((main_root.height-bodyProp.height)>mouseY)
                                   bodyProp.y = mouse.y
                                   else
                                   bodyProp.y =(main_root.height-bodyProp.height)

                               }
                               else{
                                   axis.visible = false
                                   bodyProp.visible = false
                               }
                           }
                       }
                   }
    }
}
