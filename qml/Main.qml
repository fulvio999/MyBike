import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "./js/RestClient.js" as RestClient

/* import folders */
import "./pages"
import "./delegate"


/*
  Application Main page
*/
MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mybike.fulvio'
    automaticOrientation: true

    property string appVersion : "1.1"

    //------------------ Config Param ---------
    property string cityBikBaseUrl : "http://api.citybik.es/v2/networks"
    property string cityBikSiteUrl : "https://citybik.es/"
    //-----------------------------------------

    /* enable to test with dark theme */
    theme.name: "Ubuntu.Components.Themes.SuruDark"

    /*------- Tablet (width >= 110) -------- */
    //vertical
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal (rel)
    width: units.gu(100)
    height: units.gu(75)

    /* ----- phone 4.5 (the smallest one) ---- */
    //vertical
    //width: units.gu(50)
    //height: units.gu(96)

    //horizontal
    //width: units.gu(96)
    //height: units.gu(50)
    /* -------------------------------------- */

    Component {
       id: productInfo

       Dialog {
            id: productInfoDialogue
            title: i18n.tr("Product Info")
            text: "MyBike: "+i18n.tr("version")+" "+root.appVersion+"<br>"+i18n.tr("Author")+": fulvio <br>"+i18n.tr("Unofficial App for:")+" https://citybik.es/"

            Button {
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(productInfoDialogue)
            }
        }
    }

    Component {
        id:noDataFoundComponent
        Dialog {
            id: noDataFoundDialogue
            title: i18n.tr("Warning")
            text: i18n.tr("No data found")

            Button {
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(noDataFoundDialogue)
            }
        }
    }

    PageStack {
           id: pageStack

           /* set the firts page of the application */
           Component.onCompleted: {
                pageStack.push(Qt.resolvedUrl("./pages/SearchNetworkPage.qml"));
            }
    }

}
