#include "qbulletphysics.h"

std::vector<btVector3> collisions;


QBulletPhysics::QBulletPhysics(QObject *parent) : QObject(parent)
{
    QBulletRigidBody::_system = this;
    _world_simuation_bodies  = new QMap<QBulletRigidBody*,btRigidBody*>;
    _bodies_to_release = new  QSet<QBulletRigidBody*>;
    _explosions = new QSet<QBulletRigidBody*>;

    rays = new QList<QBulletRay*>;
    instance_rays = new QList<QBulletRay*>;
    human = 0;

    collisionConfiguration = new btDefaultCollisionConfiguration();
    dispatcher = new btCollisionDispatcher(collisionConfiguration);
    overlappingPairCache = new btDbvtBroadphase();
    solver = new btSequentialImpulseConstraintSolver;
    dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher
                                                , overlappingPairCache
                                                , solver
                                                , collisionConfiguration);

    dynamicsWorld->setGravity(btVector3(0,-10.0*10.0, 0));
    collide_group = 1;
    collide_mask = 4;
}


QBulletPhysics::~QBulletPhysics()
{
    delete dynamicsWorld;
    delete solver;
    delete overlappingPairCache;
    delete dispatcher;
    delete collisionConfiguration;
}

void QBulletPhysics::addCharacter(QBulletRigidBody *ch)
{

}

void QBulletPhysics::addRigidBody(QBulletRigidBody *rb)
{
    _world_simuation_bodies->insert(rb,rb->body());
    if(rb->simulation())
        dynamicsWorld->addRigidBody(rb->body());
}

void QBulletPhysics::releaseRigidBody(QBulletRigidBody *rb)
{
    _world_simuation_bodies->remove(rb);
    dynamicsWorld->removeCollisionObject(rb->body());
}

void QBulletPhysics::setHumanCharacter(HumanCharacter *h)
{
    human = h;
    dynamicsWorld->addRigidBody(human->body());
}

void QBulletPhysics::addVehicle(QBulletVehicle *v)
{
    dynamicsWorld->addConstraint(v->cons1);
    dynamicsWorld->addConstraint(v->cons2);
}

void QBulletPhysics::addRay(QBulletRay *ray)
{
    switch (ray->mode()) {
    case QBulletRay::Normal:
        rays->push_back(ray);
        break;
    case QBulletRay::Shoot:
        instance_rays->push_back(ray);
        break;
    }
}

void QBulletPhysics::addInstanceRay(QQuick3DNode *f, QQuick3DNode *t)
{
    QBulletRay *qray = new QBulletRay;
    qray->setType(QBulletRay::NodeToNode);
    qray->setSystem(this);
    qray->setMode(QBulletRay::Shoot);
    qray->setFromNode(f);
    qray->setToNode(t);
}

void QBulletPhysics::addInstanceRay(QQuick3DNode *f, double l)
{
    QBulletRay *qray = new QBulletRay;
    qray->setType(QBulletRay::NodeWithLength);
    qray->setSystem(this);
    qray->setMode(QBulletRay::Shoot);
    qray->setFromNode(f);
    qray->setLength(l);
}

void QBulletPhysics::addInstanceRay(QVector3D f, QVector3D t)
{
    QBulletRay *qray = new QBulletRay;
    qray->setType(QBulletRay::TwoPoints);
    qray->setSystem(this);
    qray->setMode(QBulletRay::Shoot);
    qray->setFromPoint(f);
    qray->setToPoint(t);
}

//void QBulletPhysics::addInstanceExpolsion(QVector3D o, double power)
//{
//    btCollisionShape* _collShape = new btSphereShape(1.0);
//    btTransform collTransform;
//    collTransform.setIdentity();
//    collTransform.setOrigin(btVector3(o.x(),o.y()-10,o.z()));
//    btScalar mass(0.0);
//    btVector3 localInertia(1.0, 1.0, 1.0);

