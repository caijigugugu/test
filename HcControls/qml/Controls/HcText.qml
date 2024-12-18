import QtQuick
import QtQuick.Controls
import HcControls

Text {
    property color textColor: "#323232"//HcTheme.fontPrimaryColor
    id:text
    color: textColor
    renderType: HcTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: HcTextStyle.Body
}
