import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import HcControls
import MyService 1.0

Window {
    id: root
    width: 720
    height: 480
    visible: true
    title: qsTr("Data Conversion Tools")

    property var projectModel: ListModel {}
    property var tranModel: ListModel {}
    property var downloadedData: null
    property string downloadedFileName: ""
    property var fileArray: []

    function reportState(responseState) {
        var dlgmessage
        switch(responseState) {
                case 1:
                    dlgmessage = qsTr("请求参数错误")
                    break;
                case 2:
                    dlgmessage = qsTr("请求参数解析错误")
                    break;
                case 9999:
                    dlgmessage = qsTr("服务器崩溃")
                    break;
                case 10001:
                    dlgmessage = qsTr("无法打开文件")
                    break;
                case 10002:
                    dlgmessage = qsTr("文件格式不正确")
                    break;
                case 10003:
                    dlgmessage = qsTr("无法创建文件")
                    break;
                case 10004:
                    dlgmessage = qsTr("无法写入文件")
                    break;
                case 10005:
                    dlgmessage = qsTr("转换程序不存在")
                    break;
                }
                var dialog = _messageDlg.createObject(root, {message: dlgmessage})
                if (dialog) {
                    dialog.open();
                } else {
                    console.error("Failed to create Dialog");
                }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            dateLabel.text = Qt.formatDate(new Date(), "yyyy/M/d")
            timeLabel.text = Qt.formatTime(new Date(), "HH:mm:ss")
        }
    }
    Rectangle {
        id: control
        anchors.fill: parent

        Rectangle {
            id: topRec
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            height: logo.height + 10
            color: "#00ABBA"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10

                //瀚辰logo
                Image {
                    id: logo
                    Layout.preferredWidth: implicitWidth
                    Layout.preferredHeight: implicitHeight
                    source: "Icons/logo_hcsci.png"
                }

                Item {
                    width: 20
                }

                //分割线
                Rectangle {
                    height: parent.height / 3
                    implicitWidth: 1
                    color: "white"
                    opacity: 1
                }

                Item {
                    width: 20
                }

                //软件名称
                Label {
                    id: softName
                    Layout.preferredWidth: implicitWidth
                    Layout.preferredHeight: implicitHeight
                    y:0
                    text: qsTr("数据转换工具")
                    color: "white"
                    font.bold: true
                    font.pixelSize: 30
                }

                Item {
                    Layout.fillWidth: true
                }

                Item {
                    width: 20
                }

                // 日期组件
                ColumnLayout {
                    spacing: 0

                    Label {
                        id: dateLabel
                        text: Qt.formatDate(new Date(), "yyyy/M/d")
                        color: "white"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Label {
                        id: timeLabel
                        text: Qt.formatTime(new Date(), "HH:mm:ss")
                        color: "white"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
        HcPage {
            id: _content
            anchors {
                top:topRec.bottom
                left: parent.left
                right:parent.right
                bottom: parent.bottom
            }
            ColumnLayout {
                id:container
                width: parent.width
                spacing: 80
                anchors.fill: parent
                Row {
                    height: 68
                    spacing: 80
                    Layout.alignment: Qt.AlignHCenter
                    HcComboBox {
                        id: _machineBox
                        property string _currentText
                        property int _currentId
                        width: 170
                        height: 40
                        focus: true
                        editable: false
                        Layout.alignment: Qt.AlignVCenter
                        model: root.projectModel
                        textRole: "text"
                        Component.onCompleted: {
                            var payload = {};
                            MyService.callApi("/trans/getProjectList", payload);
                        }
                        onCurrentIndexChanged: {
                            downloadedData = null
                            downloadedFileName = ""
                            _currentId = projectModel.get(currentIndex).id
                            _currentText = projectModel.get(currentIndex).text
                            var payload = {projectId: projectModel.get(currentIndex).id};
                            MyService.callApi("/trans/getTranList", payload);
                        }
                    }
                    HcComboBox {
                        id: _typeBox
                        property string _currentText
                        property int _currentId
                        width: 170
                        height: 40
                        focus: true
                        editable: false
                        Layout.alignment: Qt.AlignVCenter
                        model: root.tranModel
                        textRole: "text"
                        Component.onCompleted: {

                        }
                        onCurrentIndexChanged: {
                            downloadedData = null
                            downloadedFileName = ""
                            _currentId = tranModel.get(currentIndex).id
                            _currentText = tranModel.get(currentIndex).text
                        }
                    }
                }
                Row{
                    height: 40
                    spacing: 50
                    Layout.alignment: Qt.AlignHCenter
                    HcButton {
                        id: _importBtn
                        width:80
                        height: 36
                        text: qsTr("导入")
                        onClicked: {
                            loadFileDlg.open()
                        }
                    }
                    // HcText {
                    //     id: _fileName
                    //     text: loadFileDlg.currentFile
                    //     Layout.alignment: Qt.AlignVCenter
                    //     anchors.verticalCenter: _importBtn.verticalCenter
                    // }
                    HcExpander {
                        headerText: qsTr("当前选中文件")
                        contentHeight: 140
                        Item{
                            anchors.fill: parent
                            ListView{
                                id: _listView
                                anchors.fill: parent
                                ScrollBar.vertical: HcScrollBar {}
                                boundsBehavior: ListView.StopAtBounds
                                model: fileArray
                                delegate: HcText{
                                    id:text_info
                                    wrapMode: Text.WrapAnywhere
                                    width: _listView.width
                                    padding: 5
                                    text: modelData
                                }
                            }
                        }
                    }
                }
                Row{
                    height: 40
                    spacing: 50
                    Layout.alignment: Qt.AlignHCenter
                    HcButton {
                        id: _tranBtn
                        width:80
                        height: 36
                        text: qsTr("转换")
                        onClicked: {
                            var filePath = String(loadFileDlg.currentFile).replace("file:///", "");
                            var filePaths = loadFileDlg.currentFiles.map(function(filePath) {
                                return String(filePath).replace("file:///", "");
                            });
                            console.log("filePaths---------------:",filePath,filePaths)
                            var payload = {projectId: _machineBox._currentId,
                                transId: _typeBox._currentId,
                                file: filePath
                            };
                            MyService.callApiWithMultipart("/trans/tranXlsx",payload);
                            // MyService.callApiWithMultipart("/trans/tranXlsx",filePath,
                            //                                _machineBox._currentId,
                            //                                _typeBox._currentId
                            //                                );

                        }
                    }
                    HcText {
                        id: _tranFileName
                        text: downloadedFileName
                        Layout.alignment: Qt.AlignVCenter
                        anchors.verticalCenter: _tranBtn.verticalCenter
                    }
                }
                Row{
                    height: 40
                    spacing: 50
                    Layout.alignment: Qt.AlignHCenter
                    HcButton {
                        id: _saveBtn
                        enabled: downloadedData !== null
                        width:80
                        height: 36
                        text: qsTr("保存")
                        onClicked: {
                            saveFileDlg.open()
                        }
                    }
                }
            }
        }
    }
    FileDialog {
        id: loadFileDlg
        acceptLabel: qsTr("选择文件")
        rejectLabel: qsTr("取消")
        nameFilters: ["All files (*)"]
        fileMode: FileDialog.OpenFiles

        onAccepted: {
            //var file = selectedFiles//loadFileDlg.currentFiles
            // if (file) {
            //     console.log("file---------------:",file)
            // }

            var filePaths = loadFileDlg.currentFiles.map(function(filePath) {
                return String(filePath).replace("file:///", "");
            });
            fileArray = filePaths;
            console.log("file---------------:",filePaths)
        }
    }

    FileDialog {
        id: saveFileDlg
        acceptLabel: qsTr("选择文件")
        rejectLabel: qsTr("取消")
        options: FileDialog.DontConfirmOverwrite
        nameFilters: ["All files (*)"]
        fileMode: FileDialog.SaveFile

        onAccepted: {
            if (downloadedData) {
                if (saveFileDlg.selectedFile) {
                    var dialog
                    var filePath = String(saveFileDlg.selectedFile).replace("file:///", ""); // 转换为本地路径格式
                    var result =  MyService.saveFile(filePath, downloadedData);

                    if(result) {
                        dialog = _messageDlg.createObject(root, {message: qsTr("保存成功")})
                    } else {
                        dialog = _messageDlg.createObject(root, {message: qsTr("保存失败")})
                    }
                    if (dialog) {
                        dialog.open();
                    } else {
                        console.error("Failed to create Dialog");
                    }
                } else {
                    console.log("fileUrl is undefined!");
                }
            } else {
                console.log("downloadedData is null or undefined!");
            }
        }
    }

    Component {
        id: _messageDlg
        HcMessageDlg {
            id: messageDlg
            visible: true
            popupWidth: 400
            title: qsTr("")
            onlyConfirm: true
            showCloseIcon: true
            messageColor: "#333333"
        }
    }

    Connections {
        target: MyService
        function onApiResponseReceived(endpoint, response) {
            if (endpoint === "/trans/getProjectList") {
                if (response.state === 0) {
                    var projectList = response.data.List;
                    root.projectModel.clear();
                    for (var i = 0; i < projectList.length; i++) {
                        root.projectModel.append({ id: projectList[i].id, text: projectList[i].name });
                    }
                    if (projectList.length > 0) {
                        _machineBox.currentIndex = 0;
                    }
                } else {
                    console.error("Failed to fetch data:", response.msg);
                }
            } else if(endpoint === "/trans/getTranList") {
                if (response.state === 0) {
                    var tranList = response.data.List;
                    root.tranModel.clear();
                    for (var j = 0; j < tranList.length; j++) {
                        root.tranModel.append({ id: tranList[j].id, text: tranList[j].name });
                    }
                    if (tranList.length > 0) {
                        _typeBox.currentIndex = 0;
                    }
                } else {
                    console.error("Failed to fetch data:", response.msg);
                }
            }
            if(response.state !== 0) {
                reportState(response.state)
            }
        }
    }

    Connections {
        target: MyService
        function onApiFileDataReceived(fileName, response) {

            let isJson = false;
            let jsonResponse;
            try {
                jsonResponse = JSON.parse(response); // 将返回值转换为 JSON 对象
                isJson = true;
            } catch (e) {
                isJson = false;
            }

            if (isJson) {
                reportState(jsonResponse.state)
            } else {
                downloadedFileName = fileName;
                downloadedData = response;
                saveFileDlg.currentFile = downloadedFileName;
            }
        }
    }

    Component.onCompleted: {
        var payload = {};
        MyService.logApi("/system/getStateDefine", payload);
    }
}