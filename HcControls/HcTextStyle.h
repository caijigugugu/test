#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include <QFont>
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The HcTextStyle class
 */
class HcTextStyle : public QObject {
    Q_OBJECT

public:
    Q_PROPERTY_AUTO(QString, family)
    Q_PROPERTY_AUTO(QFont, Caption)
    Q_PROPERTY_AUTO(QFont, Body)
    Q_PROPERTY_AUTO(QFont, BodyStrong)
    Q_PROPERTY_AUTO(QFont, Subtitle)
    Q_PROPERTY_AUTO(QFont, Title)
    Q_PROPERTY_AUTO(QFont, TitleLarge)
    Q_PROPERTY_AUTO(QFont, Display)
    QML_NAMED_ELEMENT(HcTextStyle)
    QML_SINGLETON

private:
    explicit HcTextStyle(QObject *parent = nullptr);

public:
    SINGLETON(HcTextStyle)

    static HcTextStyle *create(QQmlEngine *, QJSEngine *) {
        return getInstance();
    }
};
