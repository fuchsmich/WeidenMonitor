import QtQuick 2.0
import Sailfish.Silica 1.0

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
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings")
            }

            TextSwitch {
                id: localDataSwitch
                text: qsTr("Load data from loacl file.")
                checked: settings.localData
                onClicked: settings.localData = checked;
            }
            TextSwitch {
                id: autoUpdateSwitch
                text: qsTr("Autoupdate")
                checked: settings.autoUpdate
                onClicked: settings.autoUpdate = checked;
            }
        }
    }
}
