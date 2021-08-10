import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
import QtMultimedia
import "../Controllers"
import "../Helpers"
import "../Models"
import "../js/generateFunctions.js" as Genefunc

Node {
    id:root
    property var controller:bodyController

    QBulletRigidBody{
        id:rigidbody
        type: QBulletRigidBody.KINEMATIC_COLLISON
        shape: QBulletRigidBody.BOX
        actionType: QBulletRigidBody.COLLESION_NONE
        collisionActionType: QBulletRigidBody.ACTIVE
        simulation: true
        deActivation:true
        model: boundaryModel
        mass: 10.0
        force: 0.0
        power:800
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
        scale: Qt.vector3d(0.8,1.2,1.0)
        property var rigidObject : rigidbody
        property var boundaryModel :  this
        property var objectModel :  objectmodel
        property string
        mcolor:"#FFFF00"
        property double colorOpacity:0.5
        pickable: true
        property bool isPicked:false

        materials: [PrincipledMaterial{
                baseColor: boundaryModel.mcolor
                opacity: boundaryModel.colorOpacity
            }]


        MachinegunTurret{
            id:objectmodel
            position: Qt.vector3d(0.0,0.0,0.0)
            eulerRotation:Qt.vector3d(0.0,180.0,0.0)
            scale: Qt.vector3d(30.0,30.0,30.0)
        }


        MachineGunController{
            id:bodyController
            parent: view
            enabled: true
            controlledObject : boundaryModel
            mouseControlledObject:cam1
            speed: 1
            forwardSpeed: 2.0
            leftSpeed: 2.0
            rightSpeed: 2.0
            onRotateLeft:
                objectmodel.rotateLeftRightGun(leftSpeed);
            onRotateRight:
                objectmodel.rotateLeftRightGun(rightSpeed * -1.0);

            onRotateUp:
                objectmodel.rotateUpDowbGun(forwardSpeed*-1.0);

            onRotateDown:
                objectmodel.rotateUpDowbGun(forwardSpeed );

            onEmitFire:
                Genefunc.fire(objectmodel.gun);

            onEmitThrowBomb:
                Genefunc.gravityBomb(objectmodel.gun);

            onEmitMissle:
                Genefunc.missle(objectmodel.gun);

        }


        TargetProgressBar{
            id:powerBar
            width: 100
            height: 10
            x:-50
            y:-60
            from: 0
            to:rigidbody.power
            value: rigidbody.currentPower
        }
    }

    SoundEffect{
        id :sound
        volume:sound_volume
        muted: sound_mute
        source: "file:../qtquick3d_plane_pybullet/assets/sound_effects/bomb4.wav"
    }

}
