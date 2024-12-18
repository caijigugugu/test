import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import HcControls

T.Frame {
    property alias border: d.border
    property alias color: d.color
    property alias radius: d.radius
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    padding: 0
    background: Rectangle {
        id:d
        radius: 4
        color: {
            if(Window.active){
                return HcTheme.frameActiveColor
            }
            return HcTheme.frameColor
        }
    }
}
