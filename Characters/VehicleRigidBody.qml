import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QBulletRigidBody 1.0
import QtMultimedia

import "../Controllers"
import "../Helpers"
import "../Models"
import "../js/generateFunctions.js" as Genefunc

Node {
    id:root
    property var controller:bodyController

    Component.onCompleted: {
        v1.setWheel(wheel1,wheel2,rigidbody)
    }

    QBulletRigidBody{
        id:rigidbody
        type: QBulletRigidBody.KINEMATIC_COLLISON
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
        scale: Qt.vector3d(1.0,0.1,0.1)
        materials: [PrincipledMaterial{
                baseColor:"#FF0000"
                ///opacity: boundaryModel.colorOpacity
            }]
    }

    Model{
        id:wheel1
        parent: view.scene

        source: "#Sphere"
        position: Qt.vector3d(0.0,200.0,-400.0)
        scale: Qt.vector3d(0.3,0.3,0.3)
        materials: [PrincipledMaterial{
                baseColor: "#0000FF"
            }
        ]
    }

    Model{
        id:wheel2
        parent: view.scene

        source: "#Sphere"
        position: Qt.vector3d(0.0,200.0,-400.0)
        scale: Qt.vector3d(0.3,0.3,0.3)
        materials: [PrincipledMaterial{
                baseColor: "#FF00FF"
            }
        ]


        WasdController {
            id:bodyController
            parent: view
            focus: true
            enabled: true
            controlledObject : boundaryModel
            speed: 2
        }
    }

}
