import QtQuick 2.15
import QtQuick3D 1.15

Node {
    id: rOOT

    Model {
        id: plane2
        source: "meshes/plane2.mesh"

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_01_material
            baseColorMap: Texture {
                source: "maps/0.png"
                tilingModeHorizontal: Texture.Repeat
                tilingModeVertical: Texture.Repeat
            }
            opacityChannel: Material.A
            metalness: 0
            roughness: 0.894591
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_06_material
            baseColor: "#ff5c7993"
            metalness: 0
            roughness: 0.814408
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_07_material
            baseColor: "#ff736e68"
            metalness: 0
            roughness: 0.894591
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_04_material
            baseColor: "#ff1e1e1e"
            metalness: 0
            roughness: 0.894591
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_03_material
            baseColor: "#ff4b4b4b"
            metalness: 0
            roughness: 0.707501
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_02_material
            baseColor: "#ff774441"
            metalness: 0
            roughness: 0.894591
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_05_material
            baseColor: "#ff969696"
            metalness: 0
            roughness: 0.894591
            cullMode: Material.NoCulling
        }

        PrincipledMaterial {
            id: node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_08_material
            baseColor: "#ff4f4d66"
            metalness: 0
            roughness: 0.894591
            cullMode: Material.NoCulling
        }
        materials: [
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_01_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_06_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_07_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_04_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_03_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_02_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_05_material,
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_08_material
        ]
    }

    Model {
        id: router
        x: 0.813478
        y: 0.0383161
        z: 0.002
        source: "meshes/router.mesh"
        materials: [
            node14082_WWII_Plane_Japan_Kawasaki_Ki_61_body_01_material
        ]
    }
}
