import "../styles/application.scss";
import { initAll } from "govuk-frontend";
import initLocationsMap from "scripts/locations-map";

initAll();

window.initLocationsMap = initLocationsMap;
