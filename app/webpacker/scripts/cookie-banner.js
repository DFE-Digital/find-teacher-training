import { loadAnalytics } from './analytics'
import {
  setConsentedToCookie,
  checkConsentedToCookieExists,
  removeAllPreviousUsedCookies
} from './cookie-helper'

export default class CookieBanner {
  constructor () {
    this.$module = document.querySelector('[data-module="app-cookie-banner"]')

    // If the page doesn't have the banner then stop
    if (!this.$module) {
      return
    }

    this.acceptButton = this.$module.querySelector(
      '[data-qa="cookie-banner__accept"]'
    )

    // consentCookie is false if user has not accept/rejected cookies
    if (!checkConsentedToCookieExists()) {
      removeAllPreviousUsedCookies()
      removeAllPreviousUsedCookies()
      this.showCookieMessage()
      this.bindEvents()
    }
  }

  bindEvents () {
    this.acceptButton.addEventListener('click', () => this.acceptCookie())
  }

  acceptCookie () {
    this.hideCookieMessage()
    setConsentedToCookie(true)
    loadAnalytics()
  }

  showCookieMessage () {
    this.$module.classList.remove('app-cookie-banner--hidden')
  }

  hideCookieMessage () {
    this.$module.classList.add('app-cookie-banner--hidden')
  }
}
