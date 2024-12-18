import QtQuick 2.15
import QtQuick.Controls 2.15
import HcControls

TabButton {
    property color bgColor: Constants.globalBackground
    //背景颜色
    property Gradient buttonNormolGradient: HcTheme.dark ?  Constants.tabBtnNormolDeepGradient : Constants.tabBtnNormolGradient
    property Gradient buttonCheckedGradient: HcTheme.dark ?  Constants.tabBtnCheckedDeepGradient : Constants.tabBtnCheckedGradient

    property Gradient bgGradient: {
        if(checked) return buttonCheckedGradient
        return buttonNormolGradient
    }
    //边框颜色
    property color borderColor: HcTheme.dark ?  Constants.tabBtnBorderNormolDeepColor : Constants.tabBtnBorderNormolColor
    property color borderHighlightColor: HcTheme.dark ?  Constants.tabBtnBorderHighlightDeepColor : Constants.tabBtnBorderHighlightColor
    property int borderWidth: 1
    property int borderHighlightWidth: 2
    //圆角半径
    property int bgRadius: 2
    //文本颜色
    property color fontColor: {
        if(HcTheme.dark){
            if(checked){
                return Constants.tabBtnFontCheckedDeepColor
            }
            return Constants.tabBtnFontNormolDeepColor
        }else{
            if(checked){
                return Constants.tabBtnFontCheckedColor
            }
            return Constants.tabBtnFontNormolColor
        }
    }
    id: control
    font.pixelSize: 14
    background:  HcRoundedRectangle{
        width: parent.width
        height: parent.height
        color: bgColor
        radius: [bgRadius,bgRadius,0,0]
        gradient: bgGradient
        borderWidth: control.borderWidth
        borderColor: control.borderColor
        //顶部高亮边框
        HcClip{
            anchors.fill: parent
            radius: [0,0,0,0]
            visible: checked
            Rectangle{
                width: parent.width
                height: borderHighlightWidth
                anchors.top: parent.top
                color: borderHighlightColor
            }
        }
    }

    contentItem: Text {
        text: parent.text
        font: parent.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: parent.width
        height: parent.height
        color: fontColor
    }
}
