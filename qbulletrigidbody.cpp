#include "qbulletrigidbody.h"
QBulletPhysics*  QBulletRigidBody::_system = 0;

QBulletRigidBody::QBulletRigidBody(QObject *parent):
    QObject(parent)
{
    _action_status = false;
    _type = STATIC;
    _shape = BOX;
    _action_type = COLLESION_NONE;
    _collison_action_type = PASSIVE;
    _mass = 0.0;
    _force = 0.0;
    _power.setMaxPower(100.0);
    _power.setDamagePower(1.0);
    _power.setCurrentPower(100.0);
    _body =0;
    _model = 0;
    _simulation = true;
    _deActivation = true;
    connect(this,&QBulletRigidBody::checkInit,this,&QBulletRigidBody::startInit);
}

QBulletRigidBody::~QBulletRigidBody()
{
    if( _body != 0) {
        if(  _body->getCollisionShape() != 0)
            delete _body->getCollisionShape();
        if( _body->getMotionState() != 0)
            delete _body->getMotionState();
        delete _body;
    }
}

void QBulletRigidBody::release()
{
    _system->releaseRigidBody(this);
    emit released();
}


QBulletRigidBody::TYPE QBulletRigidBody::type()
{
    return _type;
}

void QBulletRigidBody::setType(QBulletRigidBody::TYPE t)
{
    _type = t;
    emit typeChanged();
    emit checkInit();
}

QBulletRigidBody::SHAPE QBulletRigidBody::shape()
{
    return _shape;
}

void QBulletRigidBody::setShape(QBulletRigidBody::SHAPE s)
{
    _shape = s;
    if(_model !=0){
        switch(_shape){
        case QBulletRigidBody::BOX:
            _model->setSource(QUrl("#Cube"));
        break;

        case QBulletRigidBody::SPHERE:
            _model->setSource(QUrl("#Sphere"));
        break;

        case QBulletRigidBody::CONE:
            _model->setSource(QUrl("#Cone"));
        break;
        }

    }
    emit shapeChanged();
    emit checkInit();
}

QBulletRigidBody::ACTION_TYPE QBulletRigidBody::actionType()
{
    return _action_type;
}

void QBulletRigidBody::setActionType(ACTION_TYPE a)
{
    _action_type = a;
    emit actionTypeChanged();
    emit checkInit();
}

QBulletRigidBody::COLLISION_ACTION_TYPE QBulletRigidBody::collisionActionType()
{
    return _collison_action_type;
}

void QBulletRigidBody::setCollisionActionType(COLLISION_ACTION_TYPE t)
{
    _collison_action_type = t;
    emit checkInit();
}

QQuick3DModel *QBulletRigidBody::model()
{
    return _model;
}

void QBulletRigidBody::setModel(QQuick3DModel *m)
{
    _model = m;
    emit modelChanged();
    emit checkInit();
}

float QBulletRigidBody::mass()
{
    return _mass;
}

void QBulletRigidBody::setMass(float m)
{
    _mass = m;
    emit massChanged();
    emit checkInit();
}

float QBulletRigidBody::force()
{
    return _force;
}

void QBulletRigidBody::setForce(float f)
{
    _force = f;
    emit forceChanged();
    emit checkInit();
}

bool QBulletRigidBody::simulation()
{
    return _simulation;
}

void QBulletRigidBody::setSimulation(bool s)
{
    _simulation = s;
    emit simulationChanged();
    emit checkInit();
}

int QBulletRigidBody::damagePower()
{
    return _power.damagePower();
}

void QBulletRigidBody::setDamagePower(int p)
{
    _power.setDamagePower(p);
    emit damagePowerChanged();
}

int QBulletRigidBody::maxPower()
{
    return _power.maxPower();
}

void QBulletRigidBody::setMaxPower(int p)
{
    _power.setMaxPower(p);
    emit maxPowerChanged();
    _power.setCurrentPower(p);
    emit currentPowerChanged();
}

int QBulletRigidBody::currentPower()
{
    return _power.currentPower();
}

void QBulletRigidBody::setCurrentPower(int p)
{
    _power.setCurrentPower(p);
    emit currentPowerChanged();
}

bool QBulletRigidBody::deActivation()
{
    return _deActivation;
}

void QBulletRigidBody::setDeActivation(bool d)
{
    _deActivation = d;
    emit deActivationChanged();
    emit checkInit();
}

