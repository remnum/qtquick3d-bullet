import QtQuick
import QtQuick3D
Model {
    id: tree
    rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
    scale.y: 1
    scale.z: 1
    source: "meshes/tree.mesh"

    PrincipledMaterial {
        id: trank_bark_material
        baseColorMap: Texture {
            source: "maps/bark_0021.png"
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
            source: "maps/DB2X2_L01.png"
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
