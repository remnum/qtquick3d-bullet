import QtQuick
import QtQuick3D
Node {
    id: machinegunTurret_obj

    property var gun : gun_default3
    property var gun1 : barrelGuard_default2

    function rotateLeftRightGun(val) {
        //machinegunTurret_obj.eulerRotation.y += val
        gun_default3.eulerRotation.y += val
    }

    function rotateUpDowbGun(val) {
        gun_default3.eulerRotation.x += val
        barrelGuard_default2.eulerRotation.x += val
    }


    Model {
        id: motor_default5
        source: "file:../qtquick3d_plane_pybullet/assets/MachineGun/meshes/motor_default5.mesh"

        DefaultMaterial {
            id: default5_material
            diffuseColor: "#00FFFF"
        }
        materials: [
            default5_material
        ]
    }
    Model {
        id: base_default4
        source: "file:../qtquick3d_plane_pybullet/assets/MachineGun/meshes/base_default4.mesh"

        DefaultMaterial {
            id: default4_material
            diffuseColor: "#01777e"
        }
        materials: [
            default4_material
        ]
    }
    Model {
        id: base_default6
        source: "file:../qtquick3d_plane_pybullet/assets/MachineGun/meshes/base_default6.mesh"

        DefaultMaterial {
            id: default6_material
            diffuseColor: "#034549"
        }
        materials: [
            default6_material
        ]
    }
    Model {
        id: gun_default3
        source: "file:../qtquick3d_plane_pybullet/assets/MachineGun/meshes/gun_default3.mesh"

        DefaultMaterial {
            id: default3_material
            diffuseColor: "#00FF00"
        }
        materials: [
            default3_material
        ]
    }
    Model {
        id: barrelGuard_default2
        source: "file:../qtquick3d_plane_pybullet/assets/MachineGun/meshes/barrelGuard_default2.mesh"

        DefaultMaterial {
            id: default2_material
            diffuseColor: "#0000FF"
        }
        materials: [
            default2_material
        ]
    }
}
