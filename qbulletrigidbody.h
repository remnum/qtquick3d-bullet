#ifndef QBULLETRIGIDBODY_H
#define QBULLETRIGIDBODY_H

#include <QObject>
#include <QQmlParserStatus>

#include <QtQuick3D/private/qquick3dnode_p.h>
#include <QtQuick3D/private/qquick3dmodel_p.h>
#include <QtQuick3D>
#include <QQuick3DGeometry>
#include "bullet/btBulletDynamicsCommon.h"
#include "bullet/btBulletCollisionCommon.h"
#include "bullet/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.h"
#include "qbulletphysics.h"

#include "bodypowersystem.h"

class QBulletPhysics;

class QBulletRigidBody : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(QBulletRigidBody)

    Q_PROPERTY(TYPE type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(SHAPE shape READ shape WRITE setShape NOTIFY shapeChanged)
    Q_PROPERTY(ACTION_TYPE actionType READ actionType WRITE setActionType NOTIFY actionTypeChanged)
    Q_PROPERTY(COLLISION_ACTION_TYPE collisionActionType READ collisionActionType WRITE setCollisionActionType)
    Q_PROPERTY(QQuick3DModel* model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(float mass READ mass WRITE setMass NOTIFY massChanged)
    Q_PROPERTY(float force READ force WRITE setForce NOTIFY forceChanged)
    Q_PROPERTY(bool simulation READ simulation WRITE setSimulation NOTIFY simulationChanged)
    Q_PROPERTY(int maxPower READ maxPower WRITE setMaxPower NOTIFY maxPowerChanged)
    Q_PROPERTY(int damagePower READ damagePower WRITE setDamagePower NOTIFY damagePowerChanged)
    Q_PROPERTY(int currentPower READ currentPower WRITE setCurrentPower NOTIFY currentPowerChanged)
    Q_PROPERTY(bool deActivation READ deActivation WRITE setDeActivation NOTIFY deActivationChanged)
    Q_PROPERTY(bool actionStatus READ actionStatus WRITE setActionStatus NOTIFY actionStatusChanged)
    QML_ELEMENT

public:
    enum TYPE{
        STATIC,
        DYNAMIC,
        KINEMATIC,
        KINEMATIC_COLLISON
    };
    Q_ENUM(TYPE)

    enum SHAPE{
        BOX,
        SPHERE,
        CONE,
        MESH
    };
    Q_ENUM(SHAPE)

    enum ACTION_TYPE{
        COLLESION_NONE,
        COLLESION_DELETE,
        COLLESION_ACTION,
        COLLESION_ACTION_DELETE,
        COLLESION_ACTION_EXPLOSION,
        COLLESION_POWER_LOSS_STATIC,
        COLLESION_POWER_LOSS_DELETE,
        COLLESION_POWER_LOSS_ACTION_STATIC,
        COLLESION_POWER_LOSS_ACTION_DELETE,
        COLLESION_TURN_STATIC
    };
    Q_ENUM(ACTION_TYPE)

    enum COLLISION_ACTION_TYPE{
        ACTIVE,
        PASSIVE
    };
    Q_ENUM(COLLISION_ACTION_TYPE)

public:
    Q_INVOKABLE explicit QBulletRigidBody(QObject *parent = nullptr);

    ~QBulletRigidBody();

    void release();

    static QBulletPhysics* _system;

signals:
    void checkInit();
    void finished(QBulletRigidBody*);
    void passiveCollisionAction();
    void activeCollisionAction();
    void released();

signals:
    void typeChanged();
    void shapeChanged();
    void actionTypeChanged();
    void modelChanged();
    void massChanged();
    void forceChanged();
    void simulationChanged();

    void maxPowerChanged();
    void damagePowerChanged();
    void currentPowerChanged();

    void deActivationChanged();
    void actionStatusChanged();

    void powerLost();


public slots:
    TYPE    type();
    void    setType(TYPE t);

    SHAPE   shape();
    void    setShape(SHAPE s);

    ACTION_TYPE actionType();
    void    setActionType(ACTION_TYPE a);

    COLLISION_ACTION_TYPE collisionActionType();
    void setCollisionActionType(COLLISION_ACTION_TYPE);

    QQuick3DModel *model();
    void    setModel(QQuick3DModel* m);

    float   mass();
    void    setMass(float m);

    float   force();
    void    setForce(float f);

    bool    simulation();
    void    setSimulation(bool s);

    int     maxPower();
    void    setMaxPower(int p);

    int     damagePower();
    void    setDamagePower(int p);

    int     currentPower();
    void    setCurrentPower(int p);

    bool    deActivation();
    void    setDeActivation(bool d);

    btRigidBody *body();
    btCollisionShape *collShape();
    bool    dynamic();

    void action();
    bool actionStatus(); // false=action in progress , true=action finished
    void setActionStatus(bool a);

    void powerUp(int);
    void powerDown(int);

public:
    void static calculateCollisionPower(QBulletRigidBody*,QBulletRigidBody*);


private:
    void clearBodyFromSystem();
    void startInit();
    void init();

private:
    TYPE _type;
    SHAPE _shape;
    ACTION_TYPE _action_type;
    QQuick3DModel* _model;
    float   _mass;
    float   _force;
    bool    _simulation;

    BodyPowerSystem _power;

    btRigidBody* _body;
    btCollisionShape* _collShape;
    bool _dynamic;

    COLLISION_ACTION_TYPE _collison_action_type;
    bool _deActivation;
    bool _action_status;
};

#endif // QBULLETRIGIDBODY_H
