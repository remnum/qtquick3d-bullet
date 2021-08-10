#ifndef LANDMESHPOINTER_H
#define LANDMESHPOINTER_H

#include <QQuick3DGeometry>
#include <QObject>

class LandMeshPointer : public QQuick3DGeometry
{
    Q_OBJECT
    Q_PROPERTY(bool normals READ normals WRITE setNormals NOTIFY normalsChanged)
    Q_PROPERTY(float normalXY READ normalXY WRITE setNormalXY NOTIFY normalXYChanged)
    Q_PROPERTY(bool uv READ uv WRITE setUV NOTIFY uvChanged)
    Q_PROPERTY(float uvAdjust READ uvAdjust WRITE setUVAdjust NOTIFY uvAdjustChanged)


public:
    LandMeshPointer();

    bool normals() const { return m_hasNormals; }
    void setNormals(bool enable);

    float normalXY() const { return m_normalXY; }
    void setNormalXY(float xy);

    bool uv() const { return m_hasUV; }
    void setUV(bool enable);

    float uvAdjust() const { return m_uvAdjust; }
    void setUVAdjust(float f);

public slots:
    void setUpdate();

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

    float count=0;

};

#endif // LANDMESHPOINTER_H
