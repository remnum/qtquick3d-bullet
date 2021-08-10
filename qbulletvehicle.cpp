#include "qbulletvehicle.h"

QBulletVehicle::QBulletVehicle(QObject *parent) : QObject(parent)
{

}

void QBulletVehicle::setWheel(QQuick3DModel *frw, QQuick3DModel *flw, QBulletRigidBody *fa)
{
    _front_right_wheel = new QBulletRigidBody;
    _front_right_wheel->setType(QBulletRigidBody::DYNAMIC);
    _front_right_wheel->setMass(0.001);
    _front_right_wheel->setModel(frw);


    _front_left_wheel = new QBulletRigidBody;
    _front_left_wheel->setType(QBulletRigidBody::DYNAMIC);
    _front_left_wheel->setMass(0.001);
    _front_left_wheel->setModel(flw);


    _front_axis = fa;// new QBulletRigidBody;
//    _front_axis->setType(QBulletRigidBody::DYNAMIC);
//    _front_axis->setMass(0.1);
//    _front_axis->setModel(fa);

    cons1  =
           new btPoint2PointConstraint( *_front_right_wheel->body() , *_front_axis->body()
                                        ,btVector3(15 ,0.0 ,0.0),btVector3(50.0 ,0.0 ,0.0));

    cons2  =
           new btPoint2PointConstraint( *_front_left_wheel->body() , *_front_axis->body()
                                        ,btVector3(-15 ,0.0 ,0.0),btVector3(-50.0 ,0.0 ,0.0));

   QBulletRigidBody::_system->addVehicle(this);
}
