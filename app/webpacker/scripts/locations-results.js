import createPopupClass from "./map-popup";

const initLocationsResults = () => {
  for(var j = 0, l = 10; j < l; j++) {
    const $map = document.getElementById("locations-map-" + j);
    const trainingLocations = window["trainingLocations" + j]
      .filter(({lat, lng}) => lat !== "" && lng !== "")
      .map(location => {
        location.lat = parseFloat(location.lat);
        location.lng = parseFloat(location.lng);
        return location;
      })

    if (trainingLocations.length === 0) {
      console.error("Failed to initialise map: center is impossible to display, because none of the locations have a lat/lng.");
      $map.style.display = 'none';
      return;
    }

    const Popup = createPopupClass();
    const bounds = new google.maps.LatLngBounds();

    const centerLat = window.userLat;
    const centerLng = window.userLng;

    const map = new google.maps.Map($map, {
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false,
      scaleControl: false,
      streetViewControl: false,
      rotateControl: false,
      fullscreenControl: true,
      fullscreenControlOptions: {
        position: google.maps.ControlPosition.RIGHT_BOTTOM
      },
      zoom: 11,
      styles: [
        {
          featureType: "poi.business",
          stylers: [
            {
              visibility: "off"
            }
          ]
        },
        {
          featureType: "poi.park",
          elementType: "labels.text",
          stylers: [
            {
              visibility: "off"
            }
          ]
        }
      ]
    });

    const locations = window["trainingLocations" + j];

    for (let i = 0, length = locations.length; i < length; i++) {
      const location = locations[i];
      const latLng = new google.maps.LatLng(location.lat, location.lng);

      const closedContent = document.createElement("div");
      closedContent.innerHTML = location.name;

      const openContent = document.createElement("div");
      if (location.vacancies) {
        openContent.insertAdjacentHTML(
          "beforeend",
          `<div class="govuk-tag govuk-tag--no-content govuk-!-margin-bottom-2">${ location.vacancies }</div>`
        );
      }
      if (location.address) {
        openContent.insertAdjacentHTML(
          "beforeend",
          `<p class="govuk-body">${location.address}</p>`
        );
      }

      const popup = new Popup(latLng, closedContent, openContent);
      popup.setMap(map);

      // Extend the bounds by the locations so we get a decent number as part of the first view.
      bounds.extend(latLng);
    }

    if (window['useCircles' + j]) {
      var circle = new google.maps.Circle({
        strokeColor: '#000000',
        strokeOpacity: 0.5,
        strokeWeight: 3,
        fillColor: '#000000',
        fillOpacity: 0.1,
        map: map,
        center: { lat: trainingLocations[0].lat, lng: trainingLocations[0].lng },
        radius: 1609.34 * 10
      });

      var circle = new google.maps.Circle({
        strokeColor: '#000000',
        strokeOpacity: 0.25,
        strokeWeight: 2,
        fillColor: '#000000',
        fillOpacity: 0.05,
        map: map,
        center: { lat: trainingLocations[0].lat, lng: trainingLocations[0].lng },
        radius: 1609.34 * 20
      });

      var circle = new google.maps.Circle({
        strokeColor: '#000000',
        strokeOpacity: 0.2,
        strokeWeight: 1,
        fillColor: '#000000',
        fillOpacity: 0,
        map: map,
        center: { lat: trainingLocations[0].lat, lng: trainingLocations[0].lng },
        radius: 1609.34 * 30
      });

      var closedContent = document.createElement("div");
      closedContent.innerHTML = "Many placement schools";
      var openContent = document.createElement("div");
      var radiusLatLng = new google.maps.LatLng(trainingLocations[0].lat + (10 * 1.609/111.111), trainingLocations[0].lng);

      var radiusPopup = new Popup(radiusLatLng, closedContent, openContent, 'radius-marker');
      radiusPopup.setMap(map);

      bounds.extend(radiusLatLng);
    }

    var userLatLng = new google.maps.LatLng(window.userLat, window.userLng);

    var closedContent = document.createElement("div");
    closedContent.innerHTML = "You";
    var youPopup = new Popup(userLatLng, closedContent, document.createElement("div"), 'you-marker');
    youPopup.setMap(map);

    bounds.extend(userLatLng);

    // var marker = new google.maps.Marker({
    //   position: userLatLng,
    //   map: map,
    //   title: 'Your location'
    // });

    bounds.extend(userLatLng);

    // Use provider address to center and zoom when only one location
    //if (locations.length > 1) {
      map.fitBounds(bounds);
      map.panToBounds(bounds);
    //}
  }
};

export default initLocationsResults;
