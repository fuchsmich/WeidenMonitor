import QtQuick 2.0
import Sailfish.Silica 1.0
import "../share"

CoverBackground {
    Column {
        id: column
        anchors.fill: parent
        WindTrendChart {
            id: chart
            width: parent.width
            fillBack: false
            textVisible: false
            chartMargin: Theme.paddingSmall
            markerVisible: false
        }
        Connections {
            target: weidenModel
            onReadyChanged: {
                if (weidenModel.ready) {
                    chart.requestPaint();
                }
            }
        }
        Item {
            width: column.width
            height: detailColumn.height
            Image {
                source: "image://theme/icon-m-down"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                rotation: weidenModel.ready ?
                              22.5*weidenModel.directions.indexOf(
                                  weidenModel.get(0).direction) : 0
                Behavior on rotation { PropertyAnimation {} }
            }

            Column {
                id: detailColumn
                width: parent.width
                DetailItem {
                    label: qsTr("Time")
                    value: (weidenModel.ready ?
                                weidenModel.get(0).time : "-")
                }
                DetailItem {
                    label: qsTr("Wind")
                    value: {
                        (weidenModel.ready ?
                             weidenModel.get(0).speed.toString() + " kn" : "-")
                                + " / " + (weidenModel.ready ?
                                               weidenModel.get(0).gusts.toString() + " kn" : "-")
                    }
                }
                DetailItem {
                    label: qsTr("Dir.")
                    value: (weidenModel.ready ?
                                weidenModel.get(0).direction : "-")
                }
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: weidenModel.request();
        }

    //        CoverAction {
    //            iconSource: "image://theme/icon-cover-pause"
    //        }
    }
}

