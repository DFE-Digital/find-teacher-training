require.context("govuk-frontend/govuk/assets");

import "../styles/application.scss";
import "../images/option-select-toggle-sprite.png";
import "accessible-autocomplete/dist/accessible-autocomplete.min.css";
import { initAll } from "govuk-frontend";
import initLocationsMap from "scripts/locations-map";
import backLink from "scripts/back-link";
import initAutocomplete from "scripts/autocomplete";
import toggle from "scripts/toggle";
import { loadAnalytics } from "scripts/analytics.js";
import initCookieBanner from "scripts/cookie-banner";
import refreshStartPage from "scripts/refresh-start-page";

initAll();

refreshStartPage();
window.initLocationsMap = initLocationsMap;

const $backLink = document.querySelector('[data-module="back-link"]');
new backLink($backLink).init();

const $toggle = document.querySelector('[data-module="toggle"]');
new toggle($toggle).init();

initAutocomplete({
  element: "location-autocomplete",
  input: "location",
  path: "/location-suggestions",
});
initAutocomplete({
  element: "provider-autocomplete",
  input: "provider",
  path: "/provider-suggestions",
});

loadAnalytics();
new initCookieBanner();
