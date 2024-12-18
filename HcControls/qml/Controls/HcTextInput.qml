import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import HcControls

Item {
    implicitWidth: 400
    implicitHeight: 50
    property int _radius: 2
    property int labelWidth: 70
    property bool hasLabel: true
    property string label: ""
    property alias textInputText: _textInput.text
    //无输入时显示的文本
    property string placeholderText: qsTr("请输入")
    //选中文本背景色
    property color selectionColor: HcTheme.dark ? Constants.selectionDeepColor : Constants.selectionColor
    //选中文本的颜色
    property color selectedTextColor: "black"
    property int padding: 0
    property int fontSize: 14
    property color fontColor: "#484848"
    property color bgColor: "#FFFFFF"
    property int borderWidth: 1
    property color borderColor: "#A9B6B7"
    property int echo: TextInput.Normal
    property string regexp: ".*"    /*"^[A-Za-z0-9@_]+$"*/
    property int maxLen: 40
    property int _spacing: 10
    //文本据边框距离
    property int _padding: 20
    id:control
    function getInputText() {
        return _loader.children[0].children[1].children[0].text
    }

    function setInputText(text) {
        _loader.children[0].children[1].children[0].text = text
        _textInput.text = text
    }
    Row {
        width: parent.width
        height: parent.height
        spacing: _spacing

        Label {
            id: _label
            width: visible ? labelWidth : 0
            height: parent.height
            text: label
            font.pixelSize: fontSize
            color: fontColor
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Normal
            visible: text !== ""
        }
        TextField {
            id: _textInput
            width: parent.width - _label.width - _spacing
            height: parent.height
            font.pixelSize: fontSize
            color: fontColor
            echoMode: echo
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Normal
            leftPadding: _padding
            rightPadding: _padding
            clip: true
            //字符限制长度
            maximumLength: maxLen
            wrapMode: TextInput.WordWrap
            selectByMouse: true
            selectionColor: control.selectionColor
            selectedTextColor: control.selectedTextColor
            placeholderText: control.placeholderText
            validator: RegularExpressionValidator { regularExpression: RegExp(control.regexp) }
            focus: true
            //文本框边框
            background: Rectangle {
                border.width: control.borderWidth
                border.color: control.borderColor
                color: control.bgColor
                radius: control._radius
            }

        }
    }
}
