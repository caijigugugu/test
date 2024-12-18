import QtQuick
import QtQuick.Controls
import HcControls

HcTextBox{
    property var items:[]
    property string emptyText: qsTr("No results found")
    property int autoSuggestBoxReplacement: HcIcons.Search
    property string textRole: "title"
    property var filter: function(item){
        if(item.title.indexOf(control.text)!==-1){
            return true
        }
        return false
    }
    signal itemClicked(var data)
    id:control
    Component.onCompleted: {
        d.loadData()
    }
    Item{
        id:d
        property bool flagVisible: true
        property var window : Window.window
        function handleClick(modelData){
            control_popup.visible = false
            control.itemClicked(modelData)
            control.updateText(modelData[textRole])
        }
        function loadData(){
            var result = []
            if(items==null){
                list_view.model = result
                return
            }
            items.map(function(item){
                if(control.filter(item)){
                    result.push(item)
                }
            })
            list_view.model = result
        }
    }
    onActiveFocusChanged: {
        if(!activeFocus){
            control_popup.visible = false
        }
    }
    Popup{
        id:control_popup
        focus: false
        padding: 0
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: HcTheme.animationEnabled ? 83 : 0
            }
        }
        contentItem: HcClip{
            radius: [5,5,5,5]
            ListView{
                id: list_view
                anchors.fill: parent
                clip: true
                boundsBehavior: ListView.StopAtBounds
                ScrollBar.vertical: HcScrollBar {}
                header: Item{
                    width: control.width
                    height: visible ? 38 : 0
                    visible: list_view.count === 0
                    HcText{
                        text: emptyText
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }
                }
                delegate:HcControl{
                    id: item_control
                    height: 38
                    width: control.width
                    onClicked: {
                        d.handleClick(modelData)
                    }
                    background: Rectangle{
                        HcFocusRectangle{
                            visible: item_control.activeFocus
                            radius:4
                        }
                        color:  {
                            if(pressed){
                                return HcTheme.itemPressColor
                            }
                            if(hovered){
                                return HcTheme.itemHoverColor
                            }
                            return HcTheme.itemNormalColor
                        }
                    }
                    contentItem: HcText{
                        text: modelData[textRole]
                        leftPadding: 10
                        rightPadding: 10
                        verticalAlignment : Qt.AlignVCenter
                    }
                }
            }
        }
        background:Rectangle{
            id: rect_background
            implicitWidth: control.width
            implicitHeight: 38*Math.min(Math.max(list_view.count,1),8)
            radius: 5
            color: HcTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(1,1,1,1)
            border.color: HcTheme.dark ? Qt.rgba(26/255,26/255,26/255,1) : Qt.rgba(191/255,191/255,191/255,1)
            HcShadow{
                radius: 5
            }
        }
    }
    onTextChanged: {
        d.loadData()
        if(d.flagVisible){
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+rect_background.implicitHeight){
                control_popup.y = Qt.binding(function(){return control.height})
            } else if(pos.y>rect_background.implicitHeight){
                control_popup.y = -rect_background.implicitHeight
            } else {
                control_popup.y = d.window.height-(pos.y+rect_background.implicitHeight) - 1
            }
            control_popup.visible = true
        }
    }
    function updateText(text){
        d.flagVisible = false
        control.text = text
        d.flagVisible = true
    }
}
