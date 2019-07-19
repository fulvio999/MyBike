
/*
    CITIBIK.ES API DOC index: https://api.citybik.es/v2/
*/


  /* Return all the byke networks available at citybik.es  (get the summary fileds for each network) */
  function getAllNetworks(cityBikBaseUrl){

       var xmlhttp = new XMLHttpRequest();
       var urlToCall = cityBikBaseUrl+"?fields=id,name,href,location,city,country";
       //console.log("urlToCall: "+urlToCall);

       xmlhttp.onreadystatechange=function() {

            if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
            {
               var response = JSON.parse(xmlhttp.responseText);
               var networksList = response.networks;
               for(var i=0; i<networksList.length; i++){
                  try{

                       var href = networksList[i].href;
                       var country = networksList[i].location.country;
                       var city = networksList[i].location.city;
                       var country = networksList[i].location.country;
                       var latitude = networksList[i].location.latitude;
                       var longitude = networksList[i].location.longitude;
                       var networkName = networksList[i].name;
                       var networkId = networksList[i].id; /* used to get network details */

                       /* json shown in a ListView  */
                       bikeNetworksListModel.append({
                           "href": href,
                           "city": city,
                           "country": country,
                           "latitude": latitude,
                           "longitude": longitude,
                           "networkName": networkName,
                           "networkId": networkId
                       });

                    }catch(e){
                       console.log("Error loading network bike list from url cause: "+e);
                       return -1; // Error
                    }
               }
            }
       }

       xmlhttp.open("GET", urlToCall, true);
       xmlhttp.send();

       return 0; //OK
    }


    /*
        Return the details about a specific network bike Station
     */
    function getNetworkInfo(cityBikBaseUrl,networkId){

        var xmlhttp = new XMLHttpRequest();
        var urlToCall = cityBikBaseUrl+"/"+networkId;
        //console.log("urlToCall: "+urlToCall);

        xmlhttp.onreadystatechange=function() {

             if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
             {
                var response = JSON.parse(xmlhttp.responseText);
                var stationsList = response.network.stations; /* get the 'stations' array fields */

                for(var i=0; i<stationsList.length; i++){
                   try{

                        var emptySlots = stationsList[i].empty_slots === null ? "N/A" : stationsList[i].empty_slots.toString();
                        var freeBikes = stationsList[i].free_bikes === null ? "N/A" : stationsList[i].free_bikes.toString();
                        var latitude = stationsList[i].latitude === null ? "N/A" : stationsList[i].latitude.toString();
                        var longitude = stationsList[i].longitude === null ? "N/A" : stationsList[i].longitude.toString();
                        var name = stationsList[i].name === null ? "N/A" : stationsList[i].name;
                        var timestamp = stationsList[i].timestamp === null ? "N/A" : stationsList[i].timestamp;   /* the last check time  */
                        var id = stationsList[i].id === null ? "N/A" : stationsList[i].id;

                        /* json shown in a ListView with network details */
                        bikeStationsListModel.append({
                            "emptySlots": emptySlots,
                            "freeBikes": freeBikes,
                            "latitude": latitude,
                            "longitude": longitude,
                            "name": name,
                            "timestamp": timestamp,
                            "id": id
                        });

                     }catch(e){
                        console.log("Error loading network DETAILS from url cause: "+e);
                        return -1;
                     }
                }
             }
        }

        xmlhttp.open("GET", urlToCall, true);
        xmlhttp.send();

        return 0; //OK
    }
