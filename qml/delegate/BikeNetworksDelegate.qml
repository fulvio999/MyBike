import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

/* import folders */
import "../pages"

/*
   Delegate component used to display a bike Network information (country, cty, latitude....)
*/
Item {
      id: bikeNetworkItem

      width: mainPage.width
      height: units.gu(15) /* heigth of the rectangle */
      visible: true;

      /* create a container for each job */
      Rectangle {
            id: background
            x: 2;y: 2;width: parent.width - x * 2;height: parent.height - y * 1
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
                  bikeNetworksListView.currentIndex = index
            }
      }

      /* create a row for each entry in the Model */
      Row {
            id: topLayout
            x: 10;y: 7;
            height: background.height;
            width: parent.width
            spacing: units.gu(3)

            /* Network summary info */
            Column {
                  id: bikeNetworkInfo
                  width: topLayout.width - detailsColumn.width - units.gu(10)
                  height: bikeNetworkItem.height
                  spacing: units.gu(0.5)

                  Label {
                        text: i18n.tr("City") + ": " + city
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Country") + ": " + country
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Network Name") + ": " + networkName
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Latitude") + ": " + parseFloat(latitude).toFixed(3)
                        fontSize: "medium"
                  }

                  Label {
                        text: i18n.tr("Longitude") + ": " + parseFloat(longitude).toFixed(3)
                        fontSize: "medium"
                  }
            }

            /* Lens Icon Networks details */
            Column {
                  id: detailsColumn
                  width: units.gu(4);
                  height: bikeNetworkItem.height
                  spacing: units.gu(0.5)
                  anchors.verticalCenter: parent.verticalCenter
                  anchors.horizontalCenter: parent.Right

                  Image {
                        id: detailsImagee
                        source: Qt.resolvedUrl("../graphics/lens.png")
                        height: parent.height - units.gu(5) 
                        width: height - units.gu(5)
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                              width: detailsImagee.width
                              height: detailsImagee.height
                              onClicked: {

                                    /* pass the netkor id/name to get his details info */
                                    pageStack.push(Qt.resolvedUrl("../pages/BikeStationsPage.qml"), {
                                          /* <page-variable-name>:<property-value-to-pass> */
                                          networkId: networkId,
                                          city: city
                                    })

                                    /* move the highlight component to the currently selected item */
                                    bikeNetworksListView.currentIndex = index
                              }
                        }
                  }
            }
      }
}
