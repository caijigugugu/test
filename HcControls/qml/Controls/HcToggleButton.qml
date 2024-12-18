import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color normalColor: {
        if(checked){
            return "#61CED5"
        }else{
            return  "#EFF3F4"
        }
    }
    property color hoverColor: {
        if(checked){
            return Qt.darker(normalColor,1.1)
        }else{
            return "#D3DEDF"
        }
    }
    property color disableColor: "#C1C1C1"
    property color pressedColor: "#61CED5"
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    focusPolicy:Qt.TabFocus
    id: control
    enabled: !disabled
    verticalPadding: 0
    horizontalPadding:12
    background: Rectangle{
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 4
        color:{
            if(!enabled){
                return disableColor
            }
            if(checked){
                if(pressed){
                    return pressedColor
                }
            }
            return hovered ? hoverColor :normalColor
        }
        border.width: {
            if(checked){
                return enabled ? 1 : 0
            }else{
                return 1
            }
        }
        border.color: "#C2C2C3"
    }
    contentItem: Text {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: {
            if(checked){
                return Qt.rgba(0,0,0,1)
            }else{
                if(!enabled){
                    return Qt.rgba(160/255,160/255,160/255,1)
                }
                if(!checked){
                    if(pressed){
                        return Qt.rgba(96/255,96/255,96/255,1)
                    }
                }
                return Qt.rgba(0,0,0,1)
            }
        }
    }
}

