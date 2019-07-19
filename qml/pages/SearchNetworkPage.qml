import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/* import folders */
import "../delegate"


import "../js/RestClient.js" as RestClient

/*
   Search Bike network Page
*/
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
                onTriggered: {
                    PopupUtils.open(productInfo)
                }
            }
        ]

        /* the bar on the right side */
        trailingActionBar.actions: [

            Action {
                iconName: "help"
                text: i18n.tr("Help")
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("HelpPage.qml"))
                }
            },

            Action {
                iconName: "map"
                text: i18n.tr("Map")
                iconSource: Qt.resolvedUrl("../graphics/map.png")
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("MapViewerWebPage.qml"))
                }
            }
        ]
    }

    Component {
        id: bikeNetworksDelegate
        BikeNetworksDelegate {}
    }

    /* the list of ALL events form the chosen artist */
    ListModel {
        id: bikeNetworksListModel
    }

    /* keep sorted the loaded bike networks List */
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
        highlight:
              /* highlightComponent for the selected Network in the ListView n Main page */
              Component {
                    id: highlightComponent

                    Rectangle {
                        width: 180; height: 44
                        color: "green";
                        radius: 2
                        /* move the Rectangle on the currently selected List item with the keyboard */
                        y: bikeNetworksListView.currentItem.y

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
        /* note: clip:true prevent that UbuntuListView draw out of his assigned rectangle, default is false */
        clip: true
    }

    Scrollbar {
        flickableItem: bikeNetworksListView
        align: Qt.AlignTrailing
    }

    Column {
        anchors.fill: parent
        spacing: units.gu(2)

        /* transparent placeholder: required to place the content under the header */
        Rectangle {
            color: "transparent"
            width: parent.width
            height: units.gu(8)
        }

        Row {
            id: filteredNetWorksRow
            spacing: units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: showNetworksButton
                text: i18n.tr("Show Networks")
                enabled: true
                width: filterByCityField.width //units.gu(18)
                color: UbuntuColors.green
                onClicked: {

                    loadingBikeNetworkListActivity.running = !loadingBikeNetworkListActivity.running /* start animation */

                    bikeNetworksListModel.clear();
                    var returnCode = RestClient.getAllNetworks(root.cityBikBaseUrl);

                    if (returnCode === -1) {
                        PopupUtils.open(noDataFoundComponent, showNetworksButton)
                        loadingBikeNetworkListActivity.running = !loadingBikeNetworkListActivity.running /* stop animation */
                    } else {
                        loadingBikeNetworkListActivity.running = !loadingBikeNetworkListActivity.running /* stop animation */
                        filterByCityField.enabled = true;
                        bikeNetworksFoundLabel.visible = true;
                    }
                }
            }
        }

        Row {
            id: cityRow
            spacing: units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: filterByCityField
                placeholderText: i18n.tr("filter by city")
                width: units.gu(25)
                enabled: false
                inputMethodHints: Qt.ImhNoPredictiveText /* disable text prediction with underlining */
                onTextChanged: {

                    if (text.length > 0) /* do filter */ {
                        /* flag "i" = ignore case */
                        sortedBikeNetworksModel.filter.pattern = new RegExp(filterByCityField.text, "i")
                        sortedBikeNetworksModel.sort.order = Qt.AscendingOrder
                        sortedBikeNetworksModel.sortCaseSensitivity = Qt.CaseSensitive

                        /* filter by eventCountry */
                        sortedBikeNetworksModel.sort.property = "country"
                        sortedBikeNetworksModel.filter.property = "city"

                    } else {
                        /* show all byke Networks */
                        sortedBikeNetworksModel.filter.pattern = /./
                        sortedBikeNetworksModel.sort.order = Qt.AscendingOrder
                        sortedBikeNetworksModel.sortCaseSensitivity = Qt.CaseSensitive
                    }
                }
            }
        }

        Row {
            id: bikeNetworksFoundRow
            anchors.horizontalCenter: parent.horizontalCenter

            ActivityIndicator {
                id: loadingBikeNetworkListActivity
            }

            Label {
                id: bikeNetworksFoundLabel
                visible: false
                text: i18n.tr("Found") + " " + bikeNetworksListView.count + " " + i18n.tr("Bike Networks")
            }
        }

    }

}
