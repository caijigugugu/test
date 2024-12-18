#include "service.h"
#include <iostream>
#include <QtConcurrent>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QHttpMultiPart>
#include <QHttpPart>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QVariant>
#include "../hc_trans.h"

Service* Service::m_Ctrl = nullptr;


Service::Service(QObject *parent): QObject(parent)
{
    init();
}

Service *Service::instance()
{
    if(!m_Ctrl)
    {
        m_Ctrl = new Service();
    }

    return m_Ctrl;
}

void Service::init()
{
    QtConcurrent::run([]() {
        std::cout << StartServer(8646) << std::endl;
    });
}

void Service::registerQmlTypes()
{
    qmlRegisterSingletonInstance<Service>("MyService", 1, 0, "MyService", Service::instance());
}

void Service::logApi(const QString &endpoint, const QJsonObject &payload) {
    // 使用 QtConcurrent::run 开启一个线程来运行网络请求
    QtConcurrent::run([this, endpoint, payload]() {
        QNetworkAccessManager manager;

        QUrl url(QString("http://127.0.0.1:8646") + endpoint);
        QNetworkRequest request(url);

        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        QJsonDocument doc(payload);

        QNetworkReply *reply = manager.post(request, doc.toJson());

        // 使用事件循环等待请求完成，不阻塞主线程
        QEventLoop loop;
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();

        // 处理结果
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray response = reply->readAll();
            QString decodedResponse = QString::fromUtf8(response);
            qDebug() << "API Response:" << decodedResponse;
        } else {
            qDebug() << "API Error:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void Service::callApi(const QString &endpoint, const QJsonObject &payload) {
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    QUrl url(QString("http://127.0.0.1:8646") + endpoint);
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonDocument doc(payload);

    QNetworkReply *reply = manager->post(request, doc.toJson());
    connect(reply, &QNetworkReply::finished, this, [this, endpoint, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray response = reply->readAll();
            QJsonDocument jsonDoc = QJsonDocument::fromJson(response);

            if (!jsonDoc.isNull() && jsonDoc.isObject()) {
                QJsonObject responseObject = jsonDoc.object();
                emit apiResponseReceived(endpoint, responseObject);  // 发出信号并传递 endpoint
            } else {
                qDebug() << "Invalid JSON response.";
            }
        } else {
            qDebug() << "API Error:" << reply->errorString();
        }

        reply->deleteLater();
    });
}

// 提取 Content-Disposition 中的文件名
QString Service::extractFileNameFromDisposition(const QString &contentDisposition) {
    // 使用正则表达式匹配文件名
    QRegularExpression regex(R"(filename=([^;]+))");
    QRegularExpressionMatch match = regex.match(contentDisposition);
    if (match.hasMatch()) {
        QString fileName = match.captured(1).trimmed();

        // 去掉引号（如果有）
        if (fileName.startsWith('"') && fileName.endsWith('"')) {
            fileName = fileName.mid(1, fileName.length() - 2);
        }
        return fileName;
    }
    return QString();
}

void Service::callApiWithFile(const QString &endpoint, const QJsonObject &payload) {
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    QUrl url(QString("http://127.0.0.1:8646") + endpoint);
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/octet-stream");

    // 解析传入的 payload 对象
    QString filePath = payload["file"].toString();  // 获取文件路径
    QString projectId = payload["projectId"].toString();  // 获取 projectId
    QString transId = payload["transId"].toString();  // 获取 transId

    // 创建一个multipart表单数据
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    // 添加普通字段 (projectId 和 transId)
    QHttpPart projectPart;
    projectPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                          QVariant("form-data; name=\"projectId\""));
    projectPart.setBody(projectId.toUtf8());

    QHttpPart transPart;
    transPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                        QVariant("form-data; name=\"transId\""));
    transPart.setBody(transId.toUtf8());

    multiPart->append(projectPart);
    multiPart->append(transPart);

    // 添加文件
    QFile *file = new QFile(filePath);
    if (!file->open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file:" << filePath;
        delete file;
        delete multiPart;
        return;
    }

    QHttpPart filePart;
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                       QVariant("form-data; name=\"file\"; filename=\"" + file->fileName() + "\""));
    filePart.setBodyDevice(file);
    multiPart->append(filePart);

    // 发送 POST 请求
    QNetworkReply *reply = manager->post(request, multiPart);
    file->setParent(reply);  // 确保文件随 reply 一起销毁
    multiPart->setParent(reply);  // 确保 multipart 随 reply 一起销毁

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();

            // 获取文件名
            QString contentDisposition = reply->rawHeader("Content-Disposition");
            QString fileName = extractFileNameFromDisposition(contentDisposition);
            if (fileName.isEmpty()) {
                fileName = "downloaded_file.txt";
            }

            // 发出信号，将数据传递到前端
            emit fileDownloaded(fileName, responseData);
        } else {
            qWarning() << "API Error:" << reply->errorString();
        }

        reply->deleteLater();
    });
}

