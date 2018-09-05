import QtQuick 2.4
import Ubuntu.Components 1.3

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
