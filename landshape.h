#ifndef LANDSHAPE_H
#define LANDSHAPE_H

#include <QQuick3DGeometry>
#include <QtQuick3DUtils/private/qssgmesh_p.h>
#include <QtQuick3DUtils/private/qssgmeshbvhbuilder_p.h>


class LandShape : public QQuick3DGeometry
{
    Q_OBJECT
    QML_NAMED_ELEMENT(LandShapeGeometry)
    Q_PROPERTY(bool normals READ normals WRITE setNormals NOTIFY normalsChanged)
    Q_PROPERTY(float normalXY READ normalXY WRITE setNormalXY NOTIFY normalXYChanged)
    Q_PROPERTY(bool uv READ uv WRITE setUV NOTIFY uvChanged)
    Q_PROPERTY(float uvAdjust READ uvAdjust WRITE setUVAdjust NOTIFY uvAdjustChanged)

public:
    LandShape();

    bool normals() const { return m_hasNormals; }
    void setNormals(bool enable);

    float normalXY() const { return m_normalXY; }
    void setNormalXY(float xy);

    bool uv() const { return m_hasUV; }
    void setUV(bool enable);

    float uvAdjust() const { return m_uvAdjust; }
    void setUVAdjust(float f);

public slots:
    QQuick3DGeometry* hitPointer(QVector3D);

signals:
    void normalsChanged();
    void normalXYChanged();
    void uvChanged();
    void uvAdjustChanged();

private:
    void updateData();

    bool m_hasNormals = false;
    float m_normalXY = 0.0f;
    bool m_hasUV = false;
    float m_uvAdjust = 0.0f;

//    QList<float> verts;
    QSSGMesh::Mesh m;
    QSSGMeshBVH*  bvh;
    QQuick3DGeometry* _hit_point;

};

#endif // LANDSHAPE_H
