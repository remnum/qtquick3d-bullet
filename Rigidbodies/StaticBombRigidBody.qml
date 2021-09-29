import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
import QtMultimedia

Node {
    id:root
    function deleteAll(){
        boundaryModel.destroy()
  //      sound.destroy()
   //     rigidbody.destroy()
   //     delete timer
   //     listToDestroy.push(this)
    }

    Timer{
        id:timer
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            boundaryModel.position=
                    Qt.vector3d(
                        boundaryModel.position.x +boundaryModel.forward.x*20.0
                        ,boundaryModel.position.y +boundaryModel.forward.y*20.0
                        ,boundaryModel.position.z +boundaryModel.forward.z*20.0)

        }
    }

    QBulletRigidBody{
        id:rigidbody
        type: QBulletRigidBody.KINEMATIC_COLLISON
        shape: QBulletRigidBody.SPHERE
        actionType: QBulletRigidBody.COLLESION_ACTION_DELETE
        collisionActionType: QBulletRigidBody.ACTIVE
        simulation: true
        deActivation: true
        model: boundaryModel
        mass: 1.0
        force: 0.0
        maxPower:100
        onActiveCollisionAction : {
            sound.play()
            explosionParticles.emitter.position=Qt.vector3d(model.position.x,model.position.y,model.position.z)
            explosionParticles.emitter.burst(10)
            actionStatus = true
        }
        onReleased: {
            timer.stop()
            deleteAll()
        }
    }

    Model{
        id:boundaryModel
        parent: view.scene
        position: root.position
        eulerRotation: root.eulerRotation
        source: "#Sphere"
        scale: Qt.vector3d(0.05,0.05,0.2)
        DefaultMaterial {
            id:material1
            diffuseColor: Qt.rgba(0.9, 0.65, 0.35,1.0 )
        }
        materials: [material1]
    }


    SoundEffect{
        id :sound
        volume:sound_volume
        muted: sound_mute
        source: "file:../qtquick3d_plane_pybullet/assets/sound_effects/bomb4.wav"
    }

}

