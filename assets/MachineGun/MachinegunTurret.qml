import QtQuick
import QtQuick3D
Node {
    id: machinegunTurret_obj
    Model {
        id: motor_default5
        source: "meshes/motor_default5.mesh"

        DefaultMaterial {
            id: default5_material
            diffuseColor: "#ff999999"
        }
        materials: [
            default5_material
        ]
    }
    Model {
        id: base_default4
        source: "meshes/base_default4.mesh"

        DefaultMaterial {
            id: default4_material
            diffuseColor: "#ff999999"
        }
        materials: [
            default4_material
        ]
    }
    Model {
        id: base_default6
        source: "meshes/base_default6.mesh"

        DefaultMaterial {
            id: default6_material
            diffuseColor: "#ff999999"
        }
        materials: [
            default6_material
        ]
    }
    Model {
        id: gun_default3
        source: "meshes/gun_default3.mesh"

        DefaultMaterial {
            id: default3_material
            diffuseColor: "#ff999999"
        }
        materials: [
            default3_material
        ]
    }
    Model {
        id: barrelGuard_default2
        source: "meshes/barrelGuard_default2.mesh"

        DefaultMaterial {
            id: default2_material
            diffuseColor: "#ff999999"
        }
        materials: [
            default2_material
        ]
    }
}
