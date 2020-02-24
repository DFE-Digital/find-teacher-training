import ScrollTracking from './scroll-tracking'
import CopyTracking from './copy-tracking'
import NoResultsTracking from './no-results-tracking'
import { fetchConsentedToCookieValue } from './cookie-helper'

const triggerAnalyticsEvent = (category, action, flagNonInteraction) => {
  const options = {
    eventCategory: category,
    eventAction: action,
    transport: 'beacon'
  }

  if (flagNonInteraction) { options.nonInteraction = true }

  if (fetchConsentedToCookieValue()) {
    ga('send', 'event', options)
  }
}

/** @description Dynamically downloads our analytical platform (GA)
 * @param {string} trackingCode Google Analytical unique tracking code
 * @return {number}
 */
const loadAnalytics = (trackingCode) => {
  /* jshint ignore:start */

  if (fetchConsentedToCookieValue()) {
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga')

    ga('create', trackingCode || 'UA-112932657-1', 'auto')
    ga('set', 'transport', 'beacon')
    ga('set', 'anonymizeIp', true)

    if (location.search) {
      var search = location.search
      var params = ['lat', 'lng', 'loc', 'lq']
      for (let param = 0; param < params.length; param++) {
        search = search.replace(new RegExp('([?&])' + params[param] + '(=[^&]*)?&?', 'gi'), '$1')
      }
      ga('set', 'location', window.location.protocol + '//' + window.location.host + window.location.pathname + search)
    }

    ga('send', 'pageview')

    initFormAnalytics()
    initExternalLinkAnalytics()
    initNavigationAnalytics()

    const $page = document.querySelector('[data-module*="ga-track"]')
    new ScrollTracking($page).init()
    new CopyTracking($page).init()

    const $searchInput = document.querySelector('[data-module="track-no-provider-results"]')
    new NoResultsTracking($searchInput).init()
  }
  /* jshint ignore:end */
}

const initFormAnalytics = () => {
  // How to use:
  //
  // 1. Attach `data-ga-event-form="Helpful Namespace"` to <form> elements
  // 2. Attach `data-ga-event-form-input="Helpful Label" to <input>s of type checkbox or radio
  //
  // When users click on [type='submit'] in the form, an analytics event is triggered with the
  // namespace followed by the specified labels of the checked inputs.

  const dataAttrForm = 'data-ga-event-form'
  const dataAttrInput = 'data-ga-event-form-input'

  const attachAnalyticsToForm = $form => {
    const namespace = $form.getAttribute(dataAttrForm)
    const $submitBtn = $form.querySelector('[type="submit"]')

    $submitBtn.addEventListener('click', () => {
      const $checkedInputs = $form.querySelectorAll('[' + dataAttrInput + ']:checked')
      const values = []

      for (let j = 0; j < $checkedInputs.length; j++) {
        values.push($checkedInputs[j].getAttribute(dataAttrInput))
      }

      triggerAnalyticsEvent('Form: ' + namespace, values.join(', '))
    })
  }

  const $forms = document.querySelectorAll('[' + dataAttrForm + ']')

  for (let i = 0; i < $forms.length; i++) {
    attachAnalyticsToForm($forms[i])
  }
}

const initExternalLinkAnalytics = () => {
  // This will attach event listeners to all links with hrefs that point to external resource.

  const externalLinkSelector = 'a[href^="http"]:not([href*="' + window.location.hostname + '"])'

  const trackClickEvent = event => {
    triggerAnalyticsEvent('External Link Clicked', event.target.getAttribute('href'))
  }

  const $links = document.querySelectorAll(externalLinkSelector)

  for (let i = 0; i < $links.length; i++) {
    $links[i].addEventListener('click', trackClickEvent)
  }
}

const initNavigationAnalytics = () => {
  // How to use:
  //
  // 1. Attach `data-ga-event-navigation="Helpful Namespace"` to a container that has links
  //
  // When users click on a[href] in the container, an analytics event is triggered with the
  // namespace followed by the href.

  const dataAttrNav = 'data-ga-event-navigation'

  const attachAnalyticsToNav = $nav => {
    const namespace = $nav.getAttribute(dataAttrNav)

    const trackClickEvent = event => {
      triggerAnalyticsEvent(namespace + ' Navigation Link Clicked', event.target.getAttribute('href'))
    }

    const $links = $nav.querySelectorAll('a[href]')

    for (let i = 0; i < $links.length; i++) {
      $links[i].addEventListener('click', trackClickEvent)
    }
  }

  const $navs = document.querySelectorAll('[' + dataAttrNav + ']')

  for (let i = 0; i < $navs.length; i++) {
    attachAnalyticsToNav($navs[i])
  }
}
export {
  loadAnalytics,
  initExternalLinkAnalytics,
  initFormAnalytics,
  initNavigationAnalytics,
  triggerAnalyticsEvent
}
