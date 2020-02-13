import "../styles/application.scss";
import "accessible-autocomplete/dist/accessible-autocomplete.min.css";
import { initAll } from "govuk-frontend";
import initLocationsMap from "scripts/locations-map";
import backLink from "scripts/back-link";
import initAutocomplete from "scripts/autocomplete";

initAll();

window.initLocationsMap = initLocationsMap;

const $backLink = document.querySelector('[data-module="back-link"]');
new backLink($backLink).init();

initAutocomplete(
  {
    element: "location-autocomplete",
    input: "location",
    path: "/location-suggestions"
  }
);
initAutocomplete(
  {
    element: "provider-autocomplete",
    input: "provider",
    path: "/provider-suggestions"
  }
);
