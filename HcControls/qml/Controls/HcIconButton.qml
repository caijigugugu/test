import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls.Universal
import HcControls

Button {
    display: Button.TextBesideIcon
    property int _radius: 2
    property int borderWidth: 1
    property int iconSize: 12
    //icon与text间隔
    property int _spacing: 10
    property var iconSource
    property Component iconDelegate: com_icon
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
    property color fontNormolColor: "#4B5153"
    property color fontHoverColor: "#49B8B1"
    property color fontCheckedColor: "#FFFFFF"
    property color fontDisableColor: "#8C8C8C"
    property color textColor: {
        if(!enabled){
            return fontDisableColor
        }
        if(checked){
            return fontCheckedColor
        }
        return hovered ? fontHoverColor : fontNormolColor
    }
    //图标颜色
    property color iconNormolColor: "#658080"
    property color iconHoverColor: "#49B8B1"
    property color iconCheckedColor: "#FFFFFF"
    property color iconDisableColor: "#8C8C8C"
    property color iconColor: {
        if(!enabled){
            return iconDisableColor
        }
        if(checked){
            return iconCheckedColor
        }
        return hovered ? iconHoverColor : iconNormolColor
    }
    property string contentDescription: ""
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()

    id: control
    focusPolicy:Qt.TabFocus
    //默认字体大小
    font.pixelSize: 28
    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: control._radius
        gradient: control.buttonColor
        border.color: control.borderColor
        border.width: control.borderWidth
        HcFocusRectangle{
            visible: control.activeFocus
        }
    }
    // 定制搜索图标
    contentItem: HcLoader {
        sourceComponent: {
            if(display === Button.TextUnderIcon){
                return com_column
            }
            return com_row
        }
    }

    // 字体图标的ttf组件
    Component {
        id: ttfComponent
        HcIcon {
            id: text_icon
            font.pixelSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            iconColor: control.iconColor
            iconSource: control.iconSource
        }
    }

    // 自定义图标的 ColorImage 组件
    Component {
        id: iconComponent
        ColorImage {
            id: custom_icon
            source: control.iconSource
            width: control.iconSize
            height: control.iconSize
            color: control.iconColor
            fillMode: Image.PreserveAspectFit
        }
    }

    Component {
        id: com_icon
        HcLoader {
            id: iconLoader
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            sourceComponent: isNaN(control.iconSource)
                             ? iconComponent : ttfComponent
        }
    }

    Component {
        id: com_row
        Item {
            anchors.centerIn: parent
            Row {
                anchors.centerIn: parent
                spacing: control._spacing
                HcLoader{
                    sourceComponent: iconDelegate
                    anchors.verticalCenter: parent.verticalCenter
                    visible: display !== Button.TextOnly
                }
                Text {
                    text: control.text
                    font: control.font
                    color: control.textColor
                    visible: display !== Button.IconOnly
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Component{
        id:com_column
        Item {
            anchors.centerIn: parent
            Column{
                anchors.centerIn: parent
                spacing: control._spacing
                HcLoader{
                    sourceComponent: iconDelegate
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: display !== Button.TextOnly
                }
                Text{
                    text: control.text
                    font: control.font
                    color: control.textColor
                    width: control.width
                    wrapMode: Text.WrapAnywhere
                    visible: display !== Button.IconOnly
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
    HcTooltip{
        id:tool_tip
        visible: {
            if(control.text === ""){
                return false
            }
            if(control.display !== Button.IconOnly){
                return false
            }
            return hovered
        }
        text:control.text
        delay: 1000
    }
}
