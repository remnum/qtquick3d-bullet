import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
import LandShape 1.0

Node {
    id:root
    QBulletRigidBody{
        id:land_mesh_body
  //      system:phy
        type: QBulletRigidBody.STATIC
        shape: QBulletRigidBody.MESH
        actionType: QBulletRigidBody.COLLESION_NONE
        collisionActionType: QBulletRigidBody.PASSIVE
        simulation: true
        model: rectmesh
        deActivation: false
        mass: 0.0
        force: 0.0
        maxPower:100
    }

    Model{
        id:rectmesh
        visible: true
        parent: view.scene
        position:  root.position
        scale:  Qt.vector3d(600.0,600.0,600.0)
        eulerRotation:Qt.vector3d(0.0,0.0,0.0)
        castsShadows: true

        geometry: LandShape{
            id:landShapeGeo
            normals:true
            normalXY: 1
            uv:true
            uvAdjust: 1
        }
        DefaultMaterial {
            id: street_land_mat1
            diffuseMap: Texture{
                sourceItem: checkbox_texture.checked?  terrain_texture :chess_texture
                scaleU: checkbox_texture.checked?2:2
                scaleV: checkbox_texture.checked?2:2
            }
            specularAmount: 1.0
        }
        materials: [street_land_mat1]
    }
}
