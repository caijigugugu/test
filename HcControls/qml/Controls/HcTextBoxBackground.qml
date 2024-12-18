import QtQuick
import QtQuick.Controls
import HcControls

HcControlBackground{
    property Item inputItem
    id:control
    color: {
        if(inputItem && inputItem.disabled){
            return HcTheme.dark ? Constants.bgDisableDeepColor : Constants.bgDisableColor
        }
        return HcTheme.dark ? Constants.bgNormalDeepColor : Constants.bgNormalColor
    }
    border.width: 1
    gradient: Gradient {
        GradientStop { position: 0.0; color: d.startColor }
        GradientStop { position: 1 - d.offsetSize/control.height; color: d.startColor }
        GradientStop { position: 1.0; color: d.endColor }
    }
    QtObject{
        id:d
        property int offsetSize :  0
        property color startColor : {
            if(!control.enabled){
                return HcTheme.dark ? Constants.borderNormalDeepColor : Constants.borderNormalColor
            }
            if(inputItem && inputItem.activeFocus){
                return HcTheme.dark ? Constants.borderFocusDeepColor : Constants.borderFocusColor
            }
            return  HcTheme.dark ? Constants.borderNormalDeepColor : Constants.borderNormalColor
        }
        property color endColor: d.startColor
    }
}
