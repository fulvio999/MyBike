import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "RestClient.js" as RestClient

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mybike.fulvio'
    automaticOrientation: true

    property string appVersion : "1.0"

    //------------------ Config Param ---------
    property string cityBikBaseUrl : "http://api.citybik.es/v2/networks"
    property string cityBikSiteUrl : "https://citybik.es/"
    //-----------------------------------------

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
       ProductInfo{}
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
                 pageStack.push(mainPage);
             }

             Page {
                id: mainPage
                anchors.fill: parent

                header: PageHeader {
                    id: header
                    title: i18n.tr('MyBike')

                    /* the bar on the left side */
                    leadingActionBar.actions: [

                         Action {
                              id: aboutPopover
                              iconName: "info"
                              text: i18n.tr("About")
                              onTriggered:{
                                  PopupUtils.open(productInfo)
                              }
                         }
                     ]

                     /* the bar on the right side */
                     trailingActionBar.actions: [

                          Action {
                               iconName: "help"
                               text: i18n.tr("Help")
                               onTriggered:{
                                      pageStack.push(helpPage)
                              }
                          },

                          Action {
                               iconName: "map"
                               text: i18n.tr("Map")
                               iconSource: Qt.resolvedUrl("./graphics/map.png")
                               onTriggered:{
                                    pageStack.push(mapViewerPage)
                               }
                          }
                     ]
                }

                Component {
                    id: bikeNetworksDelegate
                    BikeNetworksDelegate{}
                }

                /* -------------Page Content -------------- */

                /* the list of ALL events form the chosen artist */
                ListModel{
                    id: bikeNetworksListModel
                }

                /* keep sorted the loaded gigs List */
                SortFilterModel {
                      id: sortedBikeNetworksModel
                      model: bikeNetworksListModel
                      sort.order: Qt.AscendingOrder
                      sortCaseSensitivity: Qt.CaseSensitive
                }

                /* The bikeNetworks list loaded cityBike */
                UbuntuListView {
                     id: bikeNetworksListView
                     anchors.fill: parent
                     anchors.topMargin: units.gu(30) /* amount of space from the above component */
                     model: sortedBikeNetworksModel
                     delegate: bikeNetworksDelegate

                     /* disable the dragging of the model list elements */
                     boundsBehavior: Flickable.StopAtBounds
                     highlight: HighlightNetworkComponent{}
                     focus: true
                     /* clip:true to prevent that UbuntuListView draw out of his assigned rectangle, default is false */
                     clip: true
               }

               Scrollbar {
                  flickableItem: bikeNetworksListView
                  align: Qt.AlignTrailing
               }

               Column{
                anchors.fill: parent
                spacing: units.gu(2)

                /* transparent placeholder: required to place the content under the header */
                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: units.gu(8)
                }

                Row {
                      id:filteredNetWorksRow
                      spacing: units.gu(3)
                      anchors.horizontalCenter: parent.horizontalCenter

                      Button{
                         id:showNetworksButton
                         text:i18n.tr("Show Networks")
                         enabled:true
                         width: filterByCityField.width //units.gu(18)
                         color: UbuntuColors.green
                         onClicked:{

                              loadingBikeNetworkListActivity.running = !loadingBikeNetworkListActivity.running /* start animation */

                              bikeNetworksListModel.clear();
                              var returnCode = RestClient.getAllNetworks(root.cityBikBaseUrl);

                              if (returnCode === -1){
                                  PopupUtils.open(noDataFoundComponent, showNetworksButton)
                                  loadingBikeNetworkListActivity.running = !loadingBikeNetworkListActivity.running  /* stop animation */
                              }else{
                                  loadingBikeNetworkListActivity.running = !loadingBikeNetworkListActivity.running  /* stop animation */
                                  filterByCityField.enabled = true;
                                  bikeNetworksFoundLabel.visible = true;
                              }
                          }
                      }
                }

                Row {
                      id:cityRow
                      spacing: units.gu(3)
                      anchors.horizontalCenter: parent.horizontalCenter

                      TextField{
                          id:filterByCityField
                          placeholderText: i18n.tr("filter by city")
                          width: units.gu(25)
                          enabled:false
                          onTextChanged:{

                             if(text.length > 0 ) /* do filter */
                             {
                                   /* flag "i" = ignore case */
                                   sortedBikeNetworksModel.filter.pattern = new RegExp(filterByCityField.text, "i")
                                   sortedBikeNetworksModel.sort.order = Qt.AscendingOrder
                                   sortedBikeNetworksModel.sortCaseSensitivity = Qt.CaseSensitive

                                  /* filter by eventCountry */
                                  sortedBikeNetworksModel.sort.property = "country"
                                  sortedBikeNetworksModel.filter.property = "city"

                             } else { /* show all byke Networks */
                                   sortedBikeNetworksModel.filter.pattern = /./
                                   sortedBikeNetworksModel.sort.order = Qt.AscendingOrder
                                   sortedBikeNetworksModel.sortCaseSensitivity = Qt.CaseSensitive
                             }
                         }
                    }
                }

                Row{
                    id: bikeNetworksFoundRow
                    anchors.horizontalCenter: parent.horizontalCenter

                    ActivityIndicator {
                        id: loadingBikeNetworkListActivity
                    }

                   Label{
                        id:bikeNetworksFoundLabel
                        visible:false
                        text: i18n.tr("Found")+" "+bikeNetworksListView.count +" "+i18n.tr("Bike Networks")
                   }
                }

             } //col

          }

          //------------------ Bike Stations page --------------
          Page {
              id: bikeStationsPage
              anchors.fill: parent
              visible: false

              header: PageHeader {
                 title: i18n.tr("Bike stations")
              }

              /* the city and id of the selected bike network */
              property string networkId;
              property string city;

              /* the Details of the selected bike network */
              ListModel{
                  id: bikeStationsListModel
              }

              Component {
                  id: bikeStationsDelegate
                  BikeStationsDelegate{}
              }

              onVisibleChanged: {
                  if(bikeStationsPage.visible) {
                     /* clean old values */
                     bikeStationsListModel.clear();
                     /* get bike network details */
                     RestClient.getNetworkInfo(root.cityBikBaseUrl,bikeStationsPage.networkId);
                  }
              }

              /* keep sorted the loaded gigs List */
              SortFilterModel {
                    id: sortedBikeStationsListModel
                    model: bikeStationsListModel
                    sort.order: Qt.AscendingOrder
                    sortCaseSensitivity: Qt.CaseSensitive
              }

              /* The bikeNetwork details */
              UbuntuListView {
                   id: bikeStationsListView
                   anchors.fill: parent
                   anchors.topMargin: units.gu(24) /* amount of space from the above component */
                   model: sortedBikeStationsListModel
                   delegate: bikeStationsDelegate

                   /* disable the dragging of the model list elements */
                   boundsBehavior: Flickable.StopAtBounds
                   highlight: HighlightStationComponent{}
                   focus: true
                   /* clip:true to prevent that UbuntuListView draw out of his assigned rectangle, default is false */
                   clip: true
              }

              Scrollbar {
                 flickableItem: bikeStationsListView
                 align: Qt.AlignTrailing
              }

              BikeStationsPage{}
          }

          //----------------- Application help page -----------------
          Page {
              id: helpPage
              visible: false

              header: PageHeader {
                 title: i18n.tr("Help page")
              }

              HelpPage{}
          }

          //----------------- citybik.es WebView page -----------------
          Page {
              id: mapViewerPage
              visible: false

              header: PageHeader {
                 title: i18n.tr("Map page")
              }

              CityBikWebViewePage{}
          }
     }
}
