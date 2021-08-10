#include "landshape.h"

#include <QFile>

LandShape::LandShape()
{
    _hit_point = 0;
    QFile *mesh = new QFile("../qtquick3d_plane_pybullet/assets/land.mesh");
    mesh->open(QIODevice::ReadOnly);
    m= QSSGMesh::Mesh::loadMesh(mesh);
    QSSGMeshBVHBuilder builder(m);
    bvh = builder.buildTree();


    //    qDebug() << m.subsets().at(0).bounds.max;
    //    qDebug() << m.subsets().at(0).bounds.min;
    //    qDebug() << m.vertexBuffer().data.size();
    //    qDebug() << m.vertexBuffer().entries.size();
    //    qDebug() << m.vertexBuffer().stride;
    //    qDebug() << (int) m.drawMode();
    //    qDebug() << (int)m.winding();
    //    qDebug() << " ---------------------- ";

    //    qDebug() << bvh->roots.size();
    //    qDebug() << bvh->triangles.size();
    //    qDebug() << " ---------------------- ";

    updateData();
}

void LandShape::setNormals(bool enable)
{
    if (m_hasNormals == enable)
        return;

    m_hasNormals = enable;
    emit normalsChanged();
    updateData();
    update();
}

void LandShape::setNormalXY(float xy)
{
    if (m_normalXY == xy)
        return;

    m_normalXY = xy;
    emit normalXYChanged();
    updateData();
    update();
}

void LandShape::setUV(bool enable)
{
    if (m_hasUV == enable)
        return;

    m_hasUV = enable;
    emit uvChanged();
    updateData();
    update();
}

void LandShape::setUVAdjust(float f)
{
    if (m_uvAdjust == f)
        return;

    m_uvAdjust = f;
    emit uvAdjustChanged();
    updateData();
    update();
}

QQuick3DGeometry* LandShape::hitPointer(QVector3D)
{
    if(_hit_point != 0 )
        delete _hit_point;
    qDebug() << m.vertexBuffer().data.size();

    _hit_point = new QQuick3DGeometry;

    QByteArray v;
    v.resize(3 * 3 * sizeof(float));
    float *p = reinterpret_cast<float *>(v.data());

    // a triangle, front face = counter-clockwise
    *p++ = -0.5f; *p++ = -0.5f; *p++ = 0.0f;
    *p++ = 0.5f; *p++ = -0.5f; *p++ = 0.0f;
    *p++ = 0.0f; *p++ = 0.5f; *p++ = 0.0f;

    _hit_point->setVertexData(v);
    _hit_point->setStride(3 * sizeof(float));

    _hit_point->setPrimitiveType(QQuick3DGeometry::PrimitiveType::Triangles);

    _hit_point->addAttribute(QQuick3DGeometry::Attribute::PositionSemantic,
                 0,
                 QQuick3DGeometry::Attribute::F32Type);
    return _hit_point;

}

void LandShape::updateData()
{
    clear();
    int stride = 8 * sizeof(float);
    QByteArray vertexData(bvh->triangles.size()*3 * stride, Qt::Initialization::Uninitialized);
    float *p = reinterpret_cast<float *>(vertexData.data());
    float minX=INFINITY,minY=INFINITY,minZ=INFINITY;
    float maxX= -INFINITY,maxY=-INFINITY,maxZ=-INFINITY;
    //

    foreach( QSSGMeshBVHTriangle *triangle, bvh->triangles) {
        *p++ = triangle->vertex1.x();
        *p++ = triangle->vertex1.y();
        *p++ = triangle->vertex1.z();

        *p++ = m_normalXY; *p++ = m_normalXY; *p++ = 1.0f;
        *p++ = triangle->uvCoord1.x();
        *p++ = triangle->uvCoord1.y();

        *p++ = triangle->vertex2.x();
        *p++ = triangle->vertex2.y();
        *p++ = triangle->vertex2.z();

        *p++ = m_normalXY; *p++ = m_normalXY; *p++ = 1.0f;
        *p++ = triangle->uvCoord2.x();
        *p++ = triangle->uvCoord2.y();

        *p++ = triangle->vertex3.x();
        *p++ = triangle->vertex3.y();
        *p++ = triangle->vertex3.z();

        *p++ = m_normalXY; *p++ = m_normalXY; *p++ = 1.0f;
        *p++ = triangle->uvCoord3.x();
        *p++ = triangle->uvCoord3.y();


        if(minX > triangle->bounds.minimum.x())
            minX = triangle->bounds.minimum.x();

        if(minY > triangle->bounds.minimum.y())
            minY = triangle->bounds.minimum.y();

        if(minZ > triangle->bounds.minimum.z())
            minZ = triangle->bounds.minimum.z();

        if(maxX < triangle->bounds.maximum.x())
            maxX = triangle->bounds.maximum.x();

        if(maxY < triangle->bounds.maximum.y())
            maxY = triangle->bounds.maximum.y();

        if(maxZ < triangle->bounds.maximum.z())
            maxZ = triangle->bounds.maximum.z();

    }




    addAttribute(QQuick3DGeometry::Attribute::PositionSemantic,
                 0,
                 QQuick3DGeometry::Attribute::F32Type);
    addAttribute(QQuick3DGeometry::Attribute::NormalSemantic,
                 3 * sizeof(float),
                 QQuick3DGeometry::Attribute::F32Type);
    addAttribute(QQuick3DGeometry::Attribute::TexCoordSemantic,
                 m_hasNormals ? 6 * sizeof(float) : 3 * sizeof(float),
                 QQuick3DGeometry::Attribute::F32Type);

    setVertexData(vertexData);
    setStride(stride);

    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Triangles);

    this->setBounds(QVector3D(minX,minY,minZ),QVector3D(maxX,maxY,maxZ));
    //    qDebug() << this->boundsMax() << " :: " << this->boundsMin();

}






















