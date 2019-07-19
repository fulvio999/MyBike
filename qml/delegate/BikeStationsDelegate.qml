import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3


/*
   Delegate component used to display a bike Network DETAILS (amount free slots, free bikes, latitude....)
*/
Item {
      id: bikeNetworkDetailsItem

      width: parent.width
      height: units.gu(15) /* heigth of the rectangle */
      visible: true;

      /* create a container for each item */
      Rectangle {
           id: background
           x: 2;y: 2;
           width: parent.width - x * 2;
           height: parent.height - y * 1
           /* to get the background color of the curreunt theme. Necessary if default theme is not used */
           color: theme.palette.normal.background
           border.color: "black"
           radius: 5
      }

      /* This mouse region covers the entire delegate */
      MouseArea {
            id: selectableMouseArea
            anchors.fill: parent
            onClicked: {
                /* move the highlight component to the currently selected item */
                bikeStationsListView.currentIndex = index
            }
      }

      /* create a row for each entry in the Model */
      Row {
            id: detailsTopLayout
            x: 10;y: 7;
            height: background.height;
            width: parent.width
            spacing: units.gu(2)

            /* Bike station info */
            Column {
                  id: bikeNetworkInfoColumn
                  width: detailsTopLayout.width - units.gu(10)
                  height: bikeNetworkDetailsItem.height
                  spacing: units.gu(0.2)

                  Label {
                        text: "<b>" + i18n.tr("Station") + ": </b>" + name
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Empty slots") + ": " + emptySlots
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Free bikes") + ": " + freeBikes
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Latitude") + ": " + latitude
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Longitude") + ": " + longitude
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Last check") + " (dd.mm.yyyy hh:mm): " + Qt.formatDateTime(timestamp, "dd.MM.yyyy hh:mm"); //timestamp
                        fontSize: "medium"
                  }
            }
      }
}
