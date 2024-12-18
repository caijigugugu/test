import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import HcControls

TextArea{
    signal commit(string text)
    property bool disabled: false
    //文本颜色
    property color normalColor: HcTheme.dark ?  Constants.normalDeepColor : Constants.normalColor
    property color disableColor: HcTheme.dark ? Constants.disableDeepColor : Constants.disableColor
    //无输入时文本颜色
    property color placeholderNormalColor: HcTheme.dark ?  Constants.placeholderNormalDeepColor : Constants.placeholderNormalColor
    property color placeholderFocusColor: HcTheme.dark ? Constants.placeholderFocusDeepColor : Constants.placeholderFocusColor
    property color placeholderDisableColor: HcTheme.dark ? Constants.placeholderDisableDeepColor : Constants.placeholderDisableColor
    property bool isCtrlEnterForNewline: false
    id:control
    enabled: !disabled
    color: {
        if(!enabled){
            return disableColor
        }
        return normalColor
    }
    font:HcTextStyle.Body
    wrapMode: Text.WrapAnywhere
    padding: 8
    leftPadding: padding+4
    renderType: HcTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectedTextColor: color
    selectionColor: HcTheme.dark ? Constants.selectionDeepColor : Constants.selectionColor
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
    width: 240
    background: HcTextBoxBackground{
        inputItem: control
    }
    Keys.onEnterPressed: (event)=> d.handleCommit(event)
    Keys.onReturnPressed:(event)=> d.handleCommit(event)
    QtObject{
        id:d
        function handleCommit(event){
            if(isCtrlEnterForNewline){
                if(event.modifiers & Qt.ControlModifier){
                    insert(control.cursorPosition, "\n")
                    return
                }
                control.commit(control.text)
            }else{
                if(event.modifiers & Qt.ControlModifier){
                    control.commit(control.text)
                    return
                }
                insert(control.cursorPosition, "\n")
            }
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
