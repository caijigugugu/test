import QtQuick
//import QtQuick.Dialogs
import QtQuick.Controls

Dialog {
    property string message: ""
    property bool onlyConfirm: false

    id: cusDialog
    closePolicy: Popup.NoAutoClose
    modal: true
    anchors.centerIn: parent

    background: Rectangle {
        opacity: 0
    }

    contentItem: Rectangle {
        id: background
        radius: 6
        color: Constants.bodyBackground
        border.width: 1
        border.color: Constants.backBorder

        // 仅定义头部矩形框
        Rectangle {
            id: _header
            width: parent.width
            height: 50
            color: "#a1e9ee"
            border.width: 1
            border.color: "#b7d4d4"
            radius: parent.radius
            anchors.top: parent.Top

            Canvas {
                anchors.fill: parent
                onPaint: {
                    // 如果存在圆角，则将下半部的圆角填充为矩形
                    if (parent.radius !== 0) {
                        var ctx = getContext("2d")

                        ctx.fillStyle = "#a1e9ee"
                        ctx.clearRect(1, parent.radius + 1, parent.width - 2, parent.height - parent.radius - 1)
                        ctx.fillRect(1, parent.radius + 1, parent.width - 2, parent.height - parent.radius - 1)
                    }
                }
            }

            Label {
                width: parent.width - 2
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 1
                text: qsTr("提示")
                color: "#484848"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                padding: 6
            }
        }

        Column {
//            anchors.fill: parent
            width: parent.width
            height: parent.height - _header.height
            anchors.top: _header.bottom
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: warningText
                width: parent.width - 60
                height: parent.height* 2 / 3
                text: message
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
                color: Constants.fontGreyColor
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: row
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 200
                height: parent.height / 3

                HcButton {
                    id: confirmBtn
                    width: 100
                    height: 40
                    text: qsTr("确认")
                    font.pixelSize: 14
                    onClicked: cusDialog.accept()
                }

                HcButton {
                    id: cancelBtn
                    width: 100
                    height: 40
                    visible: onlyConfirm ? false : true
                    text: qsTr("取消")
                    font.pixelSize: 14
                    onClicked: cusDialog.rejected()
                }
            }
        }
    }
}
