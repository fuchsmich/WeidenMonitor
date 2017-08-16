import QtQuick 2.0

Canvas {
    id: canvas

    property real roseSize: Math.min(canvas.width, canvas.height)/2
    property real maxSpeed: weidenModel.maxSpeed
    property real knScale: (roseSize/2)/maxSpeed

    property var directions: [ qsTr("N")
        ,qsTr("NNE")
        ,qsTr("NE")
        ,qsTr("ENE")
        ,qsTr("E")
        ,qsTr("ESE")
        ,qsTr("SE")
        ,qsTr("SSE")
        ,qsTr("S")
        ,qsTr("SSW")
        ,qsTr("SW")
        ,qsTr("WSW")
        ,qsTr("W")
        ,qsTr("WNW")
        ,qsTr("NW")
        ,qsTr("NNW")
    ]

    property var colors: {
        "axis": "lightgrey",
                "speeds": "red",
                "gusts": "green"
    }

    function pol2cart(a, r) {
        var cart = { x: 0, y:0 };
        cart.x = Math.cos(a) * r;
        cart.y = Math.sin(a) * r;
        return cart;
    }

    function drawBackground(ctx) {
        ctx.save();
        ctx.fillStyle = "#ffffff";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = "#d7d7d7";
        ctx.beginPath();

        ctx.translate(canvas.width/2,canvas.height/2)

        //Axes
        for (var i=0; i < 4; i++) {
            ctx.moveTo(0,0);
            var c = pol2cart(Math.PI/2*i, 1.1*roseSize/2);
            ctx.lineTo(c.x, c.y);
        }
        ctx.stroke();

        //Circle Grid
        ctx.fillStyle="#000000";
        ctx.font = "10px Arial"
        ctx.textBaseline = "middle";
        ctx.textAlign = "center";
        var numGrids = Math.floor(maxSpeed/5) + 1
        for (var i=0; i < numGrids; i++) {
            ctx.beginPath();
            var r = (i+1)*5*knScale;
            ctx.arc(0, 0, r, 0, 2*Math.PI);
            if (i % 2 == 1) ctx.fillText((i+1)*5, r, 0);
            ctx.stroke();
        }


        // Himmelsrichtungen
        ctx.fillStyle="#000000";
        ctx.font = "10px Arial"
        ctx.textBaseline = "middle";
        ctx.textAlign = "center";
        for (var i=0; i < directions.length; i++) {
//                        if ( i % 8 == 0) ctx.textAlign = "center";
//                        else if (i < 8) ctx.textAlign = "left";
//                        else ctx.textAlign = "right";
            var c = pol2cart(Math.PI/8*i - Math.PI/2, 1.5*roseSize/2);
            ctx.fillText(directions[i],c.x, c.y);
        }

        ctx.restore();
    }

    function drawAverage(ctx) {
        ctx.save();

        ctx.translate(canvas.width/2,canvas.height/2)

        ctx.beginPath();
        ctx.strokeStyle = "red";
        for (var i=0; i < directions.length; i++) {
            var s  = (weidenModel.windRose[weidenModel.directions[i]] !== undefined ?
                          weidenModel.windRose[weidenModel.directions[i]].average : 0);
            var c = pol2cart(Math.PI/8*i - Math.PI/2, s*knScale);
            if (i == 0) ctx.moveTo(c.x, c.y);
            else ctx.lineTo(c.x, c.y);
        }
        ctx.closePath();
        ctx.stroke();

        ctx.restore();
    }

    function dir2rad(dir) {
        return Math.PI/8*weidenModel.directions.indexOf(dir) - Math.PI/2;
    }

    function drawCake(ctx, dir, kn, mag) {
        ctx.save();
        ctx.fillStyle = "green";
        ctx.strokeStyle = "black";

        ctx.translate(canvas.width/2,canvas.height/2)

        ctx.beginPath();
        var w = Math.PI/8*mag;
        var c = pol2cart(dir2rad(dir),kn*knScale);
        ctx.arc(0,0, kn*knScale, dir2rad(dir)-w/2, dir2rad(dir)+w/2);
        ctx.arc(0,0, (kn+5)*knScale, dir2rad(dir)+w/2, dir2rad(dir)-w/2,true);
        ctx.closePath();
        ctx.stroke();
        ctx.fill();
        ctx.restore();
    }

    function drawFrequencies(ctx) {
        var sumTot = 0;
        for (var d in weidenModel.windRose) {
            sumTot += weidenModel.windRose[d].speeds.reduce(function (a,b,i) {
                if (i>0)
                    return a + b;
                else return 0;
            }, 0);
        }
        for (var d in weidenModel.windRose) {
            weidenModel.windRose[d].speeds.forEach( function (value,index){
//                console.log(index, value)
                drawCake(ctx, d, index*5, value/sumTot);
            });
        }
    }

    onPaint: {
        var ctx = canvas.getContext("2d");
        ctx.globalCompositeOperation = "source-over";
        ctx.lineWidth = 1;

        drawBackground(ctx);

        drawFrequencies(ctx);

        drawAverage(ctx);
    }
}
