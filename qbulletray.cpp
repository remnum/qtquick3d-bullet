#include "qbulletray.h"

QBulletRay::QBulletRay(QObject *parent) : QObject(parent)
{
    _system = 0;
    _from_node = 0;
    _to_node =0;
    _length = 0;
    _from_point = QVector3D(0.0 , 0.0 , 0.0);
    _to_point = QVector3D(0.0 , 0.0 , 0.0);
    _ray = new QRay;
    _init_count = 0;
    _check_count = 10;
    connect(this,&QBulletRay::startInit,this,&QBulletRay::init);
}

QBulletPhysics *QBulletRay::system()
{
    return _system;
}

void QBulletRay::setSystem(QBulletPhysics *s)
{
    _system = s;
    connect(this,&QBulletRay::finished,_system,&QBulletPhysics::addRay);
    _init_count++;
    emit startInit();
}

QBulletRay::TYPE QBulletRay::type()
{
    return _type;
}

void QBulletRay::setType(TYPE t)
{
    _type = t;
    switch (_type) {
    case NodeToNode:
        _check_count = 5;

        break;

    case NodeWithLength:
        _check_count = 5;

        break;
    case TwoPoints:
        _check_count = 5;

        break;
    }
    _init_count++;
    emit startInit();
}

QBulletRay::MODE QBulletRay::mode()
{
    return _mode;
}

void QBulletRay::setMode(MODE m)
{
    _mode = m;
    _init_count++;
    emit startInit();
}

QQuick3DNode *QBulletRay::fromNode()
{
    return _from_node;
}

void QBulletRay::setFromNode(QQuick3DNode *n)
{
    // _from = qobject_cast<QQuick3DNode*>(n);
    _from_node = n;
    _init_count++;
    emit startInit();
}

QQuick3DNode *QBulletRay::toNode()
{
    return _to_node;

}

void QBulletRay::setToNode(QQuick3DNode *n)
{
    _to_node = n;
    _init_count++;
    emit startInit();
}

double QBulletRay::length()
{
    return _length;
}

void QBulletRay::setLength(double l)
{
    _length = l;
    _init_count++;
    emit startInit();
}

QVector3D QBulletRay::fromPoint()
{
    return _from_point;
}

void QBulletRay::setFromPoint(QVector3D p)
{
    _from_point = p;
}

QVector3D QBulletRay::toPoint()
{
    return _to_point;
}

void QBulletRay::setToPoint(QVector3D p)
{
    _to_point = p;
}

QRay *QBulletRay::ray()
{
    switch (_type) {
    case NodeToNode:
        _ray->from = btVector3(_from_node->position().x(),
                               _from_node->position().y(),
                               _from_node->position().z());
        _ray->to = btVector3(_to_node->position().x(),
                             _to_node->position().y(),
                             _to_node->position().z());
        break;

    case NodeWithLength:
        _ray->from = btVector3(_from_node->position().x(),
                               _from_node->position().y(),
                               _from_node->position().z());
        _ray->to = btVector3(_from_node->position().x() + _from_node->forward().x() * _length,
                             _from_node->position().y() + _from_node->forward().y() * _length,
                             _from_node->position().z() + _from_node->forward().z() * _length);
        break;
    case TwoPoints:
        _ray->from  = btVector3(_from_point.x(), _from_point.y(), _from_point.z());
        _ray->to = btVector3(_to_point.x(), _to_point.y(), _to_point.z());
        break;
    }
    return _ray;
}

void QBulletRay::init()
{
    if(_init_count != _check_count)
        return;
    emit finished(this);
}
