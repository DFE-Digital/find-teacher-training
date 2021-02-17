require.context("govuk-frontend/govuk/assets");

import "../styles/application.scss";
import "../images/option-select-toggle-sprite.png";
import "../images/icon-cross.svg";
import "accessible-autocomplete/dist/accessible-autocomplete.min.css";
import { initAll } from "govuk-frontend";
import initLocationsMap from "scripts/locations-map";
import backLink from "scripts/back-link";
import initAutocomplete from "scripts/autocomplete";
import toggle from "scripts/toggle";
import { FilterToggleButton } from "scripts/filter-toggle-button"
import { loadAnalytics } from "scripts/analytics.js";
import initCookieBanner from "scripts/cookie-banner";

initAll();

window.initLocationsMap = initLocationsMap;

const $backLink = document.querySelector('[data-module="back-link"]');
new backLink($backLink).init();

const $toggle = document.querySelector('[data-module="toggle"]');
new toggle($toggle).init();

const filterToggleButton = new FilterToggleButton({
  bigModeMediaQuery: '(min-width: 48.063em)',
  startHidden: false,
  toggleButton: {
    container: $('.app-filter-toggle'),
    showText: 'Show filters',
    hideText: 'Hide filters',
    classes: 'govuk-button--secondary'
  },
  closeButton: {
    container: $('.app-filter__header'),
    text: 'Close'
  },
  filter: {
    container: $('.app-filter-layout__filter')
  }
})

filterToggleButton.init()

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
