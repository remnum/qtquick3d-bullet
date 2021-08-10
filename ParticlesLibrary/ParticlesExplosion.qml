import QtQuick
import QtQuick3D
import QtQuick3D.Particles3D

ParticleSystem3D{
    id:particles_system
    property var emitter:emitter
    SpriteParticle3D {
        id: sprite_particle
        sprite: Texture {
            source: "file:../qtquick3d_plane_pybullet/assets/images/explosion_01_strip13.png"
        }
        spriteSequence: SpriteSequence3D {
            frameCount: 13
            interpolate: true
        }
        maxAmount: 2000
        billboard: true
        blendMode: SpriteParticle3D.Screen
    }
    ParticleEmitter3D {
        id: emitter
        system: particles_system
        particle: sprite_particle
        position: Qt.vector3d(0.0,0.0,0.0)
        particleScale: 20
        velocity: VectorDirection3D {
            direction: Qt.vector3d(0, 100, 0)
            directionVariation: Qt.vector3d(50, 50, 50)
        }
        emitRate: 0
        lifeSpan: 1500
        lifeSpanVariation: 200
    }
}
