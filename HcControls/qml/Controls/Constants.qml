pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    enum FaultLevel { Undefined = 0, Warn, Error, Fatal }
    enum AlarmLevel{
        Alarm_Tip = 0, //提示
        Alarm_Warning, //警告
        Alarm_Error, //限制故障
        Alarm_Fatal, //停机级故障
        Alarm_UnKnown //未知错误
    }
    enum AlarmHandleOption{
        Handle_None = 0, //无操作 这时候界面仅显示确认按钮
        Handle_Skip = 0x01, //跳过
        Handle_Retry = 0x02, //重试
        Handle_Stop = 0x04 //停止
    }
    //卡片弹窗弹出位置
    enum PositionCorner{
        TopRight = 0,
        TopLeft,
        BottomRight,
        BottomLeft
    }
    enum DarkMode {
        System = 0x0000,
        Light = 0x0001,
        Dark = 0x0002
    }

    //使用桌面的窗口大小，只加载一次
    readonly property int width: Screen.width
    readonly property int height: Screen.height

    readonly property int buttonWidth: 80
    readonly property int buttonHeight: 35

    //用于配置全局颜色

    //全局主体色彩
    readonly property color globalBackground: "#f3f7fb"

    //组件主体背景色
    readonly property color bodyBackground: "#FFFFFF"

    //组件主体背景深色
    readonly property color bodyDeepBackground: "#212B2D"

    //组件标题框浅主题色
    readonly property color titleBackground: "#19CFDB"

    //组件标题框深主题色
    readonly property color titleDeepBackground: "#33494D"

    //组件黑色边框
    readonly property color backBorder: "#2E2F30"

    //节点按钮颜色
    readonly property color unclickedButtonColor: "#ffffff"

    //节点选中边缘样式
    readonly property color clickedButtonBorderColor: "#a0b9b9"

    //admin标签颜色
    readonly property Gradient adminHeadGradientColor: Gradient {
        orientation: Gradient.Horizontal

        GradientStop {
            position: 0
            color: "#00a2ac"
        }

        GradientStop {
            position: 0.48
            color: "#00b3bd"
        }

        GradientStop {
            position: 1
            color: "#009ea8"
        }
    }

    //弹窗组件标题渐变
    readonly property Gradient dialogHeadGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0
            color: "#19CFDB"
        }
        GradientStop {
            position: 1
            color: "#15C8D4"
        }
    }

    readonly property Gradient dialogHeadDeepGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0
            color: "#33494D"
        }
        GradientStop {
            position: 1
            color: "#33494D"
        }
    }

    readonly property color dialogHeadBorderColor: Qt.rgba(187/255, 187/255, 187/255, 0.35)
    //弹窗组件主体背景色
    readonly property color dialogBackground: "#FFFFFF"
    readonly property color dialogDeepBackground: "#212B2D"
    //卡片弹窗主体背景色
    readonly property color cardDlgBackColor: Qt.rgba(247/255, 247/255, 247/255, 0.8)
    readonly property color cardDlgBackDeepColor_Info: Qt.rgba(53/255, 53/255, 53/255, 0.8)
    readonly property color cardDlgBackDeepColor_Warning: Qt.rgba(81/255, 51/255 ,15/255 ,0.8)
    readonly property color cardDlgBackDeepColor_Error: Qt.rgba(55/255,2/255,2/255,0.8)

    //卡片弹窗描边颜色
    readonly property color cardDlgBorderColor: "#C4C4C4"
    readonly property color cardDlgBorderDeepColor_Info: "#16C1CE"
    readonly property color cardDlgBorderDeepColor_Warning: "#0479DF"
    readonly property color cardDlgBorderDeepColor_Error: "#FF1414"

    //卡片弹窗文本颜色
    readonly property color cardDlgTextColor_Info: "#5B5B5B"
    readonly property color cardDlgTextColor_Warning: "#D4790F"
    readonly property color cardDlgTextColor_Error: "#FF0000"
    readonly property color cardDlgTextDeepColor: "#FFFFFF"

    //卡片弹窗提示图标颜色
    readonly property color cardDlgIconColor_Info: "#09C9D7"
    readonly property color cardDlgIconColor_Warning: "#FA8C16"
    readonly property color cardDlgIconColor_Error: "#FF0000"
    readonly property color cardDlgIconDeepColor_Error: "#FF1414"

    //按钮正常垂直渐变
    readonly property Gradient buttonNormolGradient: Gradient {
        GradientStop {
            position: 0
            color: "#F9FBFB"
        }

        GradientStop {
            position: 1
            color: "#E6E6E6"
        }
        orientation: Gradient.Vertical
    }

    readonly property Gradient buttonNormolDeepGradient: Gradient {
        GradientStop {
            position: 0
            color: "#F0F0F0"
        }

        GradientStop {
            position: 1
            color: "#C1C1C1"
        }
        orientation: Gradient.Vertical
    }

    //按钮悬停垂直渐变
    readonly property Gradient buttonHoverGradient: Gradient {
        GradientStop {
            position: 0
            color: "#F9FBFB"
        }

        GradientStop {
            position: 1
            color: "#E6E6E6"
        }
        orientation: Gradient.Vertical
    }

    readonly property Gradient buttonHoverDeepGradient: Gradient {
        GradientStop {
            position: 0
            color: "#54C4BE"
        }

        GradientStop {
            position: 1
            color: "#309D96"
        }
        orientation: Gradient.Vertical
    }

    //按钮按下垂直渐变
    readonly property Gradient buttonPressedGradient: Gradient {
        GradientStop {
            position: 0
            color: "#54C4BE"
        }

        GradientStop {
            position: 1
            color: "#309D96"
        }
        orientation: Gradient.Vertical
    }

    readonly property Gradient buttonPressedDeepGradient: Gradient {
        GradientStop {
            position: 0
            color: "#4DB7B1"
        }

        GradientStop {
            position: 1
            color: "#28938D"
        }
        orientation: Gradient.Vertical
    }

    //按钮字体颜色
    readonly property color buttonFontNormolColor: "#333333"
    readonly property color buttonFontHoverColor: "#49B8B1"
    readonly property color buttonFontHoverDeepColor: "#FFFFFF"
    readonly property color buttonFontCheckedColor: "#FFFFFF"
    readonly property color buttonFontDisableColor: "#8C8C8C"

    //Icon按钮图标颜色,后续按照按钮级别升级改造
    readonly property color iconBtnNormolColor: "#4B5153"
    readonly property color iconBtnNormolDeepColor: "#658080"

    readonly property color iconBtnHoverColor: "#49B8B1"
    readonly property color iconBtnHoverDeepColor: "#FFFFFF"

    readonly property color iconBtnCheckedColor: "#FFFFFF"
    readonly property color iconBtnDisableColor: "#8C8C8C"

    //禁止时候
    readonly property Gradient buttonDisableGradient: Gradient {
        GradientStop {
            color: "#C1C1C1"
        }
        orientation: Gradient.Vertical
    }

    //Tab按钮正常垂直渐变
    readonly property Gradient tabBtnNormolGradient: Gradient {
        GradientStop {
            position: 0
            color: "#F9FBFB"
        }

        GradientStop {
            position: 1
            color: "#E6E6E6"
        }
        orientation: Gradient.Vertical
    }
    readonly property Gradient tabBtnNormolDeepGradient: Gradient {
        GradientStop {
            position: 0
            color: "#374040"
        }

        GradientStop {
            position: 1
            color: "#283030"
        }
        orientation: Gradient.Vertical
    }

    //Tab按钮按下垂直渐变
    readonly property Gradient tabBtnCheckedGradient: Gradient {
        GradientStop {
            color: "#FFFFFF"
        }

        orientation: Gradient.Vertical
    }
    readonly property Gradient tabBtnCheckedDeepGradient: Gradient {
        GradientStop {
            color: "#374246"
        }
        orientation: Gradient.Vertical
    }

    //Tab按钮字体颜色
    readonly property color tabBtnFontNormolColor: "#334849"
    readonly property color tabBtnFontNormolDeepColor: "#ACACAC"
    readonly property color tabBtnFontCheckedColor: "#0DB2BD"
    readonly property color tabBtnFontCheckedDeepColor: "#81D8D1"

    //Tab按钮边框颜色
    readonly property color tabBtnBorderNormolColor: "#CCDCDC"
    readonly property color tabBtnBorderNormolDeepColor: "#000000"

    readonly property color tabBtnBorderHighlightColor: "#0DB2BD"
    readonly property color tabBtnBorderHighlightDeepColor: "#81D8D1"

    //选择点击时候
    readonly property Gradient buttonClickedGradientColor: Gradient {
        GradientStop {
            position: 0
            color: "#61ced5"
        }

        GradientStop {
            position: 1
            color: "#61ced5"
        }
        orientation: Gradient.Vertical
    }

    //按下的时候
    readonly property Gradient buttonDownGradientColor: Gradient {
        GradientStop {
            position: 0
            color: "#61ced5"
        }

        GradientStop {
            position: 1
            color: "#61ced5"
        }
        orientation: Gradient.Vertical
    }

    //没有点击时候
    readonly property Gradient buttonUnClickedGradientColor: Gradient {
        GradientStop {
            position: 0
            color: "#f9fbfb"
        }

        GradientStop {
            position: 1
            color: "#d8e2e3"
        }
        orientation: Gradient.Vertical
    }

    //组件灰色边框
    readonly property color greyBorder: "#636363"

    //字体白色
    readonly property color fontGreyColor: "#484848"

    //字体颜色（浅色）
    readonly property color fontLightColor: "#bdbec0"
    //字体颜色（淡色）
    readonly property color fontColor: "#5B5B5B"
    //字体黑色
    readonly property color fontBackColor: "#000000"

    //字体白色
    readonly property color fontWhiteColor: "#ffffff"

    //选中后字体颜色
    readonly property color clickedFontLightColor: "#008a8a"

    //stack字体选中颜色
    readonly property color stackClickedFontColor: "#ffffff"

    //stack悬停颜色
    readonly property color stackHoverdColor: "#aae2e8"

    //stack选中后颜色
    readonly property color stackClickedColor: "#61ced5"

    //表格中头的边缘
    readonly property color tableHeadBorderColor: "#455f5f"

    //表格中头背景色
    readonly property color tableHeadbgColor: "#dbf1f5"

    //表格背景色
    readonly property color tableItemBgColor: "#ebf8f9"

    //表格中间隔背景色
    readonly property color tableItemIntervalBgColor: "#ffffff"



    //textBox文本输入框
    //选中文本背景色
    readonly property color selectionColor: "#3367D1"
    readonly property color selectionDeepColor: "#3367D1"
    //输入框文本色
    readonly property color normalColor: "#484848"
    readonly property color normalDeepColor: "#484848"

    readonly property color disableColor: "#484848"
    readonly property color disableDeepColor: "#484848"

    //输入框提示文本颜色
    readonly property color placeholderNormalColor: "#D5D5D5"
    readonly property color placeholderNormalDeepColor: "#D5D5D5"

    readonly property color placeholderDisableColor: "#D5D5D5"
    readonly property color placeholderDisableDeepColor: "#D5D5D5"

    readonly property color placeholderFocusColor: "#D5D5D5"
    readonly property color placeholderFocusDeepColor: "#D5D5D5"
    //输入框图标颜色
    readonly property color textIconColor: "#616161"
    readonly property color textIconDeepColor: "#dedede"

    //输入框背景色
    readonly property color bgNormalColor: "#FFFFFF"
    readonly property color bgNormalDeepColor: "#FFFFFF"

    readonly property color bgDisableColor: "#F0F0F0"
    readonly property color bgDisableDeepColor: "#F0F0F0"

    //输入框边框色
    readonly property color borderNormalColor: "#A9B6B7"
    readonly property color borderNormalDeepColor: "#A9B6B7"

    readonly property color borderFocusColor: "#07D1FD"
    readonly property color borderFocusDeepColor: "#07D1FD"

    //温度组件
    //组件标题栏背景色
    readonly property Gradient tempHeadGradient:  Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0
            color: "#FAFCFC"
        }
        GradientStop {
            position: 1
            color: "#E5E6E6"
        }
    }
    readonly property Gradient tempDeepHeadGradient:  Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0
            color: "#374246"
        }
        GradientStop {
            position: 1
            color: "#374246"
        }
    }

    //组件框架主题色
    readonly property color tempFrameBackground: "#FFFFFF"
    readonly property color tempFrameDeepBackground: "#535353"

    //组件阶段背景色
    readonly property color tempStageBackground: "#FDFDFD"
    readonly property color tempStageDeepBackground: "#5E5E5E"

    //组件主要颜色（pcr步骤背景色，温度曲线背景色）
    readonly property color tempMainBackground: "#E2EAEA"
    readonly property color tempMainDeepBackground: "#2D3131"

    //pcr温度填充颜色
    readonly property color tempfillColor: Qt.rgba(13/255, 190/255, 204/255, 0.16)
    readonly property color tempfillDeepColor: Qt.rgba(13/255, 190/255, 204/255, 0.16)

    //logo标题栏
    readonly property Gradient headerRecGradient: Gradient {
        orientation: Gradient.Horizontal

        GradientStop {
            position: 0
            color: Qt.rgba(0/255, 156/255, 166/255, 0.83)//"#009ca6"
        }

        GradientStop {
            position: 1
            color: Qt.rgba(0/255, 200/255, 215/255, 0.83)//"#00c8d7"
        }
    }

}
