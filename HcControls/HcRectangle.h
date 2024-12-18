#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"
/**
 * @brief The HcRectangle class
 */
class HcRectangle : public QQuickPaintedItem {
    Q_OBJECT
    Q_PROPERTY_AUTO(QColor, color)
    Q_PROPERTY_AUTO(QGradient, gradient)
    Q_PROPERTY_AUTO(QList<int>, radius)
    QML_NAMED_ELEMENT(HcRectangle)
public:
    explicit HcRectangle(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;
};
