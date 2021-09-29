import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
import QtMultimedia

Node {
    id:root
    function deleteAll(){
        boundaryModel.destroy()
//        sound.destroy()
        rigidbody.destroy()
        objectmodel.destroy()
//        powerBar.destroy()
        listToDestroy.push(this)
    }

    QBulletRigidBody{
        id:rigidbody
        type: QBulletRigidBody.STATIC
        shape: QBulletRigidBody.BOX
        actionType: QBulletRigidBody.COLLESION_DELETE
        collisionActionType: QBulletRigidBody.PASSIVE
        simulation: true
        deActivation:true
        model: boundaryModel
        mass: 0.0
        force: 0.0
        maxPower:100
        onReleased:
            deleteAll();
    }
    Model{
        id:boundaryModel
        parent: view.scene
        source: "#Cube"
        position: root.position
        scale: Qt.vector3d(0.2,1.0,0.2)
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

        Model {
            id: objectmodel
            position: Qt.vector3d(0.0,-50.0,0.0)
            rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
            scale: Qt.vector3d(250.0,250.0,50.0)
            source: "file:../qtquick3d_plane_pybullet/assets/tree1/meshes/tree.mesh"

            PrincipledMaterial {
                id: trank_bark_material
                baseColorMap: Texture {
                    source: "file:../qtquick3d_plane_pybullet/assets/tree1/maps/bark_0021.png"
                    generateMipmaps: true
                    mipFilter: Texture.Linear
                }
                opacityChannel: Material.A
                roughness: 0.866667
                cullMode: Material.NoCulling
                alphaMode: PrincipledMaterial.Blend
            }

            PrincipledMaterial {
                id: polySurface1SG1_material
                baseColorMap: Texture {
                    source: "file:../qtquick3d_plane_pybullet/assets/tree1/maps/DB2X2_L01.png"
                    generateMipmaps: true
                    mipFilter: Texture.Linear
                }
                opacityChannel: Material.A
                roughness: 0.919102
                cullMode: Material.NoCulling
                alphaMode: PrincipledMaterial.Blend
            }
            materials: [
                trank_bark_material,
                polySurface1SG1_material
            ]
        }
    }
}


