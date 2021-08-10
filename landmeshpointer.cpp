#include "landmeshpointer.h"

LandMeshPointer::LandMeshPointer()
{
    updateData();
}

void LandMeshPointer::setNormals(bool enable)
{
    if (m_hasNormals == enable)
        return;

    m_hasNormals = enable;
    emit normalsChanged();
    updateData();
    update();
}

void LandMeshPointer::setNormalXY(float xy)
{
    if (m_normalXY == xy)
        return;

    m_normalXY = xy;
    emit normalXYChanged();
    updateData();
    update();
}

void LandMeshPointer::setUV(bool enable)
{
    if (m_hasUV == enable)
        return;

    m_hasUV = enable;
    emit uvChanged();
    updateData();
    update();
}

void LandMeshPointer::setUVAdjust(float f)
{
    if (m_uvAdjust == f)
        return;

    m_uvAdjust = f;
    emit uvAdjustChanged();
    updateData();
    update();
}

void LandMeshPointer::setUpdate()
{
    updateData();
    update();
}

void LandMeshPointer::updateData()
{
    QByteArray v;
       v.resize(3 * 3 * sizeof(float));
       float *p = reinterpret_cast<float *>(v.data());

       // a triangle, front face = counter-clockwise
       *p++ = -1.0f; *p++ = -1.0f*count; *p++ = 0.0f;
       *p++ = 1.0f; *p++ = -1.0f; *p++ = 0.0f;
       *p++ = 0.0f; *p++ = 1.0f; *p++ = 0.0f;
       count++;
       setVertexData(v);
       setStride(3 * sizeof(float));

       setPrimitiveType(QQuick3DGeometry::PrimitiveType::Triangles);

       addAttribute(QQuick3DGeometry::Attribute::PositionSemantic,
                    0,
                    QQuick3DGeometry::Attribute::F32Type);
}

