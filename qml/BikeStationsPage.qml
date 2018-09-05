import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import "RestClient.js" as RestClient

  /*
    bike Network STATIONS page
  */
  Column{
          id: networkDetailsColumn
          anchors.fill: parent
          spacing: units.gu(1)
          anchors.leftMargin: units.gu(2)
          height: parent.height;
          width: parent.width;

          /* placeholder */
          Rectangle {
              color: "transparent"
              width: parent.width
              height: units.gu(6)
          }

          Row{
              Label{
                 //anchors.horizontalCenter: parent.horizontalCenter
                 text: "<b>"+i18n.tr("Bike network")+":  </b>"+bikeStationsPage.networkId
              }
          }

          Row{
              Label{
                 text: "<b>"+i18n.tr("City")+":  </b>"+bikeStationsPage.city
              }
          }

          Row{
               Label{
                    id:bikeNetworksAmountStationsLabel
                    text: "<b>"+i18n.tr("Stations")+":  </b>"+bikeStationsListView.count
               }
         }

         Row{
            anchors.horizontalCenter: parent.horizontalCenter

            TextField{
                 id:filterByStationNameField
                 placeholderText: i18n.tr("filter by station name")
                 width: units.gu(25)
                 onTextChanged:{

                     if(text.length > 0 ) /* do filter */
                     {
                         /* flag "i" = ignore case */
                         sortedBikeStationsListModel.filter.pattern = new RegExp(filterByStationNameField.text, "i")
                         sortedBikeStationsListModel.sort.order = Qt.AscendingOrder
                         sortedBikeStationsListModel.sortCaseSensitivity = Qt.CaseSensitive

                         /* filter by station name */
                         sortedBikeStationsListModel.sort.property = "name"
                         sortedBikeStationsListModel.filter.property = "name"

                     } else { /* show all stations */
                          sortedBikeStationsListModel.filter.pattern = /./
                          sortedBikeStationsListModel.sort.order = Qt.AscendingOrder
                          sortedBikeStationsListModel.sortCaseSensitivity = Qt.CaseSensitive
                     }
                }
             }

         }
   }
