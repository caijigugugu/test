import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Controls.Universal
import HcControls

Button {

    id: control
    //当前按钮级别,用来确定默认大小
    property int level: 1
    width: {
        if (level === 1) 100
        else if (level === 2) 40
        else if (level === 3) 28
        else 12
    }
    height: {
        if (level === 1) 36
        else if (level === 2) 36
        else if (level === 3) 28
        else 12
    }
    //圆角
    property int _radius: 2
    property int borderWidth: 1
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
    property Gradient buttonNormolGradient: HcTheme.dark ?  Constants.buttonNormolDeepGradient : Constants.buttonNormolGradient
    property Gradient buttonHoverGradient: HcTheme.dark ?  Constants.buttonHoverDeepGradient : Constants.buttonHoverGradient
    property Gradient buttonCheckedGradient: HcTheme.dark ?  Constants.buttonPressedDeepGradient : Constants.buttonPressedGradient
    property Gradient buttonDisableGradient: Constants.buttonDisableGradient
    property Gradient buttonColor: {
        if(!enabled){
            return buttonDisableGradient
        }
        if(checked){
            return buttonCheckedGradient
        }
        return hovered ? buttonHoverGradient : buttonNormolGradient
    }

    //字体颜色
    property color fontNormolColor: Constants.buttonFontNormolColor
    property color fontHoverColor: HcTheme.dark ?  Constants.buttonFontHoverDeepColor : Constants.buttonFontHoverColor
    property color fontCheckedColor: Constants.buttonFontCheckedColor
    property color fontDisableColor: Constants.buttonFontDisableColor
    property color fontColor: {
        if(!enabled){
            return fontDisableColor
        }
        if(checked){
            return fontCheckedColor
        }
        return hovered ? fontHoverColor : fontNormolColor
    }

    //默认字体大小
    font.pixelSize: 14
    background: Rectangle {
        id: _rect

        border.width: borderWidth
        border.color: borderColor
        radius: _radius
        gradient: buttonColor
    }

    contentItem: Text {
        id: _text
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: fontColor
    }
}
