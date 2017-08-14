import QtQuick 2.6

Canvas {
    id: canvas
    width: 320
    height: width*0.7

    property real chartMargin: 50
    property real chartHeight: canvas.height-2*chartMargin
    property real chartWidth: canvas.width-2*chartMargin
    property real maxSpeed: weidenModel.maxSpeed

    property int knStep: 5
    property int knMax: Math.floor(maxSpeed/knStep)*knStep + 2*knStep
    property real knScale: chartHeight/knMax

    property int timeStep: 120
    property int timeMax: weidenModel.count
    property real timeScale: chartWidth/timeMax

    property int markerPos: 0
    property alias markerVisible: marker.visible

    property bool fillBack: true
    property string textColor: "black"
    property bool textVisible: true

    function drawBackground(ctx) {
        ctx.save();
        ctx.fillStyle = "#ffffff";
        if (fillBack) ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = "#d7d7d7";
        ctx.beginPath();

        ctx.translate(chartMargin, canvas.height-chartMargin)

        // Horizontal grid lines
        ctx.fillStyle = textColor;
        ctx.font = "10px Arial"
        ctx.textBaseline = "middle";
        ctx.textAlign = "center";
        for (var i = 0; i <= knMax; i += knStep) {
            ctx.beginPath();
            ctx.moveTo(0, -i*knScale);
            ctx.lineTo(chartWidth, -i*knScale);
            ctx.stroke();

            if (textVisible)  ctx.fillText(i, -chartMargin/2, -i*knScale);
        }

        // Vertical grid lines
        for (var i = 0; i <= timeMax; i += timeStep) {
            ctx.beginPath();
            ctx.moveTo(i*timeScale, 0);
            ctx.lineTo(i*timeScale, -chartHeight);
            ctx.stroke();

            if (textVisible) ctx.fillText(i, i*timeScale, chartMargin/2);
        }

        ctx.restore();
    }

    function drawGraphs(ctx) {
        ctx.save();
        ctx.lineWidth = 0.5;
        ctx.beginPath();

        ctx.translate(chartMargin + chartWidth, canvas.height-chartMargin)

        ctx.strokeStyle = "blue";
        var i = weidenModel.count-1;
        ctx.moveTo(-i*timeScale, -weidenModel.get(i).gusts*knScale);
        for (; i >= 0; i--) {
            ctx.lineTo(-i*timeScale, -weidenModel.get(i).gusts*knScale);
        }
        ctx.stroke();

        ctx.strokeStyle = "green";
        var i = weidenModel.count-1;
        ctx.moveTo(-i*timeScale, -weidenModel.get(i).speed*knScale);
        for (; i >= 0; i--) {
            ctx.lineTo(-i*timeScale, -weidenModel.get(i).speed*knScale);
        }
        ctx.stroke();

        ctx.restore();
    }

    onPaint: {
        var ctx = canvas.getContext("2d");
        ctx.globalCompositeOperation = "source-over";
        ctx.lineWidth = 1;

        drawBackground(ctx);

        drawGraphs(ctx);

    }
    Rectangle {
        id: marker
        color: "red"
        x: chartMargin + chartWidth - markerPos*timeScale
        y: chartMargin
        height: chartHeight
        width: 1
        Rectangle {
            x: -width/2
            y: (weidenModel.ready ? parent.height - weidenModel.get(markerPos).speed*knScale : 0)
            width: 10
            height: width
            radius: width/2
            color: "green"
        }
        Rectangle {
            x: -width/2
            y: (weidenModel.ready ? parent.height - weidenModel.get(markerPos).gusts*knScale : 0)
            width: 10
            height: width
            radius: width/2
            color: "blue"
        }
    }
}

