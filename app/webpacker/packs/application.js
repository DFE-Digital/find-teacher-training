import "../styles/application.scss";
import { initAll } from "govuk-frontend";
import initLocationsMap from "scripts/locations-map";
import backLink from "scripts/back-link";

initAll();

window.initLocationsMap = initLocationsMap;

const $backLink = document.querySelector('[data-module="back-link"]');
new backLink($backLink).init();
