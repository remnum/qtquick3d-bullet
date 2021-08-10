import QtQuick
import QtQuick.Controls
import QtQuick3D
import QBulletRigidBody 1.0
import QtMultimedia
import "../Helpers"

Node {
    id:root
    function deleteAll(){
        boundaryModel.destroy()
    //    sound.destroy()
//        rigidbody.destroy()
//        objectmodel.destroy()
//        powerBar.destroy()
//        listToDestroy.push(this)
    }

    QBulletRigidBody{
        id:rigidbody
        model: boundaryModel

        onPowerLost:  {
            sound.play()
            explosionParticles.emitter.position=Qt.vector3d(model.position.x,model.position.y*-1.0,model.position.z)
            explosionParticles.emitter.burst(100,2000)
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
        scale: Qt.vector3d(1.0,1.6,1.0)
        property var rigidObject : rigidbody
        property var boundaryModel :  boundaryModel
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
            id: objectmodel
            position: Qt.vector3d(0.0,-50.0,0.0)
            scale: Qt.vector3d(20.0,13.0,20.0)
            y: 0.6715
            source: "file:../qtquick3d_plane_pybullet/assets/Tower/meshes/watchtowerHigh.mesh"
            DefaultMaterial{
                id:texture
                diffuseMap: Texture{
                    source: "file:../qtquick3d_plane_pybullet/assets/Tower/textures/Wood_Tower_Col.jpg"
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
