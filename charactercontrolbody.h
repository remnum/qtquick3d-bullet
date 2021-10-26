#ifndef CHARACTERCONTROLBODY_H
#define CHARACTERCONTROLBODY_H

#include <QObject>
#include "qbulletrigidbody.h"

class CharacterControlBody : public QBulletRigidBody
{
    Q_OBJECT
public:
    explicit CharacterControlBody(QObject *parent = nullptr);

public slots:
    void forward();
    void back();
    void stop();
    void rotate(double val);
};

#endif // CHARACTERCONTROLBODY_H