btRigidBody *QBulletRigidBody::body()
{
    return _body;
}

btCollisionShape *QBulletRigidBody::collShape()
{
    return _collShape;
}

bool QBulletRigidBody::dynamic()
{
    return _dynamic;
}


void QBulletRigidBody::action()
{
    if(!_action_status) {
        switch (_collison_action_type) {
        case PASSIVE:
            emit passiveCollisionAction();
            break;
        case ACTIVE:
            emit activeCollisionAction();
            break;
        }
    }
    switch (_action_type) {
    case QBulletRigidBody::COLLESION_NONE :
        break;
    case QBulletRigidBody::COLLESION_DELETE :
        _system->addRigidBodytoReleaseList(this);
        break;
    case QBulletRigidBody::COLLESION_ACTION :
        if(_action_status)
            _system->addRigidBodytoReleaseList(this);
        break;
    case QBulletRigidBody::COLLESION_ACTION_EXPLOSION :
        if(_action_status)
            _system->addRigidBodytoExplosionList(this);
        break;
    case QBulletRigidBody::COLLESION_ACTION_DELETE :
        if(_action_status)
            _system->addRigidBodytoReleaseList(this);
        break;

    case QBulletRigidBody::COLLESION_POWER_LOSS_STATIC :
        break;

    case QBulletRigidBody::COLLESION_POWER_LOSS_DELETE :
        if(_power.currentPower() > 0 ) {
            emit currentPowerChanged();
        }
        else if(_power.currentPower() <= 0 ) {
            _system->addRigidBodytoReleaseList(this);
        }
        break;

    case QBulletRigidBody::COLLESION_POWER_LOSS_ACTION_STATIC :
        break;

    case QBulletRigidBody::COLLESION_POWER_LOSS_ACTION_DELETE :
        if(_power.currentPower() > 0 && !_action_status) {
            emit currentPowerChanged();
        }
        else if(_power.currentPower() <= 0 && !_action_status) {
            emit powerLost();
        }
        else if(_action_status)
            _system->addRigidBodytoReleaseList(this);
        break;

    case QBulletRigidBody::COLLESION_TURN_STATIC :
        break;
    }
}

bool QBulletRigidBody::actionStatus()
{
    return _action_status;
}

void QBulletRigidBody::setActionStatus(bool a)
{
    _action_status = a;
    action();
}

void QBulletRigidBody::powerUp(int p)
{
    _power.setMaxPower(_power.maxPower()+p);
    emit maxPowerChanged();
}

void QBulletRigidBody::powerDown(int p)
{
    _power.setMaxPower(_power.maxPower()-p);
    emit maxPowerChanged();
}

void QBulletRigidBody::calculateCollisionPower(QBulletRigidBody *a, QBulletRigidBody *b)
{
    a->setCurrentPower(a->currentPower()-b->damagePower());
    b->setCurrentPower(b->currentPower()-a->damagePower());
    qDebug()  << a->currentPower() << " : " << b->currentPower();
}

void QBulletRigidBody::clearBodyFromSystem()
{
    if( _body != 0 && _system != 0) {
        _system->releaseRigidBody(this);
        if(  _body->getCollisionShape() != 0)
            delete _body->getCollisionShape();
        if( _body->getMotionState() != 0)
            delete _body->getMotionState();
        delete _body;
    }
}

void QBulletRigidBody::startInit()
{
    if(_system == 0 || _model == 0)
        return;
    init();
}