//    btDefaultMotionState* myMotionState = new btDefaultMotionState(collTransform);
//    btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, myMotionState, _collShape, localInertia);
//    btRigidBody*  _body = new btRigidBody(rbInfo);
//    _body->setCollisionFlags( _body->getCollisionFlags() |btCollisionObject::CF_STATIC_OBJECT);
//    _explosions->insert(_body,power);
//    dynamicsWorld->addRigidBody(_body);
//}

void QBulletPhysics::addRigidBodytoExplosionList(QBulletRigidBody *_b)
{
    _explosions->insert(_b);
}

void QBulletPhysics::addRigidBodytoReleaseList(QBulletRigidBody *_b)
{
    _bodies_to_release->insert(_b);
}

void QBulletPhysics::collideCallback(btDynamicsWorld *dynamicsWorld,btScalar timeStep)
{
    qDebug() << " collission done ... ";
    collisions.clear( );
    int numManifolds = dynamicsWorld->getDispatcher()->getNumManifolds();
    for (int i = 0; i < numManifolds; i++) {
        btPersistentManifold *contactManifold = dynamicsWorld->getDispatcher()->getManifoldByIndexInternal(i);
        int numContacts = contactManifold->getNumContacts();
        for (int j = 0; j < numContacts; j++) {
            btManifoldPoint& pt = contactManifold->getContactPoint(j);
            const btVector3& ptA = pt.getPositionWorldOnA();
            const btVector3& ptB = pt.getPositionWorldOnB();
            const btVector3& normalOnB = pt.m_normalWorldOnB;
            collisions.push_back(ptA);
            collisions.push_back(ptB);
            collisions.push_back(normalOnB);
        }
    }
}

