import QtQuick 2.6

ListModel {
    id: weidenModel

    property var data: []
    property bool ready: false
    property var directions: [ "N"
        ,"NNO"
        ,"NO"
        ,"ONO"
        ,"O"
        ,"OSO"
        ,"SO"
        ,"SSO"
        ,"S"
        ,"SSW"
        ,"SW"
        ,"WSW"
        ,"W"
        ,"WNW"
        ,"NW"
        ,"NNW"
    ]
    property var windRose: []
    property real maxSpeed: 20
    property real maxGusts: 30

    property string source: (settings.localData ?
                                 "weatherstat_kn.html" :
                                 "http://www.yachtfinder.info/wx/wx001/weatherstat_kn.html"
                             )
    onSourceChanged: request();


    function parseSite(site) {
        var rows = site.split("<tr style");
        var data = [];
        var patterns = [/\d{2}\/\d{2}\/\d{4}/   //date
                        ,/\d{2}:\d{2}/          //time
                        ,/[SNWO]{1,3}/          //direction
                        ,/\d+\.\d{1}/           //digit
                ];
        var us = Qt.locale("en_US");

        maxSpeed = 0; maxGusts = 0;
        clear();

        for (var i = 0; i < rows.length; i++) {
            var cells = rows[i].split("<td style");
            if (cells.length === 12) {
                data[i] = [cells[1].match(patterns[0]).toString()
                           ,cells[2].match(patterns[1]).toString()
                           ,cells[3].match(patterns[2]).toString()
                           ,Number(cells[5].match(patterns[3]).toString())
                           ,Number(cells[7].match(patterns[3]).toString())
                           ,cells[8].match(patterns[3]).toString()
                           ,cells[9].match(patterns[3]).toString()
                        ];
                weidenModel.append({"date": data[i][0]
                                       ,"time": data[i][1]
                                       ,"direction": data[i][2]
                                       ,"speed":data[i][3]
                                       ,"gusts":data[i][4]
                                       ,"temperature":data[i][5]
                                       ,"windchill":data[i][6]
                                   });
                //                console.log(weidenModel.directions.indexOf(data[i][2]),Math.floor((data[i][3]/5)))

                var s = data[i][3];
                if (s > maxSpeed) maxSpeed = s;
                var sIndex = Math.floor((s/5));
                var g = data[i][4];
                if (g > maxGusts) maxGusts = g;
                var gIndex = Math.floor((g/5));
                var d = data[i][2];
                var dIndex = weidenModel.directions.indexOf(d);

                if (windRose[d] === undefined)
                    windRose[d] = {
                        "speeds": []
                        ,"gusts": []
                        ,"average": 0
                    };

                var sum = windRose[d].speeds.reduce(function (a,b,i) {
                    if (i>0)
                        return a + b;
                    else return 0;
                }, 0);
                //                console.log(d, sum);

                windRose[d].average = (windRose[d].average * sum + s)/(sum + 1);

                if (windRose[d].speeds[sIndex] === undefined)
                    windRose[d].speeds[sIndex] = 1;
                else
                    windRose[d].speeds[sIndex] += 1;


                if (windRose[d].gusts[gIndex] === undefined)
                    windRose[d].gusts[gIndex] = 1;
                else
                    windRose[d].gusts[gIndex] += 1;
            }
        }
        //        for (var i in windRose){
        //            console.log("windRose",i,windRose[i].speeds,windRose[i].gusts,windRose[i].average);
        //        }

        weidenModel.data = data;
        ready = true;
    }

    function request() {
        console.log("requesting");
        if (settings.autoUpdate) reloadTimer.restart();

        ready = false;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var utfstring = unescape(encodeURIComponent(doc.responseText));
                parseSite(utfstring)
            }
        }

        doc.open("GET", source, false);
        doc.setRequestHeader('Content-type', 'text/html;charset=ISO-8859-1')
        doc.send();
    }

    Component.onCompleted: {
        request();
    }
}
