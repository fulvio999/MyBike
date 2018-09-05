import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3



/* General info about the application */
Dialog {
       id: productInfoDialogue
       title: i18n.tr("Product Info")
       text: "MyBike: version "+root.appVersion+"<br> Author: fulvio <br>"+i18n.tr("Unofficial App for:")+" https://citybik.es/"

       Button {
           text: i18n.tr("Close")
           onClicked: PopupUtils.close(productInfoDialogue)
       }
}
