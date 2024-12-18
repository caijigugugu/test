#pragma once

#include <QObject>
#include <QtQml/qqml.h>

#include "HcAccentColor.h"
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The HcColors class
 */
class HcColors : public QObject {
    Q_OBJECT

    Q_PROPERTY_AUTO(QColor, Transparent)
    Q_PROPERTY_AUTO(QColor, Black)
    Q_PROPERTY_AUTO(QColor, White)
    Q_PROPERTY_AUTO(QColor, Grey10)
    Q_PROPERTY_AUTO(QColor, Grey20)
    Q_PROPERTY_AUTO(QColor, Grey30)
    Q_PROPERTY_AUTO(QColor, Grey40)
    Q_PROPERTY_AUTO(QColor, Grey50)
    Q_PROPERTY_AUTO(QColor, Grey60)
    Q_PROPERTY_AUTO(QColor, Grey70)
    Q_PROPERTY_AUTO(QColor, Grey80)
    Q_PROPERTY_AUTO(QColor, Grey90)
    Q_PROPERTY_AUTO(QColor, Grey100)
    Q_PROPERTY_AUTO(QColor, Grey110)
    Q_PROPERTY_AUTO(QColor, Grey120)
    Q_PROPERTY_AUTO(QColor, Grey130)
    Q_PROPERTY_AUTO(QColor, Grey140)
    Q_PROPERTY_AUTO(QColor, Grey150)
    Q_PROPERTY_AUTO(QColor, Grey160)
    Q_PROPERTY_AUTO(QColor, Grey170)
    Q_PROPERTY_AUTO(QColor, Grey180)
    Q_PROPERTY_AUTO(QColor, Grey190)
    Q_PROPERTY_AUTO(QColor, Grey200)
    Q_PROPERTY_AUTO(QColor, Grey210)
    Q_PROPERTY_AUTO(QColor, Grey220)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Yellow)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Orange)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Red)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Magenta)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Purple)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Blue)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Teal)
    Q_PROPERTY_AUTO_P(HcAccentColor *, Green)
    QML_NAMED_ELEMENT(HcColors)
    QML_SINGLETON

private:
    explicit HcColors(QObject *parent = nullptr);

public:
    SINGLETON(HcColors)

    [[maybe_unused]] Q_INVOKABLE HcAccentColor *createAccentColor(const QColor &primaryColor);

    static HcColors *create(QQmlEngine *, QJSEngine *) {
        return getInstance();
    }
};