void Service::callApiWithMultipart(const QString &endpoint, const QString &filePath, int projectId, int transId) {
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    QUrl url(QString("http://127.0.0.1:8646") + endpoint);
    QNetworkRequest request(url);

    request.setRawHeader("accept", "application/octet-stream");

    // 构建 multipart 数据
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    // 添加 projectId 字段
    QHttpPart projectIdPart;
    projectIdPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"projectId\""));
    projectIdPart.setBody(QString::number(projectId).toUtf8());
    multiPart->append(projectIdPart);

    // 添加 transId 字段
    QHttpPart transIdPart;
    transIdPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"transId\""));
    transIdPart.setBody(QString::number(transId).toUtf8());
    multiPart->append(transIdPart);

    // 添加文件字段
    QFile *file = new QFile(filePath);
    if (!file->open(QIODevice::ReadOnly)) {
        qDebug() << "Failed to open file:" << filePath;
        delete file;
        delete multiPart;
        return;
    }

    QHttpPart filePart;
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"file\"; filename=\"" + QFileInfo(filePath).fileName() + "\""));
    filePart.setHeader(QNetworkRequest::ContentTypeHeader, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    filePart.setBodyDevice(file);
    file->setParent(multiPart);

    multiPart->append(filePart);

    // 发起 POST 请求
    QNetworkReply *reply = manager->post(request, multiPart);
    multiPart->setParent(reply);

    // 处理返回
    connect(reply, &QNetworkReply::finished, this, [this, endpoint, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            // 获取响应头部信息
            // QVariantMap responseHeaders;
            // const auto headerList = reply->rawHeaderList();
            // for (const QByteArray &header : headerList) {
            //     responseHeaders.insert(QString::fromUtf8(header), QString::fromUtf8(reply->rawHeader(header)));
            // }
            // 提取 Content-Disposition 的值
            QString contentDisposition = reply->rawHeader("Content-Disposition");
            QString filename;
            int filenameIndex = contentDisposition.indexOf("filename=");
            if (filenameIndex != -1) {
                filename = contentDisposition.mid(filenameIndex + 9).trimmed(); // 跳过 "filename="
                if (filename.startsWith('"') && filename.endsWith('"')) {
                    filename = filename.mid(1, filename.length() - 2); // 去掉引号
                }
            }

            // 发出信号，将响应数据和头部文件信息发送给前端
            emit apiFileDataReceived(filename, responseData);

            // 调试输出
            qDebug() << "Response Data:" << responseData;
            qDebug() << "Response Headers:" << filename;
        } else {
            qDebug() << "API Error:" << reply->errorString();
        }

        reply->deleteLater();
    });
}

void Service::callApiWithMultipart(const QString &endpoint, const QJsonObject &formData) {
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    // 创建请求
    QUrl url(QString("http://127.0.0.1:8646") + endpoint);
    QNetworkRequest request(url);
    request.setRawHeader("accept", "application/octet-stream");

    // 构建 multipart 数据
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    // 遍历 JSON 数据
    for (auto it = formData.begin(); it != formData.end(); ++it) {
        const QString fieldName = it.key();
        const QVariant fieldValue = it.value().toVariant();

        // 如果是字符串类型，且值可能是文件路径
        if (fieldValue.type() == QVariant::String) {
            QString value = fieldValue.toString();

            // 检查是否是文件路径（您可以更改为更可靠的检测逻辑）
            QFileInfo fileInfo(value);
            if (fileInfo.exists() && fileInfo.isFile()) {
                // 作为文件字段处理
                QFile *file = new QFile(value);
                if (!file->open(QIODevice::ReadOnly)) {
                    qDebug() << "Failed to open file:" << value;
                    delete file;
                    continue; // 跳过当前文件
                }

                QHttpPart filePart;
                filePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                                   QVariant(QString("form-data; name=\"%1\"; filename=\"%2\"")
                                                .arg(fieldName)
                                                .arg(fileInfo.fileName())));
                filePart.setHeader(QNetworkRequest::ContentTypeHeader, "application/octet-stream");
                filePart.setBodyDevice(file);
                file->setParent(multiPart); // 防止内存泄漏
                multiPart->append(filePart);
            } else {
                // 作为普通字段处理
                QHttpPart textPart;
                textPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                                   QVariant(QString("form-data; name=\"%1\"").arg(fieldName)));
                textPart.setBody(value.toUtf8());
                multiPart->append(textPart);
            }
        } else {
            // 其他数据类型直接转为字符串处理
            QHttpPart textPart;
            textPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                               QVariant(QString("form-data; name=\"%1\"").arg(fieldName)));
            textPart.setBody(fieldValue.toString().toUtf8());
            multiPart->append(textPart);
        }
    }

    // 发起 POST 请求
    QNetworkReply *reply = manager->post(request, multiPart);
    multiPart->setParent(reply);

    // 处理返回
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            QString contentDisposition = reply->rawHeader("Content-Disposition");
            QString filename;
            int filenameIndex = contentDisposition.indexOf("filename=");
            if (filenameIndex != -1) {
                filename = contentDisposition.mid(filenameIndex + 9).trimmed();
                if (filename.startsWith('"') && filename.endsWith('"')) {
                    filename = filename.mid(1, filename.length() - 2);
                }
            }
            emit apiFileDataReceived(filename, responseData);
            qDebug() << "Response Data:" << responseData;
        } else {
            qDebug() << "API Error:" << reply->errorString();
        }
        reply->deleteLater();
    });
}


bool Service::saveFile(const QString &filePath, const QString &data) {
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "无法打开文件:" << filePath;
        return false;
    }
    QTextStream stream(&file);
    stream << data;
    file.close();
    qDebug() << "文件保存成功:" << filePath;
    return true;
}
