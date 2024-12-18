#include "HcApp.h"

#include <QGuiApplication>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QDir>
#include <QFontDatabase>
#include <QClipboard>
#include <QTranslator>
#include <utility>
#include "HcIconDef.h"

HcApp::HcApp(QObject *parent) : QObject{parent} {
    _useSystemAppBar = false;
}

HcApp::~HcApp() = default;

void HcApp::init(QObject *launcher, QLocale locale) {
    this->launcher(launcher);
    _locale = std::move(locale);
    _engine = qmlEngine(launcher);
    _translator = new QTranslator(this);
    QGuiApplication::installTranslator(_translator);
    const QStringList uiLanguages = _locale.uiLanguages();

    for (const QString &name : uiLanguages) {
        const QString baseName = "hc_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/HcControls/i18n/" + baseName)) {
            _engine->retranslate();
            break;
        }
    }
}

void HcApp::setLang(QLocale locale)
{
    if (nullptr != _translator)
    {
        QGuiApplication::removeTranslator(_translator);
        delete _translator;
    }
    _locale = std::move(locale);
    _translator = new QTranslator(this);
    QGuiApplication::installTranslator(_translator);
    const QStringList uiLanguages = _locale.uiLanguages();
    for (const QString &name : uiLanguages) {
        const QString baseName = "hc_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/HcControls/i18n/" + baseName)) {
            _engine->retranslate();
            break;
        }
    }
}

[[maybe_unused]] QJsonArray HcApp::iconData(const QString &keyword) {
    QJsonArray arr;
    QMetaEnum enumType = HcIcons::staticMetaObject.enumerator(
        HcIcons::staticMetaObject.indexOfEnumerator("Type"));
    for (int i = 0; i <= enumType.keyCount() - 1; ++i) {
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if (keyword.isEmpty() || name.contains(keyword)) {
            QJsonObject obj;
            obj.insert("name", name);
            obj.insert("icon", icon);
            arr.append(obj);
        }
    }
    return arr;
}
