import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* import folders */
import "../delegate"

import "../js/RestClient.js" as RestClient

/*
  bike Network STATIONS page
*/
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
    ListModel {
        id: bikeStationsListModel
    }

    Component {
        id: bikeStationsDelegate
        BikeStationsDelegate {}
    }

    onVisibleChanged: {
        if (bikeStationsPage.visible) {
            /* clean old values */
            bikeStationsListModel.clear();
            /* get bike network details */
            RestClient.getNetworkInfo(root.cityBikBaseUrl, bikeStationsPage.networkId);
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
        highlight:
               /* highlightComponent for the selected Bike STATION  */
               Component {
                    id: highlightStationComponent

                    Rectangle {
                        width: 180; height: 44
                        color: "green";
                        radius: 2
                        /* move the Rectangle on the currently selected List item with the keyboard */
                        y: bikeStationsListView.currentItem.y

                        /* show an animation on change ListItem selection */
                        Behavior on y {
                            SpringAnimation {
                                spring: 0 /* no oscillation on item selected */
                                damping: 0.1
                            }
                        }
                   }
               }

        focus: true
        /* clip:true to prevent that UbuntuListView draw out of his assigned rectangle, default is false */
        clip: true
    }

    Scrollbar {
        flickableItem: bikeStationsListView
        align: Qt.AlignTrailing
    }


    Column {
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

        Row {
            Label {
                //anchors.horizontalCenter: parent.horizontalCenter
                text: "<b>" + i18n.tr("Network name") + ":  </b>" + bikeStationsPage.networkId
            }
        }

        Row {
            Label {
                text: "<b>" + i18n.tr("City") + ":  </b>" + bikeStationsPage.city
            }
        }

        Row {
            Label {
                id: bikeNetworksAmountStationsLabel
                text: "<b>" + i18n.tr("Total stations") + ":  </b>" + bikeStationsListView.count
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: filterByStationNameField
                placeholderText: i18n.tr("filter by station name")
                width: units.gu(28)
                inputMethodHints: Qt.ImhNoPredictiveText /* disable text prediction with underlining */
                onTextChanged: {

                    if (text.length > 0) /* do filter */ {
                        /* flag "i" = ignore case */
                        sortedBikeStationsListModel.filter.pattern = new RegExp(filterByStationNameField.text, "i")
                        sortedBikeStationsListModel.sort.order = Qt.AscendingOrder
                        sortedBikeStationsListModel.sortCaseSensitivity = Qt.CaseSensitive

                        /* filter by station name */
                        sortedBikeStationsListModel.sort.property = "name"
                        sortedBikeStationsListModel.filter.property = "name"

                    } else {
                        /* show all stations */
                        sortedBikeStationsListModel.filter.pattern = /./
                        sortedBikeStationsListModel.sort.order = Qt.AscendingOrder
                        sortedBikeStationsListModel.sortCaseSensitivity = Qt.CaseSensitive
                    }
                }
            }
        }

        Row{
             anchors.horizontalCenter: parent.horizontalCenter
            Label{
               text: i18n.tr("(Date format is:  dd.mm.yyyy   hh:mm)")
            }
        }
    }

}
