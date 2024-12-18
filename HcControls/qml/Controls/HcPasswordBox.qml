import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import HcControls

TextField{
    signal commit(string text)
    //当前输入框级别,用来确定默认输入框大小
    property int level: 1
    property bool disabled: false
    property int iconSource: 0
    property color normalColor: HcTheme.dark ?  Constants.normalDeepColor : Constants.normalColor
    property color disableColor: HcTheme.dark ? Constants.disableDeepColor : Constants.disableColor
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
    enabled: !disabled
    color: {
        if(!enabled){
            return disableColor
        }
        return normalColor
    }
    font:HcTextStyle.Body
    padding: 7
    rightPadding: 40
    leftPadding: padding+4
    echoMode:btn_reveal.pressed ? TextField.Normal : TextField.Password
    renderType: HcTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectionColor: HcTools.withOpacity(HcTheme.primaryColor,0.5)
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
    selectByMouse: true
    background: HcTextBoxBackground{
        inputItem: control
    }
    Keys.onEnterPressed: (event)=> d.handleCommit(event)
    Keys.onReturnPressed:(event)=> d.handleCommit(event)
    QtObject{
        id:d
        function handleCommit(event){
            control.commit(control.text)
        }
    }
    HcIconButton{
        id:btn_reveal
        iconSource:HcIcons.RevealPasswordMedium
        iconSize: 10
        width: 30
        height: 20
        verticalPadding: 0
        horizontalPadding: 0
        iconColor: control.iconColor
        buttonColor: Gradient {
            GradientStop {
                color: "transparent"
            }
        }
        borderWidth: 0
        visible: control.text !== ""
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 5
        }
    }
}
