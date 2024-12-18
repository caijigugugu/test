import QtQuick 2.15
import QtQuick.Controls 2.15
import HcControls

Item {
    property int popupWidth: 500
    property int popupHeight: 480
    property Component buttonComponent
    property int level: Constants.FaultLevel.Error  //故障级别
    property string summary: ""  //故障信息
    property string detail: ""  //详细信息
    property string solution: ""  //处理方法

    property int buttonFlags: Constants.AlarmHandleOption.Handle_None
    property int _radius: 5
    property int borderWidth: 1
    property int headerHeight: 44
    property string noneText: qsTr("确认")
    property string skipText: qsTr("跳过")
    property string retryText: qsTr("重试")
    property string stopText: qsTr("停止")

    property string uuid: ""
    property string extraParams: ""

    property var titleOptions: [qsTr("提示"),qsTr("警告"),qsTr("限制级故障"), qsTr("停机级故障"), qsTr("未知错误")]
    property string customTitle: ""
    property string customIconSource: "../Icon/btn_close_normal.png"

    id: _item
    signal buttonClicked(int buttonFlag)

    function popupMessage(level, summary, solution, detail = "") {
        _item.level = level
        _item.summary = summary
        _item.detail = detail
        _item.solution = solution

        _faultPopup.open()
    }
    function close() {
        _faultPopup.close()
    }

    function open() {
        _faultPopup.open()
    }
    Popup {
        id: _faultPopup
        property bool expand: false

        width: popupWidth
        height: popupHeight
        padding: -10
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
        parent: Overlay.overlay
        anchors.centerIn: parent

        Rectangle {
            anchors.fill: parent
            radius: _radius
            color: HcTheme.dark ? Constants.dialogDeepBackground : Constants.dialogBackground
            border.width: HcTheme.dark ? 0 : borderWidth
            border.color: Constants.dialogHeadBorderColor
            HcShadow{
                radius: _radius
                color: Constants.dialogHeadBorderColor
            }
        }

        HcRoundedRectangle {
            width: parent.width
            height: headerHeight
            gradient: HcTheme.dark ?  Constants.dialogHeadDeepGradient : Constants.dialogHeadGradient

            radius: [_radius,_radius,0,0]

            Item {
                width: parent.width - 2
                height: parent.height - parent.radius
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                ColorImage {
                    id: _colorImage
                    fillMode: Image.Pad
                    source: customIconSource
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    width: contentWidth
                    height: contentHeight
                    text:  _item.customTitle !== "" ? _item.customTitle : (_item.level >= 0 && _item.level < _item.titleOptions.length) ? titleOptions[level] : qsTr("未知错误")
                    font.pixelSize: 16
                    color: "#484848"
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: _colorImage.right
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            //分割线
            HcDivider{
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                dividerColor: HcTheme.dark ? "#000000" : ""
            }
        }

        Column {
            id: _col
            width: popupWidth - 2 * _faultPopup.padding - 80
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 25
            anchors.horizontalCenterOffset: 0

            component FaultInfo : Row {
                property string label: ""
                property string content: ""

                Text {
                    id: _lable
                    width: contentWidth
                    height: contentHeight
                    text: label
                    font.pixelSize: 16
                    color: "#4a4a4a"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    width: popupWidth - 2 * _faultPopup.padding - 80 - _lable.width
                    height: contentHeight
                    text: content
                    font.pixelSize: 16
                    color: "#4a4a4a"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.WordWrap
                }
            }

            FaultInfo {
                label: qsTr("故障信息：")
                content: summary
            }
            Item {
                width: 1
                height: 10
            }
            FaultInfo {
                label: qsTr("处理方法：")
                content: solution
            }
            Item {
                width: 1
                height: 10
            }
            FaultInfo {
                id: _detailInfo
                label: qsTr("详细信息：")
                content: detail
                visible: _faultPopup.expand && detail !== ""
            }
            Item {
                width: 1
                height: 60
                visible: detail === ""
            }
            Text {
                width: contentWidth
                height: 60
                text: _faultPopup.expand ? qsTr("收起详情") : qsTr("展开详情")
                font.pixelSize: 16
                color: "lightskyblue"/*"lightsteelblue"*/
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                visible: detail !== ""
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        _faultPopup.expand = !_faultPopup.expand
                    }
                }
            }
            Item {
                width: 1
                height: 20
            }
            Row {
                spacing: 60
                anchors.horizontalCenter: parent.horizontalCenter
                visible: buttonComponent === null

                HcButton {
                    id: _noneBtn
                    width: 60
                    height: 30
                    text: _item.noneText
                    visible: _item.buttonFlags === Constants.AlarmHandleOption.Handle_None
                    font.pixelSize: 16
                    onClicked: {
                        _item.buttonClicked(Constants.AlarmHandleOption.Handle_None)
                    }
                }
                HcButton {
                    id: _skipBtn
                    width: 60
                    height: 30
                    text: _item.skipText
                    visible: _item.buttonFlags & Constants.AlarmHandleOption.Handle_Skip
                    font.pixelSize: 16
                    onClicked: {
                        _item.buttonClicked(Constants.AlarmHandleOption.Handle_Skip)
                    }
                }
                HcButton {
                    id: _retryBtn
                    width: 60
                    height: 30
                    text: _item.retryText
                    visible: _item.buttonFlags & Constants.AlarmHandleOption.Handle_Retry
                    font.pixelSize: 16
                    onClicked: {
                        _item.buttonClicked(Constants.AlarmHandleOption.Handle_Retry)
                    }
                }
                HcButton {
                    id: _stopBtn
                    width: 60
                    height: 30
                    text: _item.stopText
                    visible: _item.buttonFlags & Constants.AlarmHandleOption.Handle_Stop
                    font.pixelSize: 16
                    onClicked: {
                        _item.buttonClicked(Constants.AlarmHandleOption.Handle_Stop)
                    }
                }
            }
            Loader {
                id: buttonLoader
                sourceComponent: buttonComponent
                visible: buttonComponent !== null
                anchors.horizontalCenter: parent.horizontalCenter
            }
            onHeightChanged: {
                popupHeight = _col.height + 160 + 2 * _faultPopup.padding
            }
            Component.onCompleted: {
                popupHeight = _col.height + 120 + 2 * _faultPopup.padding
            }

        }
    }
}

