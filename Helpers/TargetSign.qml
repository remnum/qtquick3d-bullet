import QtQuick
import QtQuick3D

Model{
    source: "#Sphere"
    scale: Qt.vector3d(0.1,0.1,0.1)
    DefaultMaterial {
        id:material1
        diffuseColor: Qt.rgba(1.0 ,0.4 ,0.4 ,1.0 )
    }
    materials: [material1]
}
