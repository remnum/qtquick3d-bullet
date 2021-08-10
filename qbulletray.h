#ifndef QBULLETRAY_H
#define QBULLETRAY_H

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

namespace aligned_storage { class type; }
class QBulletPhysics;

struct QRay {
    btVector3 from;
    btVector3 to;
};

class QBulletRay : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QBulletPhysics* system READ system WRITE setSystem)
    Q_PROPERTY(TYPE type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(MODE mode READ mode WRITE setMode NOTIFY modeChanged)

    Q_PROPERTY(QQuick3DNode* fromNode READ fromNode WRITE setFromNode NOTIFY fromNodeChanged)
    Q_PROPERTY(QQuick3DNode* toNode READ toNode WRITE setToNode NOTIFY toNodeChanged)

    Q_PROPERTY(double length READ length WRITE setLength NOTIFY lengthChanged)

    Q_PROPERTY(QVector3D fromPoint READ fromPoint WRITE setFromPoint NOTIFY fromPointChanged)
    Q_PROPERTY(QVector3D toPoint READ toPoint WRITE setToPoint NOTIFY toPointChanged)

    QML_NAMED_ELEMENT(QBulletRay)
    QML_ELEMENT

public:
    enum TYPE{
        NodeToNode,
        NodeWithLength,
        TwoPoints
    };
    Q_ENUM(TYPE)

    enum MODE{
        Normal,
        Shoot
    };
    Q_ENUM(MODE)

public:
    explicit QBulletRay(QObject *parent = nullptr);

public slots:
    QBulletPhysics *system();
    void setSystem(QBulletPhysics*);

    TYPE type();
    void setType(TYPE);

    MODE mode();
    void setMode(MODE);

    QQuick3DNode *fromNode();
    void setFromNode(QQuick3DNode*);

    QQuick3DNode *toNode();
    void setToNode(QQuick3DNode*);

    double length();
    void setLength(double);

    QVector3D fromPoint();
    void setFromPoint(QVector3D);

    QVector3D toPoint();
    void setToPoint(QVector3D);

    QRay *ray();

signals:
    void fromNodeChanged();
    void toNodeChanged();
    void lengthChanged();
    void typeChanged();
    void modeChanged();
    void fromPointChanged();
    void toPointChanged();

    void startInit();
    void finished(QBulletRay*);

    void pointHitted(QVector3D);

private:
    void init();

private:
    QBulletPhysics *_system;
    TYPE _type;
    MODE _mode;
    QQuick3DNode *_from_node;
    QQuick3DNode *_to_node;
    QVector3D _from_point;
    QVector3D _to_point;    
    double _length;
    QRay* _ray;

    int _check_count;
    int _init_count;
};

#endif // QBULLETRAY_H
