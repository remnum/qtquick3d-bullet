#ifndef QBULLETPHYSICS_H
#define QBULLETPHYSICS_H

#include <QObject>
#include <QList>
#include <QSet>
#include <QVector3D>
#include <QDebug>
#include <QtQuick3D/private/qquick3dnode_p.h>
#include <QtQuick3D/private/qquick3dmodel_p.h>
#include <QtQuick3D>
#include <QQuick3DGeometry>

#include "bullet/btBulletDynamicsCommon.h"
#include "bullet/btBulletCollisionCommon.h"
#include "bullet/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.h"

#include "qbulletrigidbody.h"
#include "qbulletray.h"
#include "humancharacter.h"
#include "qbulletvehicle.h"

class QBulletRigidBody;
class QBulletRay;
class QBulletVehicle;
class HumanCharacter;

class QBulletPhysics : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(QList<QBulletRigidBody*> bodies READ bodies WRITE setBodies NOTIFY bodiesChanged)

public:
    explicit QBulletPhysics(QObject *parent = nullptr);
    ~QBulletPhysics();

signals:
    void bodiesCountChanged(int count);
    void bodiesChanged();
    void testPlaySound();


public slots:
    void addCharacter(QBulletRigidBody*);

    void addRigidBody(QBulletRigidBody*);
    void releaseRigidBody(QBulletRigidBody*);
    void setHumanCharacter(HumanCharacter*);

    void addVehicle(QBulletVehicle*);



    void addRay(QBulletRay*);
    void addInstanceRay(QQuick3DNode*,QQuick3DNode*);
    void addInstanceRay(QQuick3DNode*,double l);
    void addInstanceRay(QVector3D f,QVector3D t);
//    void addInstanceExpolsion(QVector3D o,double power);

    void addRigidBodytoExplosionList(QBulletRigidBody*);
    void addRigidBodytoReleaseList(QBulletRigidBody*);



    static void collideCallback( btDynamicsWorld *dynamicsWorld, btScalar timeStep);
    void CheckForCollisionEvents();
    void updateFrame();

//    QList<QBulletRigidBody *> bodies();
//    void setBodies(QList<QBulletRigidBody*> b);

private:
    btDefaultCollisionConfiguration* collisionConfiguration;
    btCollisionDispatcher* dispatcher;
    btBroadphaseInterface* overlappingPairCache;
    btSequentialImpulseConstraintSolver* solver;
    btDiscreteDynamicsWorld* dynamicsWorld;

  //  btAlignedObjectArray<btCollisionShape*> collisionShapes;

    int collide_group;
    int collide_mask;
//    QList<QBulletRigidBody*> _bodies;

    QMap<QBulletRigidBody*,btRigidBody*> *_world_simuation_bodies;
    QSet<QBulletRigidBody*> *_bodies_to_release;
    QSet<QBulletRigidBody*> *_explosions;

    QList<QBulletRay*> *rays;
    QList<QBulletRay*> *instance_rays;
    HumanCharacter *human;
};

#endif // QBULLETPHYSICS_H
