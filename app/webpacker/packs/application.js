import "../styles/application.scss";
import "../images/option-select-toggle-sprite.png";
import "accessible-autocomplete/dist/accessible-autocomplete.min.css";
import { initAll } from "govuk-frontend";
import initLocationsMap from "scripts/locations-map";
import backLink from "scripts/back-link";
import initAutocomplete from "scripts/autocomplete";
import toggle from "scripts/toggle";
import { initFormAnalytics, initExternalLinkAnalytics, initNavigationAnalytics } from "scripts/analytics.js";
import scrollTracking from "scripts/scroll-tracking";
import copyTracking from "scripts/copy-tracking";
import noResultsTracking from "scripts/no-results-tracking";

initAll();

window.initLocationsMap = initLocationsMap;

const $backLink = document.querySelector('[data-module="back-link"]');
new backLink($backLink).init();

const $toggle = document.querySelector('[data-module="toggle"]');
new toggle($toggle).init();

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

if (typeof ga !== "undefined") {
  initFormAnalytics();
  initExternalLinkAnalytics();
  initNavigationAnalytics();

  const $page = document.querySelector('[data-module*="ga-track"]');
  new scrollTracking($page).init();
  new copyTracking($page).init();

  const $searchInput = document.querySelector('[data-module="track-no-provider-results"]');
  new noResultsTracking($searchInput).init();
} else {
  console.log("Google Analytics `window.ga` object not found. Skipping analytics.");
}
