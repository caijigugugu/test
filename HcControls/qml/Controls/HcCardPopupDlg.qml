import QtQuick
import QtQuick.Controls
import HcControls

HcObject {
    property var root
    property int popupWidth: 300 //弹窗宽度
    property int screenWidth: 1000 //弹窗可拖拽区域宽度
    property int screenHeight: 900
    property int layoutY: 75
    property bool showIcon: true //是否展示关闭图标
    property bool isRepeat: false //相同内容是否刷新展示时间
    property int screenX: -1  // 显示区域坐标，默认 -1 表示未配置
    property int screenY: -1
    property int popupX: -1 //弹窗相对于区域坐标，默认右上角
    property int popupY: -1
    property int _positionCorner: Constants.PositionCorner.TopRight
    property string promptIcon_info: "../Icon/通知.svg" //提示图标
    property string promptIcon_warning: "../Icon/警告.svg"
    property string closeIconSource: "../Icon/关闭.svg" //关闭图标
    //图标可配置颜色，默认原始颜色
    // property string promptIconColor: "#09C9D7"
    // property string closeIconColor: "#FFFFFF"
    //提示文本
    property int titleSize: 18
    //详细信息文本
    property int detailSize: 14
    //提示图标大小
    property int promptIconWidth: 20
    property int promptIconHeight: 20
    //关闭图标大小
    property int closeIconWidth: 15
    property int closeIconHeight: 15
    property int radius: 4 //圆角
    property int borderWidth: 1 //描边宽度
    id: cardDlg

    function showInfo(prompt = "",detailText = "",timeOut = 10000){
        return _item.createDlg(_item.const_info,prompt,detailText,timeOut)
    }
    function showWarning(prompt = "",detailText = "",timeOut = 10000){
        return _item.createDlg(_item.const_warning,prompt,detailText,timeOut)
    }
    function showError(prompt = "",detailText = "",timeOut = 10000){
        return _item.createDlg(_item.const_error,prompt,detailText,timeOut)
    }
    HcObject {
        id: _item
        property var screenLayout: null
        property string const_info: "info"
        property string const_warning: "warning"
        property string const_error: "error"
        function createDlg(type,prompt,detailText,timeOut) {
            if(screenLayout){
                //获取容器中最后一个对象，如果标题和内容都相同，且开启刷新，则刷新展示时间
                var last = screenLayout.getLastloader()
                if(isRepeat && last.title === prompt && detailText === last.detail && timeOut > 0){
                    last.duration = timeOut
                    if (timeOut > 0) last.restart()
                    return last
                }
            }
            initScreenLayout()
            return contentComponent.createObject(screenLayout,{type:type,title:prompt,duration:timeOut,detail:detailText})
        }
        function initScreenLayout(){
            if(screenLayout == null){
                screenLayout = screenlayoutComponent.createObject(root)
                screenLayout.y = cardDlg.layoutY
                screenLayout.z = 100000
            }
        }
        //可拖拽区域
        Component{
            id:screenlayoutComponent
            Column{
                parent: Overlay.overlay
                z:999
                spacing: 20
                width: screenWidth
                height:screenHeight
                x: cardDlg.screenX !== -1 ? cardDlg.screenX : parent.width - width// 默认右上角 x 坐标
                y: cardDlg.screenY !== -1 ? cardDlg.screenY : 0 // 右上角 y 坐标
                move: Transition {
                    NumberAnimation {
                        properties: "y"
                        easing.type: Easing.OutCubic
                        duration: 333
                    }
                }
                onChildrenChanged: if(children.length === 0)  destroy()
                function getLastloader(){
                    if(children.length > 0){
                        return children[children.length - 1]
                    }
                    return null
                }
            }
        }

        Component{
            id:contentComponent
            Item{
                id:content
                property int duration: 1000
                property string title: qsTr("提示")
                property string detail: ""
                property string type
                property string promptIconSource:{
                    switch(content.type){
                        case _item.const_info:
                            return cardDlg.promptIcon_info
                        case _item.const_warning:
                            return cardDlg.promptIcon_warning
                        case _item.const_error:
                            return cardDlg.promptIcon_warning
                        }
                }
                property string backColor:{
                    if(HcTheme.dark) {
                        switch(content.type){
                        case _item.const_info:
                            return Constants.cardDlgBackDeepColor_Info
                        case _item.const_warning:
                            return Constants.cardDlgBackDeepColor_Warning
                        case _item.const_error:
                            return Constants.cardDlgBackDeepColor_Error
                        }
                    } else {
                        return Constants.cardDlgBackColor
                    }
                }
                property color borderColor:{
                    if(HcTheme.dark) {
                        switch(content.type){
                        case _item.const_info:
                            return Constants.cardDlgBorderDeepColor_Info
                        case _item.const_warning:
                            return Constants.cardDlgBorderDeepColor_Warning
                        case _item.const_error:
                            return Constants.cardDlgBorderDeepColor_Error
                        }
                    } else {
                        return Constants.cardDlgBorderColor
                    }
                }
                property string titleColor: {
                    if(HcTheme.dark) {
                        return Constants.cardDlgTextDeepColor
                    } else {
                        switch(content.type){
                        case _item.const_info:
                            return Constants.cardDlgTextColor_Info
                        case _item.const_warning:
                            return Constants.cardDlgTextColor_Warning
                        case _item.const_error:
                            return Constants.cardDlgTextColor_Error
                        }
                    }
                }
                property string detailColor: {
                    if(HcTheme.dark) {
                        return Constants.cardDlgTextDeepColor
                    } else {
                        return Constants.cardDlgTextColor_Info
                    }
                }
                property string promptIconColor: {
                    if(HcTheme.dark) {
                        switch(content.type){
                        case _item.const_info:
                            return Constants.cardDlgIconColor_Info
                        case _item.const_warning:
                            return Constants.cardDlgIconColor_Warning
                        case _item.const_error:
                            return Constants.cardDlgIconColor_Error
                        }
                    } else {
                        switch(content.type){
                        case _item.const_info:
                            return Constants.cardDlgIconColor_Info
                        case _item.const_warning:
                            return Constants.cardDlgIconColor_Warning
                        case _item.const_error:
                            return Constants.cardDlgIconDeepColor_Error
                        }
                    }
                }
                width:  popupWidth
                height: loader.height
                x:{
                    if (cardDlg.popupX !== -1) {
                        return cardDlg.popupX;
                    } else {
                        switch (_positionCorner) {
                        case Constants.PositionCorner.TopRight: return parent.width - width;
                        case Constants.PositionCorner.TopLeft: return 0;
                        case Constants.PositionCorner.BottomRight: return parent.width - width;
                        case Constants.PositionCorner.BottomLeft: return 0;
                        }
                    }
                }
                y: {
                    if (cardDlg.popupY !== -1) {
                        return cardDlg.popupY;
                    } else {
                        switch (_positionCorner) {
                        case Constants.PositionCorner.TopRight: return 0;
                        case Constants.PositionCorner.TopLeft: return 0;
                        case Constants.PositionCorner.BottomRight: return 500;
                        case Constants.PositionCorner.BottomLeft: return parent.height - height;
                        }
                    }
                }
                function close(){
                    content.destroy()
                }
                function restart(){
                    delayTimer.restart()
                }
                Timer {
                    id:delayTimer
                    interval: duration
                    running: duration > 0
                    repeat: duration > 0
                    onTriggered: content.close()
                }

                MouseArea {
                    id: _mouseArea
                    property point clickPoint: "0, 0"

                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed: clickPoint = Qt.point(mouseX, mouseY)
                    onPositionChanged: {

                        var offset = Qt.point(mouseX - clickPoint.x, mouseY - clickPoint.y)
                        var x = content.x + offset.x
                        var y = content.y + offset.y

                        if (x < 0) {
                            content.x = 0
                        } else if (x >content.parent.width - content.width) {
                            content.x = content.parent.width - content.width
                        } else {
                            content.x = x
                        }

                        if (y < 0) {
                            content.y = 0
                        } else if (y > content.parent.height - content.height) {
                            content.y = content.parent.height - content.height
                        } else {
                            content.y = y
                        }
                    }
                }
                Loader{
                    id:loader
                    x:(parent.width - width) / 2
                    property var _super: content
                    scale: item ? 1 : 0
                    asynchronous: true
                    Behavior on scale {
                        enabled: true
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 167
                        }
                    }
                    sourceComponent: _item.fluent_temp
                    Component.onDestruction: sourceComponent = undefined
                }
            }
        }
        property Component fluent_temp:  Rectangle{
            id: popup
            width:  popupWidth
            height: _col.height
            color: _super.backColor
            radius: cardDlg.radius
            Column {
                id: _col
                width: parent.width
                height: _header.height + _content.height
                anchors.top: parent.top
                Rectangle {
                    id: _header
                    width: parent.width
                    height: _title.height + 10
                    radius: cardDlg.radius
                    color: _super.backColor
                    Canvas {
                        id: borderCanvas
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            if (cardDlg.borderWidth > 0) {
                                ctx.strokeStyle = _super.borderColor;
                                ctx.lineWidth = cardDlg.borderWidth;

                                ctx.beginPath();
                                ctx.moveTo(_header.radius, 0);
                                ctx.lineTo(width - _header.radius, 0);
                                ctx.arcTo(width, 0, width, _header.radius, _header.radius);
                                ctx.lineTo(width, height);
                                ctx.moveTo(0, height);
                                ctx.lineTo(0, _header.radius);
                                ctx.arcTo(0, 0, _header.radius, 0, _header.radius);
                                ctx.stroke();
                            }
                        }
                        Component.onCompleted: borderCanvas.requestPaint()
                    }

                    ColorImage {
                        id: _promptIcon
                        source: _super.promptIconSource
                        width: cardDlg.promptIconWidth
                        height: cardDlg.promptIconHeight
                        color: _super.promptIconColor
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: _title
                        width: parent.width - _promptIcon.width - 55
                        height: implicitHeight
                        anchors.left: _promptIcon.right
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: _super.titleColor
                        font.pixelSize: cardDlg.titleSize
                        text: _super.title
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        padding: 6
                    }

                    ColorImage {
                        id: _closeIcon
                        source: cardDlg.closeIconSource
                        color: _super.titleColor
                        width: cardDlg.closeIconWidth
                        height: cardDlg.closeIconHeight
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        fillMode: Image.PreserveAspectFit
                        visible: showIcon
                        MouseArea {
                            id: _closeArea
                            anchors.fill: parent
                            onClicked: {
                                _super.close()
                            }
                        }
                    }
                }
                Rectangle {
                    id: _content
                    width: parent.width
                    height: _detail.height
                    anchors.left: parent.left
                    radius: cardDlg.radius
                    color: _super.backColor
                    Canvas {
                        id: _borderCanvas
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            if (cardDlg.borderWidth > 0) {
                                ctx.strokeStyle = _super.borderColor;
                                ctx.lineWidth = cardDlg.borderWidth;

                                ctx.beginPath();
                                ctx.moveTo(0, 0);
                                ctx.lineTo(0, height - _content.radius);
                                ctx.arcTo(0, height, _content.radius, height, _content.radius);
                                ctx.lineTo(width - _content.radius, height);
                                ctx.arcTo(width, height, width, height - _content.radius, _content.radius);
                                ctx.lineTo(width, 0);
                                ctx.stroke();
                            }
                        }
                        Component.onCompleted: _borderCanvas.requestPaint()
                    }
                    Label {
                        id: _detail
                        width: parent.width - 55 - cardDlg.promptIconWidth
                        height: implicitHeight
                        //anchors.centerIn: parent
                        anchors.left: parent.left
                        anchors.leftMargin: cardDlg.promptIconWidth + 30
                        color: _super.detailColor
                        font.pixelSize: cardDlg.detailSize
                        text: _super.detail
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        padding: 6
                    }
                }

            }

        }

    }
}



