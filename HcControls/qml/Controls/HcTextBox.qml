import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HcControls

TextField{
    signal commit(string text)
    //当前输入框级别,用来确定默认输入框大小
    property int level: 1
    property bool disabled: false
    property int iconSource: 0
    property int radius: 2
    //是否开启清除内容
    property bool cleanEnabled: false
    //文本颜色
    property color normalColor: HcTheme.dark ?  Constants.normalDeepColor : Constants.normalColor
    property color disableColor: HcTheme.dark ? Constants.disableDeepColor : Constants.disableColor
    //无输入时文本颜色
    property color placeholderNormalColor: HcTheme.dark ? Constants.placeholderNormalDeepColor : Constants.placeholderNormalColor
    property color placeholderFocusColor: HcTheme.dark ? Constants.placeholderFocusDeepColor : Constants.placeholderFocusColor
    property color placeholderDisableColor: HcTheme.dark ? Constants.placeholderDisableDeepColor : Constants.placeholderDisableColor
    property color iconColor: HcTheme.dark ? Constants.textIconDeepColor : Constants.textIconColor
    id:control
    width: {
        if (level === 1) 400
        else if (level === 2) 240
        else 200
    }
    height: {
        if (level === 1) 50
        else if (level === 2) 36
        else 30
    }
    padding: 7
    leftPadding: padding+4
    enabled: !disabled
    color: {
        if(!enabled){
            return disableColor
        }
        return normalColor
    }
    font:HcTextStyle.Body
    renderType: HcTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    //文本被选中时背景和文本颜色
    selectionColor: HcTheme.dark ? Constants.selectionDeepColor : Constants.selectionColor
    selectedTextColor: color
    placeholderTextColor: {
        if(!enabled){
            return placeholderDisableColor
        }
        if(focus){
            return placeholderFocusColor
        }
        return placeholderNormalColor
    }
    placeholderText: qsTr("请输入")
    selectByMouse: true
    rightPadding: {
        var w = 30
        if(control.cleanEnabled === false){
            w = 0
        }
        if(control.readOnly)
            w = 0
        return icon_end.visible ? w+36 : w+10
    }
    background: HcTextBoxBackground{
        inputItem: control
        radius: control.radius
    }
    Keys.onEnterPressed: (event)=> d.handleCommit(event)
    Keys.onReturnPressed:(event)=> d.handleCommit(event)
    QtObject{
        id:d
        function handleCommit(event){
            control.commit(control.text)
        }
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton
        onClicked: {
            if(control.echoMode === TextInput.Password){
                return
            }
            if(control.readOnly && control.text === ""){
                return
            }
            menu_loader.popup()
        }
    }
    RowLayout{
        height: parent.height
        anchors{
            right: parent.right
            rightMargin: 5
        }
        spacing: 4
        HcIconButton{
            iconSource: HcIcons.Cancel
            iconSize: 12
            Layout.preferredWidth: 30
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
            iconColor: control.iconColor
            buttonColor: Gradient {
                GradientStop {
                    color: "transparent"
                }
            }
            borderWidth: 0
            verticalPadding: 0
            horizontalPadding: 0
            visible: {
                if(control.cleanEnabled === false){
                    return false
                }
                if(control.disabled)
                    return false
                if(control.readOnly)
                    return false
                return control.text !== ""
            }
            contentDescription:"Clean"
            onClicked:{
                control.clear()
            }
        }
        HcIcon{
            id:icon_end
            iconSource: control.iconSource
            iconSize: 12
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 7
            iconColor: HcTheme.dark ? Qt.rgba(222/255,222/255,222/255,1) : Qt.rgba(97/255,97/255,97/255,1)
            visible: control.iconSource != 0
        }
    }
    HcLoader{
        id: menu_loader
        function popup(){
            sourceComponent = menu
        }
    }
    Component{
        id:menu
        HcTextBoxMenu{
            inputItem: control
            Component.onCompleted: {
                popup()
            }
            onClosed: {
                menu_loader.sourceComponent = undefined
            }
        }
    }
}
