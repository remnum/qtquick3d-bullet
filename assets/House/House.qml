import QtQuick
import QtQuick3D
Node {
    id: rOOT
    Model {
        id: cube
        x: -1.66025
        y: 3.65641
        z: 0.0241804
        rotation: Qt.quaternion(-0.0356558, 0, 0.999364, 0)
        scale.x: 14.2646
        scale.y: 3.59229
        scale.z: 8.06392
        source: "meshes/cube.mesh"

        PrincipledMaterial {
            id: cottage_texture_material
            metalness: 1
            roughness: 1
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }
        materials: [
            cottage_texture_material
        ]
    }
}
