#ifndef SERVICE_H
#define SERVICE_H

#include <QObject>
#include <QQmlEngine>

#define ServiceInst Service::instance()
class Service : public QObject
{
    Q_OBJECT

public:
    explicit Service(QObject *parent = nullptr);
    static Service* instance();
    void init();

    Q_INVOKABLE void callApi(const QString &endpoint, const QJsonObject &payload);
    Q_INVOKABLE void callApiWithFile(const QString &endpoint, const QJsonObject &payload);
    Q_INVOKABLE void callApiWithMultipart(const QString &endpoint, const QJsonObject &formData);

    Q_INVOKABLE void callApiWithMultipart(const QString &endpoint, const QString &filePath, int projectId, int transId);
    QString extractFileNameFromDisposition(const QString &contentDisposition);
    Q_INVOKABLE void logApi(const QString &endpoint, const QJsonObject &payload);
    Q_INVOKABLE bool saveFile(const QString &filePath, const QString &data);

    void registerQmlTypes();
signals:
    void apiResponseReceived(const QString &endpoint, const QJsonObject &response);
    void fileDownloaded(const QString &fileName, const QByteArray &fileData);
    void apiFileDataReceived(const QString &endpoint, const QByteArray &fileData);
private:
    static Service* m_Ctrl;
};

#endif // SERVICE_H
