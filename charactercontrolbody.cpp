#include "charactercontrolbody.h"

CharacterControlBody::CharacterControlBody(QObject *parent)
    : QBulletRigidBody(parent)
{

}

void CharacterControlBody::forward()
{
    body()->setLinearVelocity(btVector3(1.0,1.0,1.0)*
                              btVector3(model()->forward().x()*model()->position().x()
                                        ,model()->forward().y()*model()->position().y()
                                        ,model()->forward().z()*model()->position().z()));
}

void CharacterControlBody::back()
{
    body()->setLinearVelocity(btVector3(-1.0,-1.0,-1.0)*
                              btVector3(model()->forward().x()*model()->position().x()
                                        ,model()->forward().y()*model()->position().y()
                                        ,model()->forward().z()*model()->position().z()));
}

void CharacterControlBody::stop()
{
    body()->setLinearVelocity(btVector3(0.0,0.0,0.0));
    body()->setAngularVelocity(btVector3(0.0,0.0,0.0));

}

void CharacterControlBody::rotate(double val)
{
    if(val>0)
        body()->setAngularVelocity(btVector3(0.0,5.0,0.0));
    else
        body()->setAngularVelocity(btVector3(0.0,-5.0,0.0));
}
