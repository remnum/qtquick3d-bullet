import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
import QtMultimedia

Node {
    id:root
    function deleteAll(){
        boundaryModel.destroy()
  //      sound.destroy()
        rigidbody.destroy()
//        listToDestroy.push(this)
    }

    QBulletRigidBody{
        id:rigidbody
        type: QBulletRigidBody.DYNAMIC
        shape: QBulletRigidBody.SPHERE
        actionType: QBulletRigidBody.COLLESION_ACTION_EXPLOSION
        collisionActionType: QBulletRigidBody.ACTIVE
        simulation: true
        deActivation:true
        model: boundaryModel
        mass: 10.0
        force: 0.0
        power:100
        onActiveCollisionAction : {
            sound.play()
            explosionParticles.emitter.position=Qt.vector3d(model.position.x,model.position.y,model.position.z)
            explosionParticles.emitter.burst(10)
            actionStatus = true
        }
        onReleased:
            deleteAll();
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

