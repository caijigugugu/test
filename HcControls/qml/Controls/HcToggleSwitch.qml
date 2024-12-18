import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls.Universal

Button {
    property int _radius: 2
    property int borderWidth: 1
    //间隔
    property int _spacing: 10
    property int buttonWidth: 40
    property int buttonHeight: 20
    //文本默认显示在右方
    property bool textRight: true
    //描边颜色
    property color borderNormolColor: "#C7D6D7"
    property color borderHoverColor: "#49B8B1"
    property color borderDisableColor: "#DCDCDC"
    property color borderColor: {
        if(!enabled){
            return borderDisableColor
        }
        if(checked){
            return borderNormolColor
        }
        return hovered ? borderHoverColor : borderNormolColor
    }
    //按钮背景颜色
    property color buttonNormolColor: "#E5E5E5"
    property color buttonHoverColor: "#E6E6E6"
    property color buttonCheckedColor: "#33B6B9"
    property color buttonDisableColor: "#C1C1C1"
    property color buttonColor: {
        if(!enabled){
            return buttonDisableColor
        }
        if(checked){
            return buttonCheckedColor
        }
        return hovered ? buttonHoverColor : buttonNormolColor
    }
    //字体颜色
    property color textColor: "#484848"
    //图标颜色
    property color iconNormolColor: "#FFFFFF"
    property color iconHoverColor: "#49B8B1"
    property color iconCheckedColor: "#FFFFFF"
    property color iconDisableColor: "#8C8C8C"
    property color iconColor: {
        if(!enabled){
            return iconDisableColor
        }
        if(checked){
            return iconCheckedColor
        }
        return hovered ? iconHoverColor : iconNormolColor
    }
    property var clickListener : function(){
        checked = !checked
    }
    id: control
    //默认字体大小
    font.pixelSize: 14
    horizontalPadding: 0
    onClicked: clickListener()
    background: Item {
        implicitWidth: buttonWidth
        implicitHeight: buttonHeight
    }
    contentItem: Row {
        anchors.centerIn: parent
        spacing: control._spacing
        layoutDirection:control.textRight ? Qt.LeftToRight : Qt.RightToLeft
        //主体框
        Rectangle {
            id:control_backgound
            implicitWidth: background.implicitWidth
            implicitHeight: background.implicitHeight
            radius: height / 2
            color: buttonColor
            border.width: 1
            border.color: borderColor
            anchors.verticalCenter: parent.verticalCenter
            //小圆形
            Rectangle {
                width:  parent.height
                height: parent.height
                radius: width / 2
                x:checked ? control_backgound.width-width : 0
                scale: {
                    if(pressed){
                        //按下时图标缩放比列
                        return 5/10
                    }
                    //左为悬浮且按钮可用比列，右为未悬浮或不可用
                    return hovered&enabled ? 7/10 : 6/10
                }
                color: iconColor
                Behavior on scale{
                    NumberAnimation{
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on x  {
                    NumberAnimation {
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
        Text {
            text: control.text
            font: control.font
            color: control.textColor
            Layout.alignment: Qt.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

}
