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

initAutocomplete("location-autocomplete", "location");
initAutocomplete("provider-autocomplete", "provider");
