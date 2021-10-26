import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QBulletRigidBody 1.0
import CharacterControlBody 1.0

import QtMultimedia

import "../Controllers"
import "../Helpers"
import "../Models"
import "../js/generateFunctions.js" as Genefunc

Node {
    id:root
    property var controller:bodyController

    CharacterControlBody{
        id:rigidbody
        type: QBulletRigidBody.DYNAMIC
        shape: QBulletRigidBody.BOX
        actionType: QBulletRigidBody.COLLESION_NONE
        collisionActionType: QBulletRigidBody.PASSIVE
        simulation: true
        deActivation:true
        model: boundaryModel
        mass: 1.0
        force: 0.0
        maxPower:800
        onPowerLost:  {
            emitter.position=Qt.vector3d(model.position.x,model.position.y*-1.0,model.position.z)
            emitter.burst(100,2000)
            sound.play()
            actionStatus = true
        }
        onReleased:
            deleteAll();
    }




    Model{
        id:boundaryModel
        parent: view.scene
        source: "#Cube"
        position: root.position
        scale: Qt.vector3d(0.2,0.2,0.2)
        materials: [PrincipledMaterial{
                baseColor:"#FF0000"
                ///opacity: boundaryModel.colorOpacity
            }]
        AxisHelper{
            scale: Qt.vector3d(0.2,0.2,0.2)

        }
    }


        CharacterController {
            id:bodyController
            parent: view
            focus: true
            enabled: true
            controlledObject : boundaryModel
            mouseControlledObject:cam1

            speed: 2
            onEmitForward:
                rigidbody.forward();
            onEmitBack:
                rigidbody.back();
            onEmitStop:
                rigidbody.stop();
            onEmitRotation :(angle)=>
                rigidbody.rotate(angle);

        }


}
