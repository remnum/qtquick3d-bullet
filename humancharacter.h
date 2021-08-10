#ifndef HUMANCHARACTER_H
#define HUMANCHARACTER_H

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

class QBulletPhysics;


class HumanCharacter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QBulletPhysics* system READ system WRITE setSystem)
    Q_PROPERTY(QQuick3DModel* model READ model WRITE setModel NOTIFY modelChanged)
    QML_NAMED_ELEMENT(HumanCharacter)
    QML_ELEMENT

public:
    explicit HumanCharacter(QObject *parent = nullptr);
    ~HumanCharacter();

public:
    void moveForward();
    void moveBack();
    void turnLeft();
    void turnRight();
    void jump();

public slots:
    QBulletPhysics *system();
    void setSystem(QBulletPhysics*);

    QQuick3DModel *model();
    void setModel(QQuick3DModel* m);

    btRigidBody *body();
    btCollisionShape *collShape();
    bool    dynamic();

signals:
    void startInit();
    void finished(HumanCharacter*);

signals:
    void modelChanged();

private:
    void init();

private:
    QBulletPhysics* _system;
    QQuick3DModel* _model;

    float   _mass;
    float   _force;
    bool    _simulation;

    btRigidBody* _body;
    btCollisionShape* _collShape;
    bool _dynamic;

    int _init_count;
};

#endif // HUMANCHARACTER_H
