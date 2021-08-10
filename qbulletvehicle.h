#ifndef QBULLETVEHICLE_H
#define QBULLETVEHICLE_H

#include <QObject>
#include "qbulletphysics.h"
#include "qbulletrigidbody.h"

class QBulletPhysics;
class QBulletRigidBody;

class QBulletVehicle : public QObject
{
    Q_OBJECT
public:
    explicit QBulletVehicle(QObject *parent = nullptr);

signals:

public slots:
    void setWheel(QQuick3DModel*,QQuick3DModel*,QBulletRigidBody*);

public:
    QBulletRigidBody *_front_right_wheel;
    QBulletRigidBody *_front_left_wheel;
    QBulletRigidBody *_front_axis;

    btPoint2PointConstraint *cons1;
    btPoint2PointConstraint *cons2;

};

#endif // QBULLETVEHICLE_H
