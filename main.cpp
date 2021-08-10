#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick3D/qquick3d.h>
#include <qbulletphysics.h>
#include <landshape.h>
#include <qbulletrigidbody.h>
#include <qbulletray.h>
#include <humancharacter.h>
#include <qbulletvehicle.h>

#include <landmeshpointer.h>

int main(int argc, char *argv[])
{
 //   QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QSurfaceFormat::setDefaultFormat(QQuick3D::idealSurfaceFormat());

    qmlRegisterType<LandMeshPointer>("LandMeshPointer", 1, 0, "LandMeshPointer");
    qmlRegisterType<LandShape>("LandShape", 1, 0, "LandShape");
    qmlRegisterType<QBulletPhysics>("QBulletPhysics", 1, 0, "QBulletPhysics");
    qmlRegisterType<QBulletRigidBody>("QBulletRigidBody", 1, 0, "QBulletRigidBody");
    qmlRegisterType<QBulletVehicle>("QBulletVehicle", 1, 0, "QBulletVehicle");
    qmlRegisterType<QBulletRay>("QBulletRay", 1, 0, "QBulletRay");
    qmlRegisterType<HumanCharacter>("HumanCharacter", 1, 0, "HumanCharacter");

//    qmlRegisterUncreatableType<BODY_TYPE>("QBulletPhysics.types", 1, 0, "BODY_TYPE", "Not creatable as it is an enum type");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
