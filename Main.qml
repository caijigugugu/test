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
    //转换后文件数据
    property var downloadedFiles: []
    //导入文件
    property var fileArray: []
    //转换后文件
    property var dataArray: []
    //处理请求次数
    property int requestCount: 0
    //故障信息
    property var errorSummary: ({})

    //记录错误数量和类型
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
        // var dialog = _messageDlg.createObject(root, {message: dlgmessage})
        // if (dialog) {
        //     dialog.open();
        // } else {
        //     console.error("Failed to create Dialog");
        // }
        if (errorSummary[dlgmessage]) {
            errorSummary[dlgmessage]++;
        } else {
            errorSummary[dlgmessage] = 1;
        }
    }
    //展示错误信息
    function displayErrorSummary() {
        if (Object.keys(errorSummary).length > 0) {
            var summaryMessage = qsTr("以下故障发生:\n");
            for (var error in errorSummary) {
                summaryMessage += errorSummary[error] + " " + qsTr("文件故障，故障: ") + error + "\n";
            }

            // 显示错误统计对话框
            var dialog = _messageDlg.createObject(root, {message: summaryMessage});
            if (dialog) {
                dialog.open();
            } else {
                console.error("Failed to create Dialog");
            }
        } else {
            console.log("所有文件处理成功！");
        }
    }

    //处理返回文件名字
    function appendNumberToFileName(fileName, index) {
        // 提取文件名和扩展名
        var lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex !== -1) {
            var namePart = fileName.substring(0, lastDotIndex); // 文件名部分
            var extensionPart = fileName.substring(lastDotIndex); // 扩展名部分
            return namePart + "_" + index + extensionPart; // 添加编号
        } else {
            // 如果没有扩展名，直接在文件名后面添加编号
            return fileName + "_" + index;
        }
    }

    function clearData() {
        fileArray = []
        downloadedFiles = []
        dataArray = []
        requestCount = 0
        errorSummary = {}
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
            Flickable{
                id: flickable
                clip: true
                anchors.fill: parent
                ScrollBar.vertical: HcScrollBar {}
                boundsBehavior: Flickable.StopAtBounds
                contentHeight: container.implicitHeight

            ColumnLayout {
                id:container
                spacing: 30
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
                            clearData()
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
                            clearData()
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
                            dataArray = []
                            downloadedFiles = []
                            requestCount = 0
                            for(var i=0;i < fileArray.length ;i++){
                                var file = fileArray[i]
                                if(file) {
                                    var payload = {projectId: _machineBox._currentId,
                                        transId: _typeBox._currentId,
                                        file: file
                                    };
                                    console.log("转换文件---------------:",file)
                                    MyService.callApiWithMultipart("/trans/tranXlsx",payload);
                                }
                            }
                        }
                    }
                    HcExpander {
                        headerText: qsTr("已转换文件")
                        contentHeight: 140
                        Item{
                            anchors.fill: parent
                            ListView{
                                anchors.fill: parent
                                ScrollBar.vertical: HcScrollBar {}
                                boundsBehavior: ListView.StopAtBounds
                                model: dataArray
                                delegate: HcText{
                                    wrapMode: Text.WrapAnywhere
                                    padding: 5
                                    text: modelData.fileName
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
                        id: _saveBtn
                        width:80
                        height: 36
                        enabled: dataArray.length > 0
                        text: qsTr("保存")
                        onClicked: {
                            saveFileDlg.open()
                        }
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
            var filePaths = loadFileDlg.currentFiles.map(function(filePath) {
                return String(filePath).replace("file:///", "");
            });
            if (filePaths.length > 200) {
                var dialog = _messageDlg.createObject(root, {message: qsTr("选中文件超出上限：200,请重新选择")});
                if (dialog) {
                    dialog.open();
                } else {
                    console.error("Failed to create Dialog");
                }
            } else {
                fileArray = filePaths;
            }
        }
    }
    FolderDialog {
    //FileDialog {
        id: saveFileDlg
        acceptLabel: qsTr("选择文件夹")
        rejectLabel: qsTr("取消")
        options: FileDialog.ShowDirsOnly // 只选择文件夹

        onAccepted: {
            if (saveFileDlg.selectedFolder) {
            var saveDirectory = String(saveFileDlg.selectedFolder).replace("file:///", ""); // 转换为本地路径格式
            console.log("选中的保存文件夹: ", saveDirectory);

            var dialog;
            var allSaved = true;

            // 遍历保存所有文件
            for (var i = 0; i < downloadedFiles.length; i++) {
                var file = downloadedFiles[i];
                var filePath = saveDirectory + "/" + file.fileName; // 构建完整路径

                var result = MyService.saveFile(filePath, file.data);
                if (!result) {
                    console.error("文件保存失败: ", filePath);
                    allSaved = false;
                } else {
                    console.log("文件保存成功: ", filePath);
                }
            }

            // 显示保存结果
            if (allSaved) {
                dialog = _messageDlg.createObject(root, {message: qsTr("所有文件保存成功！")});
            } else {
                dialog = _messageDlg.createObject(root, {message: qsTr("部分文件保存失败！")});
            }

            if (dialog) {
                dialog.open();
            } else {
                console.error("Failed to create Dialog");
            }
        } else {
            console.log("未选择文件夹！");
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
    //项目列表
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
    //返回文件
    Connections {
        target: MyService
        function onApiFileDataReceived(fileName, response) {
            //记录处理了多少个文件，如有故障，处理完后统一弹窗
            requestCount++

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
                //文件名称都一样需要处理
                var processedFileName = appendNumberToFileName(fileName, requestCount);

                downloadedFiles.push({
                    fileName: processedFileName,
                    data: response
                });
                dataArray = downloadedFiles
                console.log("文件名-----------:",processedFileName);
            }
            if (requestCount === fileArray.length) {
                displayErrorSummary()
            }
        }
    }

    Component.onCompleted: {
        var payload = {};
        MyService.logApi("/system/getStateDefine", payload);
    }
}
