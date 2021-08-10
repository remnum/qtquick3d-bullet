import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
import QtMultimedia
import "../Helpers"

Node {
    id:root
    function deleteAll(){
        boundaryModel.destroy()
    //    sound.destroy()
        rigidbody.destroy()
//        objectmodel.destroy()
//        powerBar.destroy()
//        listToDestroy.push(this)
    }

    QBulletRigidBody{
        id:rigidbody
        type: QBulletRigidBody.DYNAMIC
        shape: QBulletRigidBody.BOX
        actionType: QBulletRigidBody.COLLESION_POWER_LOSS_ACTION_DELETE
        collisionActionType: QBulletRigidBody.PASSIVE
        simulation: true
        deActivation:true
        model: boundaryModel
        mass: 10.0
        force: 0.0
        power:800
        onPowerLost:  {
            explosionParticles.emitter.position=Qt.vector3d(model.position.x,model.position.y*-1.0,model.position.z)
            explosionParticles.emitter.burst(100,2000)
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
        scale: Qt.vector3d(2.0,1.0,1.0)
        property var rigidObject : rigidbody
        property var boundaryModel :  this
        property var objectModel :  objectmodel
        property string
        mcolor:"#FFFF00"
        property double colorOpacity:0.0
        pickable: true
        property bool isPicked:false

        materials: [PrincipledMaterial{
                baseColor: boundaryModel.mcolor
                opacity: boundaryModel.colorOpacity
            }]

        Model {
            id:objectmodel
            position: Qt.vector3d(-2.0,-25.0,0.0)
            scale: Qt.vector3d(45.0,25.0,50.0)
            source: "file:../qtquick3d_plane_pybullet/assets/House/meshes/cube.mesh"
            DefaultMaterial{
                id:texture
                diffuseMap: Texture{
                    source: "file:../qtquick3d_plane_pybullet/assets/House/textures/cottage_diffuse.png"
                }
            }
            materials: [
                texture
            ]
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

