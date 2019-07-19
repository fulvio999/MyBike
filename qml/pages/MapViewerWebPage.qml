import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
import Morph.Web 0.1
import QtWebEngine 1.7

import "../js/RestClient.js" as RestClient

/*
   WebView of page: https://citybik.es/ the online map viewer/searcher
*/
Page {
    id: mapViewerPage
    visible: false

    header: PageHeader {
        title: i18n.tr("Map page")
    }
   
    Column {
        id: manageClumn
        anchors.fill: parent
        spacing: units.gu(2)
        anchors.leftMargin: units.gu(0.5)
        anchors.topMargin: units.gu(8)

        WebContext {
            id: webcontext
            userAgent: "Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36"
        }

        WebView {
            id: webview
            anchors.fill: parent

            context: webcontext
            url: root.cityBikSiteUrl
        }
    }
}