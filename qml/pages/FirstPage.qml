import QtQuick 2.6
import Sailfish.Silica 1.0
import "../share"

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Reload")
                onClicked: weidenModel.request();
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Weiden am See")
            }
            WindTrendChart {
                id: chart
                x: Theme.horizontalPageMargin
                width: column.width - 2*x
                height: width/2
                markerPos: -timeSlider.value
            }
            Connections {
                target: weidenModel
                onReadyChanged: {
                    if (weidenModel.ready) {
                        chart.requestPaint();
                        windRose.requestPaint();
                        timeSlider.value = 0;
                    }
                }
            }

            Slider {
                id: timeSlider
                x: Theme.horizontalPageMargin
                width: column.width - 2*x
                //                anchors.horizontalCenter: chart.horizontalCenter
                minimumValue: weidenModel.ready ? -(weidenModel.count-1) : -1
                maximumValue: 0
                stepSize: 1
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
                                      weidenModel.get(-timeSlider.value).direction) : 0
                    Behavior on rotation { PropertyAnimation {} }
                }

                Column {
                    id: detailColumn
                    width: parent.width
                    DetailItem {
                        label: qsTr("Date")
                        value: {
                            if (weidenModel.ready)
                                weidenModel.get(-timeSlider.value).date
                            else "-"
                        }
                    }
                    DetailItem {
                        label: qsTr("Time")
                        value: (weidenModel.ready ?
                                weidenModel.get(-timeSlider.value).time : "-")
                    }
                    DetailItem {
                        label: qsTr("Windspeed/Gusts")
                        value: {
                            (weidenModel.ready ?
                                weidenModel.get(-timeSlider.value).speed.toString() + " kn" : "-")
                                    + " / " + (weidenModel.ready ?
                                        weidenModel.get(-timeSlider.value).gusts.toString() + " kn" : "-")
                        }
                    }
                    DetailItem {
                        label: qsTr("Direction")
                        value: (weidenModel.ready ?
                                weidenModel.get(-timeSlider.value).direction : "-")
                    }
                }
            }
            SectionHeader {
                text: qsTr("Windrose")
            }

            WindRose {
                id: windRose
                x: Theme.horizontalPageMargin
                width: column.width - 2*x
                height: width
            }
        }
    }
    onStatusChanged: {
        console.log(status);
        if (status === PageStatus.Active) {
            chart.requestPaint();
            windRose.requestPaint();
        }
    }
}
