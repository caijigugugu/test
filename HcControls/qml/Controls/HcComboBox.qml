import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Controls
import QtQuick.Controls.Basic
import HcControls
T.ComboBox {
    id: control

    //可以被鼠标选择
    selectTextByMouse: true
    signal commit(string text)
    property int borderWidth: 1
    property color borderColor: Constants.backBorder
    property color fontColor: Constants.fontGreyColor
    property color cursorColor: Constants.fontLightColor
    property int controlMaxHeight: 600
    property alias textBox: text_field
    implicitWidth: implicitBackgroundWidth;
    implicitHeight: implicitBackgroundHeight;
    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    //获取焦点
    focusPolicy: Qt.TabFocus
    // 弹出框行委托
    delegate: ItemDelegate {
        width: control.width
        highlighted: control.highlightedIndex === index

        contentItem: Text {
            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
            color: fontColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            color: control.highlightedIndex === index ? Constants.tableHeadbgColor : "white"
        }

        property int index: model.index
        property string modelData
    }

    indicator: Item {
        width: 20
        height: 8
        x: control.width - width;
        y: control.topPadding + (control.availableHeight - height) / 2;

        Canvas {
            id: _canvas
            width: 12
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 8
            contextType: "2d"

            Behavior on rotation {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            Connections {
                target: control
                function onPressedChanged() { _canvas.requestPaint(); }
            }
            //指示器翻转效果
            Connections {
                target: control.popup
                function onOpened() {
                    _canvas.rotation = 180
                }
                function onClosed() {
                    _canvas.rotation = 0
                }
            }
            onPaint: {
                context.reset();
                context.moveTo(0, 0);

                context.lineWidth = 2;
                context.lineTo(width / 2, height*0.8);
                context.lineTo(width, 0);
                context.strokeStyle = control.pressed ? "#EEEFF7" : "#999999";
                context.stroke();
            }
        }
    }
    //下拉框文字
    contentItem: T.TextField {
        id: text_field
        leftPadding:  !control.mirrored ? 10 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1;
        text: control.editable ? control.editText : control.displayText
        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse
        font: control.font
        color: fontColor
        selectionColor: control.Material.accentColor
        selectedTextColor: "white"
        verticalAlignment: Text.AlignVCenter

        cursorDelegate: CursorDelegate {
            color: cursorColor
        }
        Keys.onEnterPressed: (event)=> handleCommit(event)
        Keys.onReturnPressed:(event)=> handleCommit(event)
        function handleCommit(event){
            control.commit(control.editText)
            accepted()
        }
    }

    background: Rectangle {
        width: control.width
        height: control.height
        border.color: borderColor
        border.width: borderWidth
        color: "white"/*"transparent"*/
        anchors.verticalCenter: control.contentItem.verticalCenter
    }
    // 弹出窗口样式
    popup: T.Popup {
        x: 0
        y: control.height
        width: control.width

        height: Math.min(control.controlMaxHeight,
                         combocontrollistView.contentHeight)
        contentItem: ListView {
            id: combocontrollistView
            clip: true
            cacheBuffer: 40
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0
            spacing: 0

            ScrollBar.vertical: ScrollBar {
                width: 9
                policy: combocontrollistView.contentHeight
                        > control.controlMaxHeight ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            }
        }
    }
}
