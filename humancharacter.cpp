#include "humancharacter.h"

HumanCharacter::HumanCharacter(QObject *parent) : QObject(parent)
{
    _init_count =   0;
    connect(this,&HumanCharacter::startInit,this,&HumanCharacter::init);
}

HumanCharacter::~HumanCharacter()
{
    delete _body->getCollisionShape();
    delete _body->getMotionState();
    delete _body;
    delete _model;
}

void HumanCharacter::moveForward()
{

}

void HumanCharacter::moveBack()
{

}

void HumanCharacter::turnLeft()
{

}

void HumanCharacter::turnRight()
{

}

void HumanCharacter::jump()
{

}

QBulletPhysics *HumanCharacter::system()
{
    return _system;
}

void HumanCharacter::setSystem(QBulletPhysics *s)
{
    _system = s;
    connect(this,&HumanCharacter::finished,_system,&QBulletPhysics::setHumanCharacter);
    _init_count++;
    emit startInit();
}

QQuick3DModel *HumanCharacter::model()
{
    return _model;
}

void HumanCharacter::setModel(QQuick3DModel *m)
{
    _model = m;
    _init_count++;
    emit startInit();
}

btRigidBody *HumanCharacter::body()
{
    return _body;
}

btCollisionShape *HumanCharacter::collShape()
{
    return _collShape;
}

bool HumanCharacter::dynamic()
{
    return _dynamic;
}


void HumanCharacter::init()
{

    if(_init_count != 2)
        return;
//    QVector<btVector3> verts;
//    btVector3 bound_min =  btVector3(0,0,0);
//    btVector3 bound_max =  btVector3(0,0,0);

    _collShape = new btBoxShape(btVector3(_model->scale().x() * 50.0
                                          ,_model->scale().y() * 50.0
                                          ,_model->scale().z() * 50.0));
    btTransform collTransform;
    collTransform.setIdentity();
    collTransform.setOrigin(btVector3(_model->position().x(),_model->position().y(),_model->position().z()));
    collTransform.setRotation(btQuaternion(_model->rotation().x()
                                           ,_model->rotation().y()
                                           ,_model->rotation().z()
                                           ,_model->rotation().scalar()));
    btScalar mass(10000.0);
    btVector3 localInertia(1.0, 1.0, 1.0);
    _dynamic = true;
   // mass = _mass;

    if(_dynamic)
        _collShape->calculateLocalInertia(mass, localInertia);

    btDefaultMotionState* myMotionState = new btDefaultMotionState(collTransform);
    btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, myMotionState, _collShape, localInertia);
    _body = new btRigidBody(rbInfo);


    _body->setCollisionFlags( _body->getCollisionFlags() |btCollisionObject::CF_DYNAMIC_OBJECT);
    _body->setActivationState(DISABLE_DEACTIVATION);


    emit finished(this);
}
