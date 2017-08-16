import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings")
            }

            TextSwitch {
                id: autoUpdateSwitch
                text: qsTr("Autoupdate")
                checked: settings.autoUpdate
                onClicked: settings.autoUpdate = checked;
            }

            TextSwitch {
                id: localDataSwitch
                text: qsTr("Load data from local file (just for developement).")
                checked: settings.localData
                onClicked: settings.localData = checked;
            }
        }
    }
}
