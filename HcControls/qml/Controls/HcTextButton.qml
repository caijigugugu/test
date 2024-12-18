import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color normalColor: "#333333"
    property color hoverColor:  Qt.darker(normalColor,1.15)
    property color pressedColor:  Qt.darker(normalColor,1.3)
    property color disableColor:  Qt.rgba(82/255,82/255,82/255,1)
    property color backgroundHoverColor: "#EFF3F4"
    property color backgroundPressedColor: "#61CED5"
    property color backgroundNormalColor: "#FFFFFF"
    property color backgroundDisableColor: "#C1C1C1"
    property bool textBold: true
    property color textColor: {
        if(!enabled){
            return disableColor
        }
        if(pressed){
            return pressedColor
        }
        return hovered ? hoverColor :normalColor
    }
    id: control
    horizontalPadding:6
    enabled: !disabled
    background: Rectangle{
        implicitWidth: 30
        implicitHeight: 30
        radius: 4
        color: {
            if(!enabled){
                return backgroundDisableColor
            }
            if(pressed){
                return backgroundPressedColor
            }
            if(hovered){
                return backgroundHoverColor
            }
            return backgroundNormalColor
        }
    }
    focusPolicy:Qt.TabFocus
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    contentItem: Text {
        id:btn_text
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.textColor
    }
}
