import QtQuick
import QtQuick3D
import QBulletRigidBody 1.0
Node {
    id:root
    QBulletRigidBody{
 //       system:phy
        type: QBulletRigidBody.DYNAMIC
        shape: QBulletRigidBody.BOX
        actionType: QBulletRigidBody.COLLESION_NONE
        collisionActionType: QBulletRigidBody.PASSIVE
        simulation: true
        deActivation:true
        model: block
        mass: 1.0
        force: 0.0
        maxPower:400
        onPassiveCollisionAction: {
            actionStatus = true
        }
    }

    Model{
        id:block
        parent: view.scene
        position: root.position
        eulerRotation: root.eulerRotation
        source: "#Cube"
        scale: Qt.vector3d(0.08,0.04,0.12)
        DefaultMaterial {
            id:material1
            diffuseColor: Qt.rgba(0.75 ,0.0 ,0.0 ,1.0 )
        }
        materials: [material1]
    }
}
