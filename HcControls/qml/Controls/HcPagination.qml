import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: control
    width: Math.min(parent.width, 650)
    height: 50
    signal requestPage(int page, int count)
    //当前页码
    property int currentPage: 1        // 注意，从1开始开始计数
    //数据总数
    property int totalRecords: 30
    //单页数据条数
    property int recordsPerPage: 10
    //总页数
    property int pageCount: totalRecords % recordsPerPage === 0 ? totalRecords / recordsPerPage : totalRecords / recordsPerPage + 1
    property int pageHalfNumber: Math.floor(pageButtonCount / 2) + 1
    //文字颜色
    property color textColor: "#484848"
    property int fontSize: 14
    //按钮
    property int pageButtonCount: 5
    property string previousText: qsTr("<")
    property string nextText: qsTr(">")

    property color pressedColor: "#0066B4"
    property color hoverColor: "#ace0f6"
    property color enableColor: "#EFF3F4"
    property color disableColor: "#858585"
    property color borderColor: "#484848"
    property int borderWidth: 1
    property int btnWidth: 32
    property int btnHeight: 32
    //下拉框
    property int defaultIndex: 1 //默认选项索引
    property int comboBoxWidth: 120
    property var comboBoxModel: ListModel {
                    ListElement { text: qsTr("10条/页") }
                    ListElement { text: qsTr("15条/页") }
                    ListElement { text: qsTr("20条/页") }
                    ListElement { text: qsTr("50条/页") }
                    ListElement { text: qsTr("100条/页") }
                    ListElement { text: qsTr("200条/页") }
                }
    function calcNewPage(page) {
        if (!page)
            return
        let page_num = Number(page)
        if (page_num < 1 || page_num > control.pageCount || page_num === control.currentPage)
            return
        control.currentPage = page_num
        control.requestPage(page_num, control.recordsPerPage)
    }
    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        spacing: 16

        Row {
            spacing: 8

            Label {
                text: qsTr("共")
                height: control.btnHeight
                color: control.textColor
                font.pixelSize: control.fontSize
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: pageCount.toString()
                color: control.textColor
                font.pixelSize: control.fontSize
                height: control.btnHeight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
            Label {
                text: qsTr("页")
                height: control.btnHeight
                color: control.textColor
                font.pixelSize: control.fontSize
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }
            HcComboBox {
                id: _comboBox
                property bool isInitialized: false
                width: control.comboBoxWidth
                height: control.btnHeight
                focus: true
                editable: false
                anchors.verticalCenter: parent.verticalCenter
                currentIndex: control.defaultIndex
                model: control.comboBoxModel
                Component.onCompleted: {
                    _comboBox.currentIndex = defaultIndex >= _comboBox.model.count ? 0 : defaultIndex;
                    isInitialized = true;
                }
                onCurrentIndexChanged: {
                    var selectedText = _comboBox.model.get(_comboBox.currentIndex).text;
                    var selectedValue = parseInt(selectedText.match(/\d+/)[0]);
                    control.recordsPerPage = selectedValue
                    if (isInitialized) {
                        control.requestPage(control.currentPage, control.recordsPerPage)
                    }
                }

            }
            Component.onCompleted: {
            }
        }

        // 页码列表
        Row {
        id: content
        spacing: 10
        HcToggleButton {
            width: control.btnWidth
            height: control.btnHeight
            visible: control.pageCount > 1
            enabled: control.currentPage > 1
            text: control.previousText
            onClicked: {
                control.calcNewPage(control.currentPage - 1);
            }
        }
        Row {
            spacing: 5
            HcToggleButton {
                property int pageNumber: 1
                width: control.btnWidth
                height: control.btnHeight
                visible: control.pageCount > 0
                checked: pageNumber === control.currentPage
                text: String(pageNumber)
                onClicked: {
                    control.calcNewPage(pageNumber);
                }
            }
            Text {
                visible: (control.pageCount > control.pageButtonCount &&
                    control.currentPage > control.pageHalfNumber)
                text: qsTr("...")
                height: control.btnHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Repeater {
                id: button_repeator
                model: (control.pageCount < 2) ? 0 : (control.pageCount >= control.pageButtonCount) ? (control.pageButtonCount - 2) : (control.pageCount - 2)
                delegate: HcToggleButton {
                    property int  pageNumber: {
                        return (control.currentPage <= control.pageHalfNumber)
                            ? (2 + index)
                            : (control.pageCount - control.currentPage <= control.pageButtonCount - control.pageHalfNumber)
                                ? (control.pageCount - button_repeator.count + index)
                                : (control.currentPage + 2 + index - control.pageHalfNumber)
                    }
                    width: control.btnWidth
                    height: control.btnHeight
                    text: String(pageNumber)
                    checked: pageNumber === control.currentPage
                    onClicked: {
                        control.calcNewPage(pageNumber);
                    }
                }
            }
            Text {
                visible: (control.pageCount > control.pageButtonCount &&
                    control.pageCount - control.currentPage > control.pageButtonCount - control.pageHalfNumber)
                text: "..."
                height: control.btnHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

            }
            HcToggleButton {
                property int pageNumber: control.pageCount
                width: control.btnWidth
                height: control.btnHeight
                visible: control.pageCount > 1
                checked: pageNumber === control.currentPage
                text: String(pageNumber)
                onClicked: {
                    control.calcNewPage(pageNumber);
                }
            }
        }
        HcToggleButton {
            visible: control.pageCount > 1
            width: control.btnWidth
            height: control.btnHeight
            enabled: control.currentPage < control.pageCount
            text: control.nextText
            onClicked: {
                control.calcNewPage(control.currentPage + 1);
            }
        }
        }
    }
    onTotalRecordsChanged: {
        if (totalRecords % recordsPerPage === 0) {
            pageCount = totalRecords / recordsPerPage
        } else {
            pageCount = totalRecords / recordsPerPage + 1
        }

        if (currentPage > pageCount) {
            currentPage = currentPage - 1
            if (currentPage < 1) {
                currentPage = 1
            }
        }
    }
    onRecordsPerPageChanged: {
        if (totalRecords % recordsPerPage === 0) {
            pageCount = totalRecords / recordsPerPage
        } else {
            pageCount = totalRecords / recordsPerPage + 1
        }

        if (currentPage > pageCount) {
            currentPage = currentPage - 1
            if (currentPage < 1) {
                currentPage = 1
            }
        }
    }
 }
