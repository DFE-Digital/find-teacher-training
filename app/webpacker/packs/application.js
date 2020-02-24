import '../styles/application.scss'
import '../images/option-select-toggle-sprite.png'
import 'accessible-autocomplete/dist/accessible-autocomplete.min.css'
import { initAll } from 'govuk-frontend'
import initLocationsMap from 'scripts/locations-map'
import BackLink from 'scripts/back-link'
import initAutocomplete from 'scripts/autocomplete'
import Toggle from 'scripts/toggle'
import { loadAnalytics } from 'scripts/analytics.js'
import InitCookieBanner from 'scripts/cookie-banner'

initAll()

window.initLocationsMap = initLocationsMap

const $backLink = document.querySelector('[data-module="back-link"]')
new BackLink($backLink).init()

const $toggle = document.querySelector('[data-module="toggle"]')
new Toggle($toggle).init()

initAutocomplete(
  {
    element: 'location-autocomplete',
    input: 'location',
    path: '/location-suggestions'
  }
)
initAutocomplete(
  {
    element: 'provider-autocomplete',
    input: 'provider',
    path: '/provider-suggestions'
  }
)

loadAnalytics()
new InitCookieBanner()
