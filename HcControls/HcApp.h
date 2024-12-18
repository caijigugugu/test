#pragma once


#include <QObject>
#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include <QTranslator>
#include <QQuickWindow>
#include <QJsonArray>
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The HcApp class
 */

class HcApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(bool, useSystemAppBar)
    Q_PROPERTY_AUTO(QString, windowIcon)
    Q_PROPERTY_AUTO(QLocale, locale)
    Q_PROPERTY_AUTO_P(QObject *, launcher)
    QML_NAMED_ELEMENT(HcApp)
    QML_SINGLETON

private:
    explicit HcApp(QObject *parent = nullptr);

    ~HcApp() override;

public:
    SINGLETON(HcApp)

    static HcApp *create(QQmlEngine *, QJSEngine *) {
        return getInstance();
    }

    Q_INVOKABLE void init(QObject *launcher, QLocale locale = QLocale::system());
    Q_INVOKABLE void setLang(QLocale locale = QLocale::system());

    [[maybe_unused]] Q_INVOKABLE static QJsonArray iconData(const QString &keyword = "");

private:
    QQmlEngine *_engine{};
    QTranslator *_translator = nullptr;
};
