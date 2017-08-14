import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.configuration 1.0

import "pages"
import "share"

ApplicationWindow
{
    id: root
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    WeidenModel {
        id: weidenModel
    }

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-weidenMonitor/settings"
        property bool localData: false
        property bool autoUpdate: true
    }

    Timer {
        id: reloadTimer
        interval: 60*2*1000
        running: settings.autoUpdate
        onTriggered: weidenModel.request();
    }
}

