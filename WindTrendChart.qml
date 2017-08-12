import QtQuick 2.8

Rectangle {
    id: chart
    width: 320
    height: 200

    property ListModel windModel: ListModel {}
    property var maxWind: 30 //kn

    Canvas {
        id: canvas
        anchors.fill: parent

        function drawBackground(ctx) {
            ctx.save();
            ctx.fillStyle = "#ffffff";
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.strokeStyle = "#d7d7d7";
            ctx.beginPath();

            // Horizontal grid lines
            for (var i = 0; i < 12; i++) {
                ctx.moveTo(0, canvas.yGridOffset + i * canvas.yGridStep);
                ctx.lineTo(canvas.width, canvas.yGridOffset + i * canvas.yGridStep);
            }

            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }

        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 1;

            drawBackground(ctx);

        }
    }
}