//void LandShape::updateData()
//{
//    clear();
//    int stride = 8 * sizeof(float);
//    //    if (m_hasNormals)
//    //        stride += 3 * sizeof(float);
//    //    if (m_hasUV)
//    //        stride += 2 * sizeof(float);

//    QByteArray vertexData(4 * stride, Qt::Initialization::Uninitialized);
//    float *p = reinterpret_cast<float *>(vertexData.data());
//    union {
//        float f;
//        uchar b[4];
//    } u;

//    for(int i=0 ;i <32;i++) {
//        u.b[0] = m.vertexBuffer().data.at(i*4);
//        u.b[1] = m.vertexBuffer().data.at(i*4+1);
//        u.b[2] = m.vertexBuffer().data.at(i*4+2);
//        u.b[3] = m.vertexBuffer().data.at(i*4+3);
//        *p++ = u.f *1.0f;
////        qDebug() << u.f;
//    }


//    //      *p++ = m.vertexBuffer().data.at(i).t;
//    //    }
//    //    foreach(float v ,verts) {
//    //        *p++ = v;
//    //    }
//    //    // a triangle, front face = counter-clockwise
//    //    *p++ = -1.0f; *p++ = -1.0f; *p++ = 0.0f;
//    ////    if (m_hasNormals) {
//    ////        *p++ = m_normalXY; *p++ = m_normalXY; *p++ = 1.0f;
//    ////    }
//    ////    if (m_hasUV) {
//    ////        *p++ = 0.0f + m_uvAdjust; *p++ = 0.0f + m_uvAdjust;
//    ////    }
//    //    *p++ = 1.0f; *p++ = -1.0f; *p++ = 0.0f;
//    ////    if (m_hasNormals) {
//    ////        *p++ = m_normalXY; *p++ = m_normalXY; *p++ = 1.0f;
//    ////    }
//    ////    if (m_hasUV) {
//    ////        *p++ = 1.0f - m_uvAdjust; *p++ = 0.0f + m_uvAdjust;
//    ////    }
//    //    *p++ = 0.0f; *p++ = 1.0f; *p++ = 0.0f;
//    ////    if (m_hasNormals) {
//    ////        *p++ = m_normalXY; *p++ = m_normalXY; *p++ = 1.0f;
//    ////    }
//    ////    if (m_hasUV) {
//    ////        *p++ = 1.0f - m_uvAdjust; *p++ = 1.0f - m_uvAdjust;
//    ////    }
//    //    *p++ = 0.0f; *p++ = 0.0f; *p++ = 0.00f;
//    //    *p++ = 0.5f; *p++ = 0.5f; *p++ = 0.05f;
//    //    *p++ = 1.0f; *p++ = 0.0f; *p++ = 0.05f;

//    setVertexData(vertexData);
//    setStride(stride);

//    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Triangles);

//    addAttribute(QQuick3DGeometry::Attribute::PositionSemantic,
//                 0,
//                 QQuick3DGeometry::Attribute::F32Type);

//    //    if (m_hasNormals) {
//    addAttribute(QQuick3DGeometry::Attribute::NormalSemantic,
//                 3 * sizeof(float),
//                 QQuick3DGeometry::Attribute::F32Type);
//    //    }

//    //    if (m_hasUV) {
//    addAttribute(QQuick3DGeometry::Attribute::TexCoordSemantic,
//                 m_hasNormals ? 6 * sizeof(float) : 3 * sizeof(float),
//                 QQuick3DGeometry::Attribute::F32Type);
//    //    }
//}