void QBulletPhysics::updateFrame()
{
    QBulletRigidBody *rb=0;

    if(human != 0) {
        btTransform trans;

        trans.setOrigin(btVector3(human->model()->position().x()
                                  ,human->model()->position().y()
                                  ,human->model()->position().z()));

        trans.setRotation(btQuaternion(human->model()->rotation().x()
                                       ,human->model()->rotation().y()
                                       ,human->model()->rotation().z()
                                       ,human->model()->rotation().scalar()));
        human->body()->setWorldTransform(trans);
    }


    foreach(QBulletRay* qray ,*rays){
        btCollisionWorld::ClosestRayResultCallback  resultCallback(qray->ray()->from,qray->ray()->to);
        dynamicsWorld->rayTest(qray->ray()->from,qray->ray()->to,resultCallback);
        emit qray->pointHitted(QVector3D(resultCallback.m_hitPointWorld.x(),
                                         resultCallback.m_hitPointWorld.y(),
                                         resultCallback.m_hitPointWorld.z()));
    }

    foreach(QBulletRay* qray ,*instance_rays){
        btCollisionWorld::ClosestRayResultCallback  resultCallback(qray->ray()->from,qray->ray()->to);
        dynamicsWorld->rayTest(qray->ray()->from,qray->ray()->to,resultCallback);

        btCollisionObject* ray_hit_obj = ( btCollisionObject* )resultCallback.m_collisionObject;
        btRigidBody* body = btRigidBody::upcast(ray_hit_obj);
        rb = _world_simuation_bodies->key(body);
        if(rb->type() == QBulletRigidBody::DYNAMIC) {
            qDebug() << "object is hitted by ray ";
            btTransform trans;
            body->getMotionState()->getWorldTransform(trans);
            //body->applyCentralForce(trans.getOrigin()*1000);
            dynamicsWorld->removeRigidBody(rb->body());
            _bodies_to_release->insert(rb);
        }
        delete qray;
    }
    instance_rays->clear();


    foreach(QBulletRigidBody *_b ,*_explosions){
        btScalar r = ((btSphereShape*) _b->collShape())->getRadius();
        ((btSphereShape*)  _b->collShape())->setLocalScaling(btVector3(r*2,r*2,r*2));
        if(r>_b->maxPower()) {
            _explosions->remove(_b);
            _bodies_to_release->insert(_b);
        }
    }

    foreach(QBulletRigidBody* drb ,*_bodies_to_release)
        drb->release();
    _bodies_to_release->clear();



    foreach(QBulletRigidBody* drb ,_world_simuation_bodies->keys()){
        if(drb->force() != 0)
            drb->body()->applyCentralImpulse(btVector3(drb->model()->forward().x(),
                                                       drb->model()->forward().y(),
                                                       drb->model()->forward().z()) * drb->force());
        if(drb->type() == QBulletRigidBody::KINEMATIC_COLLISON) {
            btTransform  trans ;
            trans =drb->body()->getWorldTransform();
            trans.setOrigin(btVector3(drb->model()->position().x()
                                      ,drb->model()->position().y()
                                      ,drb->model()->position().z()));
            trans.setRotation(btQuaternion(drb->model()->rotation().x()
                                           ,drb->model()->rotation().y()
                                           ,drb->model()->rotation().z()
                                           ,drb->model()->rotation().scalar()));
            drb->body()->setWorldTransform(trans);
        }
    }

    dynamicsWorld->stepSimulation(1.f / 60.f);
    int num_collision =  dynamicsWorld->getNumCollisionObjects() - 1;
    emit bodiesCountChanged(num_collision);
    for (int j =num_collision; j >= 0; j--)
    {
        btCollisionObject* obj = dynamicsWorld->getCollisionObjectArray()[j];
        btRigidBody* body = btRigidBody::upcast(obj);

        rb = _world_simuation_bodies->key(body);

        btTransform trans;

        if ( body && body->getMotionState() ) {
            body->getMotionState()->getWorldTransform(trans);
        }
        else {
            trans = obj->getWorldTransform();
        }

        if(rb !=0 ){
            rb->model()->setPosition(QVector3D(trans.getOrigin().getX()
                                               ,trans.getOrigin().getY()
                                               ,trans.getOrigin().getZ()));

            rb->model()->setRotation(QQuaternion(trans.getRotation().getW()
                                                 ,trans.getRotation().getX()
                                                 ,trans.getRotation().getY()
                                                 ,trans.getRotation().getZ()));

            if(qFabs(body->getWorldTransform().getOrigin().x()) >1000.0
                    ||qFabs(body->getWorldTransform().getOrigin().y()) > 1000.0
                    ||qFabs(body->getWorldTransform().getOrigin().z()) > 1000.0){
                rb->action();
            }
        }

        if(human != 0){
            if(body == human->body()) {
                trans = human->body()->getWorldTransform();
                human->model()->setPosition(QVector3D(trans.getOrigin().getX()
                                                      ,trans.getOrigin().getY()
                                                      ,trans.getOrigin().getZ()));

                human->model()->setRotation(QQuaternion(trans.getRotation().getW()
                                                        ,trans.getRotation().getX()
                                                        ,trans.getRotation().getY()
                                                        ,trans.getRotation().getZ()));
            }
        }
    }

    CheckForCollisionEvents();
}

void QBulletPhysics::CheckForCollisionEvents() {
    for (int i = 0; i < dispatcher->getNumManifolds(); ++i) {
        btPersistentManifold* pManifold = dispatcher->getManifoldByIndexInternal(i);
        if (pManifold->getNumContacts() > 0) {
            btRigidBody* pBody0 = static_cast<btRigidBody*>(( btCollisionObject*)pManifold->getBody0());
            btRigidBody* pBody1 = static_cast< btRigidBody*>(( btCollisionObject*)pManifold->getBody1());
            QBulletRigidBody *b1 = _world_simuation_bodies->key(pBody0);
            QBulletRigidBody *b2 = _world_simuation_bodies->key(pBody1);
            if(b1 !=0 && b2 !=0) {
                if(b1->collisionActionType() != b2->collisionActionType()) {
                    qDebug() << b1 << b1->type() << b1->collisionActionType() << b1->actionType();
                    qDebug() << b2 << b2->type() << b2->collisionActionType() << b2->actionType();
                    QBulletRigidBody::calculateCollisionPower(b1,b2);
                    b1->action();
                    b2->action();
                }
            }
        }
    }
}

