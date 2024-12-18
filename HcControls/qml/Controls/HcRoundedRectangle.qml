import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
//自定义圆角矩形，可设置渐变色和边框
Item {
    property var radius: [0, 0, 0, 0]
    property alias color: container.color
    property alias gradient: container.gradient
    property color borderColor
    property int borderWidth: 0
    id:control

    Rectangle {
        id: container
        width: control.width
        height: control.height
        opacity: 0
    }

    // 用于创建圆角的遮罩
    Canvas {
        id: canvas
        anchors.fill: parent
        visible: false
        onPaint: {
            var ctx = getContext("2d");
            var x = 0;
            var y = 0;
            var w = control.width;
            var h = control.height;
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.save();
            ctx.beginPath();
            ctx.moveTo(x + radius[0], y);
            ctx.lineTo(x + w - radius[1], y);
            ctx.arcTo(x + w, y, x + w, y + radius[1], radius[1]);
            ctx.lineTo(x + w, y + h - radius[2]);
            ctx.arcTo(x + w, y + h, x + w - radius[2], y + h, radius[2]);
            ctx.lineTo(x + radius[3], y + h);
            ctx.arcTo(x, y + h, x, y + h - radius[3], radius[3]);
            ctx.lineTo(x, y + radius[0]);
            ctx.arcTo(x, y, x + radius[0], y, radius[0]);
            ctx.closePath();
            ctx.fillStyle = control.gradient || control.color;
            ctx.fill();
            ctx.restore();
        }
    }

    OpacityMask {
        anchors.fill: container
        source: container
        maskSource: canvas
    }

    // 边框绘制的 Canvas，确保在 OpacityMask 之上
    Canvas {
        id: borderCanvas
        anchors.fill: parent
        onPaint: {
            if(borderWidth > 0) {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, borderCanvas.width, borderCanvas.height);

                // 绘制边框
                ctx.lineWidth = borderWidth;
                ctx.strokeStyle = borderColor;
                ctx.beginPath();
                ctx.moveTo(radius[0], 0);
                ctx.lineTo(borderCanvas.width - radius[1], 0);
                ctx.arcTo(borderCanvas.width, 0, borderCanvas.width, radius[1], radius[1]);
                ctx.lineTo(borderCanvas.width, borderCanvas.height - radius[2]);
                ctx.arcTo(borderCanvas.width, borderCanvas.height, borderCanvas.width - radius[2], borderCanvas.height, radius[2]);
                ctx.lineTo(radius[3], borderCanvas.height);
                ctx.arcTo(0, borderCanvas.height, 0, borderCanvas.height - radius[3], radius[3]);
                ctx.lineTo(0, radius[0]);
                ctx.arcTo(0, 0, radius[0], 0, radius[0]);
                ctx.closePath();
                ctx.stroke();
            }
        }
    }
}