void QBulletRigidBody::init()
{
    clearBodyFromSystem();
    QQuick3DGeometry *geo = 0;
    btTriangleMesh *triangles_mesh = 0;
    btBvhTriangleMeshShape *bvh  = 0;

    QVector<btVector3> verts;
    btVector3 bound_min =  btVector3(0,0,0);
    btVector3 bound_max =  btVector3(0,0,0);
    int stride = 0;
    int data_size = 0;
    int totalTriangles =  0;
    float x=1.0f;
    float y=1.0f;
    float z=1.0f;

    union {
        float f;
        uchar b[4];
    } u;

    switch(_shape){
    case SHAPE::BOX:
        _collShape = new btBoxShape(btVector3(_model->scale().x() * 50.0
                                              ,_model->scale().y() * 50.0
                                              ,_model->scale().z() * 50.0));
        break;
    case SHAPE::SPHERE:
        _collShape = new btSphereShape(_model->scale().y() * 50.0);
        break;
    case SHAPE::CONE:
        _collShape = new btConeShape(_model->scale().x() * 50.0,_model->scale().y() * 50.0);
        break;
    case SHAPE::MESH:
        geo = _model->geometry();
        data_size = geo->vertexData().size();
        triangles_mesh = new btTriangleMesh;
        stride =  geo->stride();
        bound_min =  btVector3(geo->boundsMin().x(),geo->boundsMin().y(),geo->boundsMin().z());
        bound_max =  btVector3(geo->boundsMax().x(),geo->boundsMax().y(),geo->boundsMax().z());

        for(int i=0 ;i <data_size;i=i+stride) {
            u.b[0] = geo->vertexData().at(i);
            u.b[1] = geo->vertexData().at(i+1);
            u.b[2] = geo->vertexData().at(i+2);
            u.b[3] = geo->vertexData().at(i+3);
            x = u.f *1.0f;
            u.b[0] = geo->vertexData().at(i+4);
            u.b[1] = geo->vertexData().at(i+5);
            u.b[2] = geo->vertexData().at(i+6);
            u.b[3] = geo->vertexData().at(i+7);
            y = u.f *1.0f;
            u.b[0] = geo->vertexData().at(i+8);
            u.b[1] = geo->vertexData().at(i+9);
            u.b[2] = geo->vertexData().at(i+10);
            u.b[3] = geo->vertexData().at(i+11);
            z = u.f *1.0f;
            verts.append(btVector3(x,y,z));
        }
        totalTriangles = (data_size/stride)/3;
        for(int i = 0 ;i <totalTriangles;i++){
            triangles_mesh->addTriangle(verts.at(i*3),verts.at(i*3+1),verts.at(i*3+2));
        }
        bvh  = new btBvhTriangleMeshShape(triangles_mesh,true,bound_min,bound_max);
        _collShape  = new btScaledBvhTriangleMeshShape(bvh,btVector3(_model->scale().x()
                                                                     ,_model->scale().y()
                                                                     ,_model->scale().z()));
        break;
    }

    btTransform collTransform;
    collTransform.setIdentity();
    collTransform.setOrigin(btVector3(_model->position().x(),_model->position().y(),_model->position().z()));
    collTransform.setRotation(btQuaternion(_model->rotation().x()
                                           ,_model->rotation().y()
                                           ,_model->rotation().z()
                                           ,_model->rotation().scalar()));
    _dynamic = false;
    btScalar mass(0.0);
    btVector3 localInertia(1.0 ,1.0 ,1.0);

    switch (_type) {
    case TYPE::STATIC:
        _dynamic = false;
        mass = _mass;
        break;
    case TYPE::DYNAMIC:
        _dynamic = true;
        mass = _mass;
        break;
    case TYPE::KINEMATIC:
        _dynamic = true;
        mass = _mass;
        break;

    case TYPE::KINEMATIC_COLLISON:
        _dynamic = true;
        mass = _mass;
        break;

    }
    if(_dynamic)
        _collShape->calculateLocalInertia(mass, localInertia);


    btDefaultMotionState* myMotionState = new btDefaultMotionState(collTransform);
    btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, myMotionState, _collShape, localInertia);
    _body = new btRigidBody(rbInfo);

    _body->setFriction(55.0);

    switch (_type) {
    case TYPE::STATIC:
        _body->setCollisionFlags( _body->getCollisionFlags() |btCollisionObject::CF_STATIC_OBJECT);
        break;

    case TYPE::DYNAMIC:
        _body->setCollisionFlags( _body->getCollisionFlags() |btCollisionObject::CF_DYNAMIC_OBJECT);
        break;

    case TYPE::KINEMATIC:
        _body->setCollisionFlags( _body->getCollisionFlags() |btCollisionObject::CF_KINEMATIC_OBJECT);
        break;

    case TYPE::KINEMATIC_COLLISON:
        _body->setCollisionFlags( _body->getCollisionFlags() |btCollisionObject::CF_CHARACTER_OBJECT);
        break;
    }
    if(_deActivation)
        _body->setActivationState(DISABLE_DEACTIVATION);

    _system->addRigidBody(this);
}




