import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: _pagination
    width: Math.min(parent.width, 650)
    height: 50
    //当前页码数
    property int currentPage: 1
    //数据总数
    property int totalRecords: 100
    //单页数据条数
    property int recordsPerPage: 15
    property int pageNumer: totalRecords % recordsPerPage === 0 ? totalRecords / recordsPerPage : totalRecords / recordsPerPage + 1
    property string invalidPrompt : qsTr("输入页码无效，请重新输入")

    property bool enablePopupMessage: false
    function popupMessage(pageIndex) {
        if (pageIndex >= 1 && pageIndex <= pageNumer) {
            currentPage = pageIndex
        } else {
            if(enablePopupMessage)
                _hcPopup.open()
        }
    }

    function getJumpToInputText() {
        _hcPopup.message = invalidPrompt
        popupMessage(parseInt(_jumpTo.text))
    }

    HcPopup {
        property string message: ""

        id: _hcPopup
        width: 400
        height: 240
        anchors.centerIn: parent
        modal: true
        headerFontSize: 18

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -_hcPopup.padding
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -10
            width: _hcPopup.width - 20
            text: _hcPopup.message
            font.pixelSize: 16
            color: Constants.fontGreyColor
            wrapMode: Text.Wrap
        }

        HcButton {
            width: 80
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            text: qsTr("确认")
            font.pixelSize: 14
            onClicked: _hcPopup.close()
        }
    }

    component PageButton: Rectangle{
        property bool enabledBtn: true
        property string text: ""

        id: _rect
        width: 32
        height: 32

        Text {
            text: _rect.text
            color: "#658080"
            font.pixelSize: 18
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (_rect.text === qsTr("<")) {
                    _hcPopup.message = qsTr("当前页是第一页，无法进入上一页")
                    popupMessage(currentPage - 1)
                } else {
                    _hcPopup.message = qsTr("当前页是最后一页，无法进入下一页")
                    popupMessage(currentPage + 1)
                }
            }
        }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        spacing: 16


        Row {
            spacing: 8

            PageButton {
                text: qsTr("<")
            }
            Rectangle {
                width: 66
                height: 32
                border.color: Constants.backBorder
                border.width: 1

                TextInput {
                    id: _jumpTo
                    width: parent.width -2
                    height: parent.height
                    text: _pagination.pageNumer === 0 ? 0 : _pagination.currentPage
                    color: "#658080"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    validator: IntValidator{bottom: 1; top: _pagination.pageNumer;}

                    Keys.onReturnPressed: getJumpToInputText()
                    Keys.onEnterPressed: getJumpToInputText()
                }
            }
            Row {
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    width: contentWidth
                    height: 32
                    text: qsTr("/")
                    color: "#658080"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: _pageNumberText
                    width: Math.max(20, contentWidth)
                    height: 32
                    text: _pagination.pageNumer
                    color: "#658080"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            PageButton {
                text: qsTr(">")
            }
        }
    }

    onTotalRecordsChanged: {
        if (totalRecords % recordsPerPage === 0) {
            pageNumer = totalRecords / recordsPerPage
        } else {
            pageNumer = totalRecords / recordsPerPage + 1
        }

        while (currentPage > pageNumer) {
            currentPage = pageNumer
            if (currentPage < 1) {
                currentPage = 1
                break
            }
        }
    }

    onPageNumerChanged: {
        _pageNumberText.text = pageNumer
    }
 }
