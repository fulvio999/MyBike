import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/*
  Application help page
*/
Column{
    id: manageSavedGigsUrl
    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)

    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(3)
    }

    TextArea {
          width: parent.width
          height: parent.height
          readOnly: true
          autoSize: true
          placeholderText: i18n.tr("This App uses API of")+": "+"<b>"+"https://citybik.es/"+"</b> "+i18n.tr("(Thanks)")+
                           "<br/>"+i18n.tr("to get info about registered Bike networks around the world.")+
                           "<br/>"+i18n.tr("Only the networks managed by 'citybik.es' are supported;")+
                           "<br/><br/>"+i18n.tr("In case of a network will be added by 'citybik.es' it will be available in the App")+","+
                           "<br/>"+i18n.tr("No updates of the App are necessary")+"."+
                           "<br/>"+i18n.tr("To contribute at citybik, see: ")+"<b><br/>"+"https://github.com/eskerda/pybikes"+"</b>"+
                           "<br/><br/><b>"+i18n.tr("Note 1: to see Map Page is necessary an active internet connection")+"</b>"+
                           "<br/><br/><b>"+i18n.tr("Note 2: Field 'Last check time' is UTC format")+"</b>"
      }

}
