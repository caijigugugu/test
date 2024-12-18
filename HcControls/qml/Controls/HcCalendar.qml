import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import HcControls

Rectangle {
    // text: {
    //     if(control.current){
    //         return control.current.toLocaleDateString(Qt.locale(control.language),"yyyy/M/d")
    //     }
    //     return qsTr("选择日期")
    // }
    implicitWidth: 500
    implicitHeight: 50
    property int dateWidth: 240
    border.color: "#C7D6D7"
    property string language: "zh_CN"
    property date from: new Date(1924, 0, 1)
    property date to: new Date(2124, 11, 31)
    property var current
    property var startDate
    property var endDate
    property string _src: "../Icon/calendar.png"
    //字体颜色
    property color fontNormolColor: "#333333"
    property color fontHoverColor: "#484848"
    property color fontPressedColor: "#8C8C8C"
    property color fontPrimaryColor: "#409EFF"
    //日期圆形框背景色
    property color backNormolColor: "transparent"
    property color backHoverColor: "#d9d9d9"
    property color backPressedColor: "#F0F0F0"
    property color backPrimaryColor: "#0066B4"

    signal accepted()
    id:control
    CalendarModel {
        id:calender_model
        from: control.from
        to: control.to
    }
    Item{
        id:d
        property var window : Window.window
        property date displayDate: {
            if(control.startDate){
                return control.startDate
            }
            return new Date()
        }
        property date toDay : new Date()
        property int pageIndex: 0
        signal nextButton
        signal previousButton
        property point yearRing : Qt.point(0,0)
    }
    Item{
        id:d1
        property var window : Window.window
        property date displayDate: {
            if(control.endDate){
                return control.endDate
            }
            return new Date()
        }
        property date toDay : new Date()
        property int pageIndex: 0
        signal nextButton
        signal previousButton
        property point yearRing : Qt.point(0,0)
    }

    MouseArea{
        HcTextInput {
            id: item_begin
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 5
            }
            textInputText: {
                if(control.startDate){
                    return control.startDate.toLocaleDateString(Qt.locale(control.language),"yyyy/M/d")
                }
                return ""
            }
            width: dateWidth
            height: parent.height -2
            borderWidth: 0
            placeholderText: qsTr("开始日期")
            MouseArea{
                anchors.fill: parent
                onPressed: function(mouse){
                    mouse.accepted = false
                    popup.showPopup()
                }
            }
        }
        ColorImage {
            id: _startDateImage
            width: 18
            height: 18
            source: _src
            fillMode: Image.PreserveAspectFit
            anchors{
                verticalCenter: parent.verticalCenter
                left: item_begin.right
                rightMargin: 0
            }
        }
        //截止日期
        HcTextInput {
            id: item_end
            anchors{
                verticalCenter: parent.verticalCenter
                left: _startDateImage.right
                rightMargin: 5
            }
            textInputText: {
                if(control.endDate){
                    return control.endDate.toLocaleDateString(Qt.locale(control.language),"yyyy/M/d")
                }
                return ""
            }
            width: dateWidth
            height: parent.height -2
            borderWidth: 0
            placeholderText: qsTr("结束日期")
            MouseArea{
                anchors.fill: parent
                onPressed: function(mouse){
                    mouse.accepted = false
                    popup.showPopup()
                }
            }
        }
        ColorImage {
            width: 18
            height: 18
            source: _src
            fillMode: Image.PreserveAspectFit
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 10
            }
        }
        anchors.fill: parent
        onClicked: {
            popup.showPopup()
        }
    }
    Menu{
        id:popup
        modal: true
        closePolicy: Menu.CloseOnRelease
        Overlay.modal: Item {}
        enter: Transition {
            reversible: true
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: 83
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from:1
                to:0
                duration: 83
            }
        }
        contentItem: Item{
            id:container
            implicitWidth: 610
            implicitHeight: 360
            RowLayout {
                anchors.fill: parent
                spacing: 10
                Loader {
                    id: startDateLoader
                    sourceComponent: dateSelectionComponent
                    onLoaded: {
                        item.calendarType = "start";
                    }
                }
                Loader {
                    id: endDateLoader
                    sourceComponent: dateSelectionComponent
                    onLoaded: {
                        item.calendarType = "end";
                    }
                }
            }
        }
        background:Rectangle{
            radius: 5
            color: Qt.rgba(1,1,1,1)
            border.color: Qt.rgba(191/255,191/255,191/255,1)
            HcShadow{
                radius: 5
            }
        }
        function showPopup() {
            if (popup.visible) {
                return;
            }
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+container.height){
                popup.y = control.height - 1
            } else if(pos.y>container.height){
                popup.y = -container.height
            } else {
                popup.y = d.window.height-(pos.y+container.height)
            }
            popup.open()
        }
    }
    Component {
        id: dateSelectionComponent
        Item {
            id: dateComponent
            implicitWidth: 300
            implicitHeight: 360
            property string calendarType
            property var currentDateData: (calendarType === "start") ? d : d1
            ColumnLayout  {
                anchors.fill: parent
                spacing: 0
                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    RowLayout{
                        anchors.fill: parent
                        spacing: 10
                        Item{
                            Layout.leftMargin: parent.spacing
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            HcTextButton{
                                width: parent.width
                                anchors.centerIn: parent
                                contentItem: Text {
                                    text: currentDateData.displayDate.toLocaleString(Qt.locale(control.language), "MMMM yyyy")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                visible: currentDateData.pageIndex === 0
                                onClicked: {
                                    currentDateData.pageIndex = 1
                                }
                            }
                            HcTextButton{
                                width: parent.width
                                anchors.centerIn: parent
                                contentItem: Text {
                                    text: currentDateData.displayDate.toLocaleString(Qt.locale(control.language), "yyyy")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                visible: currentDateData.pageIndex === 1
                                onClicked: {
                                    currentDateData.pageIndex = 2
                                }
                            }
                            HcTextButton{
                                width: parent.width
                                anchors.centerIn: parent
                                contentItem: Text {
                                    text: "%1-%2".arg(currentDateData.yearRing.x).arg(currentDateData.yearRing.y)
                                    verticalAlignment: Text.AlignVCenter
                                    color: control.fontNormolColor
                                    opacity:0.3
                                }
                                visible: currentDateData.pageIndex === 2
                            }
                        }
                        HcIconButton{
                            id:icon_up
                            iconSource: "../Icon/收起.png"
                            iconSize: 16
                            buttonColor:Gradient {
                                GradientStop {
                                    color: "transparent"
                                }
                            }
                            borderWidth: 0
                            onClicked: {
                                currentDateData.previousButton()
                            }
                        }
                        HcIconButton{
                            id:icon_down
                            iconSource: "../Icon/展开.png"
                            iconSize: 16
                            buttonColor:Gradient {
                                GradientStop {
                                    color: "transparent"
                                }
                            }
                            borderWidth: 0
                            Layout.rightMargin: parent.spacing
                            onClicked: {
                                currentDateData.nextButton()
                            }
                        }
                    }
                }
                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    StackView{
                        id:stack_view
                        anchors.fill: parent
                        initialItem: com_page_one
                        replaceEnter : Transition{
                            OpacityAnimator{
                                from: 0
                                to: 1
                                duration: 83
                            }
                            ScaleAnimator{
                                from: 0.5
                                to: 1
                                duration: 167
                                easing.type: Easing.OutCubic
                            }
                        }
                        replaceExit : Transition{
                            OpacityAnimator{
                                from: 1
                                to: 0
                                duration: 83
                            }
                            ScaleAnimator{
                                from: 1.0
                                to: 0.5
                                duration: 167
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    Connections{
                        target: currentDateData
                        function onPageIndexChanged(){
                            if(currentDateData.pageIndex === 0){
                                stack_view.replace(com_page_one)
                            }
                            if(currentDateData.pageIndex === 1){
                                stack_view.replace(com_page_two)
                            }
                            if(currentDateData.pageIndex === 2){
                                stack_view.replace(com_page_three)
                            }
                        }
                    }
                    //年份界面
                    Component{
                        id:com_page_three
                        GridView{
                            id:grid_view
                            cellHeight: 75
                            cellWidth: 75
                            clip: true
                            boundsBehavior: GridView.StopAtBounds
                            ScrollBar.vertical: ScrollBar {}
                            model: {
                                var fromYear = calender_model.from.getFullYear()
                                var toYear = calender_model.to.getFullYear()
                                return toYear-fromYear+1
                            }
                            highlightRangeMode: GridView.StrictlyEnforceRange
                            onCurrentIndexChanged:{
                                var year = currentIndex + calender_model.from.getFullYear()
                                var start = Math.ceil(year / 10) * 10
                                var end = start+10
                                currentDateData.yearRing = Qt.point(start,end)
                            }
                            highlightMoveDuration: 100
                            Component.onCompleted: {
                                grid_view.highlightMoveDuration = 0
                                currentIndex = currentDateData.displayDate.getFullYear()-calender_model.from.getFullYear()
                                timer_delay.restart()
                            }
                            Connections{
                                target: currentDateData
                                function onNextButton(){
                                    grid_view.currentIndex = Math.min(grid_view.currentIndex+16,grid_view.count-1)
                                }
                                function onPreviousButton(){
                                    grid_view.currentIndex = Math.max(grid_view.currentIndex-16,0)
                                }
                            }
                            Timer{
                                id:timer_delay
                                interval: 100
                                onTriggered: {
                                    grid_view.highlightMoveDuration = 100
                                }
                            }
                            currentIndex: -1
                            delegate: Item{
                                property int year : calender_model.from.getFullYear()+modelData
                                property bool toYear: year === currentDateData.toDay.getFullYear()
                                implicitHeight: 75
                                implicitWidth: 75
                                HcControl{
                                    id:control_delegate
                                    width: 60
                                    height: 60
                                    anchors.centerIn: parent
                                    Rectangle{
                                        width: 48
                                        height: 48
                                        radius: width/2
                                        color: {
                                            if(toYear){
                                                if(control_delegate.pressed){
                                                    return Qt.lighter(control.backPrimaryColor,1.2)
                                                }
                                                if(control_delegate.hovered){
                                                    return Qt.lighter(control.backPrimaryColor,1.1)
                                                }
                                                return control.backPrimaryColor
                                            }else{
                                                if(control_delegate.pressed){
                                                    return control.backPressedColor
                                                }
                                                if(control_delegate.hovered){
                                                    return control.backHoverColor
                                                }
                                                return "transparent"
                                            }
                                        }
                                        anchors.centerIn: parent
                                    }

                                    Text{
                                        text: year
                                        anchors.centerIn: parent
                                        opacity: {
                                            if(year >= currentDateData.yearRing.x &&  year <= currentDateData.yearRing.y){
                                                return 1
                                            }
                                            if(control_delegate.hovered){
                                                return 1
                                            }
                                            return 0.3
                                        }
                                        color: {
                                            if(toYear){
                                                return control.fontPrimaryColor
                                            }
                                            if(control_delegate.pressed){
                                                return control.fontPressedColor
                                            }
                                            if(control_delegate.hovered){
                                                return Qt.lighter(control.fontHoverColor,1.1)
                                            }
                                            return control.fontNormolColor
                                        }
                                    }
                                    onClicked: {
                                        currentDateData.displayDate = new Date(year,0,1)
                                        currentDateData.pageIndex = 1
                                    }
                                }
                            }
                        }
                    }
                    //月份界面
                    Component{
                        id:com_page_two

                        ListView{
                            id:listview
                            ScrollBar.vertical: ScrollBar {}
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            clip: true
                            boundsBehavior: ListView.StopAtBounds
                            spacing: 0
                            highlightMoveDuration: 100
                            model: {
                                var fromYear = calender_model.from.getFullYear()
                                var toYear = calender_model.to.getFullYear()
                                var yearsArray = []
                                for (var i = fromYear; i <= toYear; i++) {
                                    yearsArray.push(i)
                                }
                                return yearsArray
                            }
                            currentIndex: -1
                            onCurrentIndexChanged:{
                                var year = model[currentIndex]
                                var month = currentDateData.displayDate.getMonth()
                                currentDateData.displayDate = new Date(year,month,1)
                            }
                            Connections{
                                target: currentDateData
                                function onNextButton(){
                                    listview.currentIndex = Math.min(listview.currentIndex+1,listview.count-1)
                                }
                                function onPreviousButton(){
                                    listview.currentIndex = Math.max(listview.currentIndex-1,0)
                                }
                            }
                            Component.onCompleted: {
                                listview.highlightMoveDuration = 0
                                currentIndex = model.indexOf(currentDateData.displayDate.getFullYear())
                                timer_delay.restart()
                            }
                            Timer{
                                id:timer_delay
                                interval: 100
                                onTriggered: {
                                    listview.highlightMoveDuration = 100
                                }
                            }
                            delegate: Item{
                                id:layout_congrol
                                property int year : modelData
                                width: listview.width
                                height: 75*3
                                GridView{
                                    anchors.fill: parent
                                    cellHeight: 75
                                    cellWidth: 75
                                    clip: true
                                    interactive: false
                                    boundsBehavior: GridView.StopAtBounds
                                    model: 12
                                    delegate: Item{
                                        property int month : modelData
                                        property bool toMonth: layout_congrol.year === currentDateData.toDay.getFullYear() && month === currentDateData.toDay.getMonth()
                                        implicitHeight: 75
                                        implicitWidth: 75
                                        HcControl{
                                            id:control_delegate
                                            width: 60
                                            height: 60
                                            anchors.centerIn: parent
                                            Rectangle{
                                                width: 48
                                                height: 48
                                                radius: width/2
                                                color: {
                                                    if(toMonth){
                                                        if(control_delegate.pressed){
                                                            return Qt.lighter(control.backPrimaryColor,1.2)
                                                        }
                                                        if(control_delegate.hovered){
                                                            return Qt.lighter(control.backPrimaryColor,1.1)
                                                        }
                                                        return control.backPrimaryColor
                                                    }else{
                                                        if(control_delegate.pressed){
                                                            return control.backPressedColor
                                                        }
                                                        if(control_delegate.hovered){
                                                            return control.backHoverColor
                                                        }
                                                        return "transparent"
                                                    }
                                                }
                                                anchors.centerIn: parent
                                            }
                                            Text{
                                                text: new Date(layout_congrol.year,month).toLocaleString(Qt.locale(control.language), "MMMM")
                                                anchors.centerIn: parent
                                                opacity: {
                                                    if(layout_congrol.year === currentDateData.displayDate.getFullYear()){
                                                        return 1
                                                    }
                                                    if(control_delegate.hovered){
                                                        return 1
                                                    }
                                                    return 0.3
                                                }
                                                color: {
                                                    if(toMonth){
                                                        return control.fontPrimaryColor
                                                    }
                                                    if(control_delegate.pressed){
                                                        return control.fontPressedColor
                                                    }
                                                    if(control_delegate.hovered){
                                                        return Qt.lighter(control.fontHoverColor,1.1)
                                                    }
                                                    return control.fontNormolColor
                                                }
                                            }
                                            onClicked: {
                                                currentDateData.displayDate = new Date(layout_congrol.year,month)
                                                currentDateData.pageIndex = 0
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //日期界面
                    Component{
                        id:com_page_one
                        ColumnLayout  {
                            DayOfWeekRow {
                                id: dayOfWeekRow
                                locale: Qt.locale(control.language)
                                font: control.font
                                delegate: Label {
                                    text: model.shortName
                                    font: dayOfWeekRow.font
                                    color: Constants.fontGreyColor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Layout.column: 1
                                Layout.fillWidth: true
                            }
                            ListView{
                                id:listview
                                property bool isCompleted: false
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                highlightRangeMode: ListView.StrictlyEnforceRange
                                clip: true
                                boundsBehavior: ListView.StopAtBounds
                                spacing: 0
                                highlightMoveDuration: 100
                                currentIndex: -1
                                ScrollBar.vertical: ScrollBar{}
                                onCurrentIndexChanged:{
                                    if(isCompleted){
                                        var month = calender_model.monthAt(currentIndex)
                                        var year = calender_model.yearAt(currentIndex)
                                        currentDateData.displayDate = new Date(year,month,1)
                                    }
                                }
                                Component.onCompleted: {
                                    Qt.callLater(function() {
                                        listview.model = calender_model
                                        listview.highlightMoveDuration = 0
                                        //Qt.callLater(function() {
                                        listview.currentIndex  = calender_model.indexOf(currentDateData.displayDate)
                                        timer_delay.restart()
                                        isCompleted = true
                                        //})
                                    })
                                }
                                Timer{
                                    id:timer_delay
                                    interval: 100
                                    onTriggered: {
                                        listview.highlightMoveDuration = 100
                                    }
                                }
                                Connections{
                                    target: currentDateData
                                    function onNextButton(){
                                        listview.currentIndex = Math.min(listview.currentIndex+1,listview.count-1)
                                    }
                                    function onPreviousButton(){
                                        listview.currentIndex = Math.max(listview.currentIndex-1,0)
                                    }
                                }
                                delegate: MonthGrid {
                                    id: grid
                                    width: listview.width - 6
                                    height: listview.height
                                    month: model.month
                                    year: model.year
                                    spacing: 0
                                    locale: Qt.locale(control.language)
                                    delegate: HcControl {
                                        required property bool today
                                        required property int year
                                        required property int month
                                        required property int day
                                        required property int visibleMonth
                                        id: control_delegate
                                        visibleMonth: grid.month
                                        implicitHeight: 40
                                        implicitWidth: 40
                                        Rectangle{
                                            width: 34
                                            height: 34
                                            radius: width/2
                                            color: {
                                                var current = new Date(year, month, day);
                                                var currentTime = current.getTime();
                                                var start = control.startDate ? control.startDate.getTime() : null;
                                                var end = control.endDate ? control.endDate.getTime() : null;

                                                if (currentTime === start || currentTime === end) {
                                                    return control.backPrimaryColor;
                                                }
                                                if (start && !end) {
                                                    if (currentTime === start || control_delegate.hovered) {
                                                        return control.backPrimaryColor;
                                                    }
                                                    return control.backNormolColor;
                                                }
                                                if (start && end && currentTime > start && currentTime < end) {
                                                    return control.backHoverColor;
                                                }
                                                return control.backNormolColor;
                                            }
                                            anchors.centerIn: parent
                                        }
                                        //当前选中天数背景
                                        Rectangle{
                                            width: 40
                                            height: 40
                                            border.width: 1
                                            anchors.centerIn: parent
                                            radius: width/2
                                            border.color: "#5F9FD0"
                                            color: "transparent"
                                            visible: {
                                                if (control.startDate || control.endDate) {
                                                    var startY = control.startDate ? control.startDate.getFullYear() : null;
                                                    var startM = control.startDate ? control.startDate.getMonth() : null;
                                                    var startD = control.startDate ? control.startDate.getDate() : null;

                                                    var endY = control.endDate ? control.endDate.getFullYear() : null;
                                                    var endM = control.endDate ? control.endDate.getMonth() : null;
                                                    var endD = control.endDate ? control.endDate.getDate() : null;

                                                    return (year === startY && month === startM && day === startD) ||
                                                            (year === endY && month === endM && day === endD);
                                                }
                                                return false;
                                            }
                                        }
                                        Text{
                                            text: day
                                            opacity: {
                                                if(month === grid.month){
                                                    return 1
                                                }
                                                if(control_delegate.hovered){
                                                    return 1
                                                }
                                                return 0.3
                                            }
                                            anchors.centerIn: parent
                                            color: {
                                                if(today){
                                                    return control.fontPrimaryColor
                                                }
                                                if(control_delegate.pressed){
                                                    return control.fontPressedColor
                                                }
                                                if(control_delegate.hovered){
                                                    return Qt.lighter(control.fontPrimaryColor,1.1)
                                                }
                                                return control.fontNormolColor
                                            }
                                        }
                                        onClicked: {
                                            control.current = new Date(year, month, day);
                                            control.accepted();
                                            if (control.startDate && control.endDate) {
                                                control.startDate = null;
                                                control.endDate = null;
                                            }
                                            if (!control.startDate) {
                                                control.startDate = control.current;
                                            } else {
                                                if (control.current < control.startDate) {
                                                    control.endDate = control.startDate;
                                                    control.startDate = control.current;
                                                } else {
                                                    control.endDate = control.current;
                                                }
                                            }
                                            if (control.endDate) {
                                                popup.close();
                                            }
                                            var current = new Date(year, month, day);
                                        }
                                    }
                                    background: Item {
                                        x: grid.leftPadding
                                        y: grid.topPadding
                                        width: grid.availableWidth
                                        height: grid.availableHeight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function close() {
        popup.close()
    }
    function open() {
        popup.showPopup()
    }
}
