import QtQuick 2.8
import QtQuick.Window 2.2
import QtCharts 2.0
import QtQuick.Layouts 1.3

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")


    WeidenModel {
        id: weidenModel
        onReadyChanged: if (ready) chartView.parseWindData(this);
    }

    Column {
        anchors.fill: parent
        Rectangle {
            height: window.height/2
            width: parent.width

            ChartView {
                id: chartView
                anchors.fill: parent

                ValueAxis {
                    id: windSpeedAxis
                    min: 0
                    max: 30
                    titleText: "Windspeed [kn]"
                }

                ValueAxis {
                    id: timeAxis
                    min: 0
                    max: weidenModel.count
                    titleText: "Time"
                    tickCount: 24
                }

                LineSeries {
                    id: gustsSeries
                    axisX: timeAxis
                    axisY: windSpeedAxis
                    name: "Gusts"
                }

                LineSeries {
                    id: speedSeries
                    axisX: timeAxis
                    axisY: windSpeedAxis
                    name: "Windspeed"
                }

                function parseWindData(model) {
                    for (var i=0; i < model.count; i++) {
                        speedSeries.append(i, model.get(i).speed)
                        gustsSeries.append(i, model.get(i).gusts)
                    }
                }
            }
        }

        Rectangle {

            height: parent.height/4
            width: parent.width

            GridLayout {
                anchors.fill: parent
                Column {
                    Layout.minimumHeight: parent.height/2
                    Layout.minimumWidth: parent.width/2
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: weidenModel.ready ? weidenModel.get(0).date : ""
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: weidenModel.ready ? weidenModel.get(0).time : ""
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: weidenModel.ready ? weidenModel.get(0).temperature : ""
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: weidenModel.ready ? 22.5*weidenModel.directions.indexOf(weidenModel.get(0).direction) : ""
                    }
                }
                Rectangle {
                    Layout.minimumHeight: parent.height/2
                    Layout.minimumWidth: parent.width/2
                    Image {
                        anchors.fill: parent
                        source: "./Arrow.svg"
                        fillMode: Image.PreserveAspectFit
                        rotation: weidenModel.ready ? 22.5*weidenModel.directions.indexOf(weidenModel.get(0).direction) : ""
                    }
                }
//                Text {
//                    text: weidenModel.windRose
//                }
            }
        }


        ListView {
            height: parent.height/4
            width: window.width
            model: weidenModel
            delegate: Text {
                text: date + time + direction + speed + gusts + temperature + windchill
            }
        }
    }
}
