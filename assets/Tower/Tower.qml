import QtQuick
import QtQuick3D
Model {
    id: watchtowerHigh
    y: 0.6715
    source: "meshes/watchtowerHigh.mesh"

    PrincipledMaterial {
        id: watchtower_material
        baseColor: "#ffcccccc"
        roughness: 0.5
        cullMode: Material.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    materials: [
        watchtower_material
    ]
}
