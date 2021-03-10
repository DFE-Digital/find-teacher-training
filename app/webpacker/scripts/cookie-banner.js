import {loadAnalytics} from "./analytics";
import {setConsentedToCookie,
  checkConsentedToCookieExists,
  removeAllPreviousUsedCookies} from './cookie-helper'

export default class CookieBanner {
  constructor() {
    this.$module = document.querySelector('[data-module="govuk-cookie-banner"]');

    // If the page doesn't have the banner then stop
    if (!this.$module) {
      return;
    }

    this.acceptButton = this.$module.querySelector(
      '[data-accept-cookie="true"]'
    );

    this.rejectButton = this.$module.querySelector(
      '[data-accept-cookie="false"]'
    );

    // consentCookie is false if user has not accept/rejected cookies
    if (!checkConsentedToCookieExists()) {
      removeAllPreviousUsedCookies();
      removeAllPreviousUsedCookies()
      this.showCookieMessage();
      this.bindEvents();
    }
  }

  bindEvents() {
    this.acceptButton.addEventListener("click", () => this.acceptCookie());
    this.rejectButton.addEventListener("click", () => this.rejectCookie());
  }

  acceptCookie() {
    this.hideCookieMessage();
    setConsentedToCookie(true);
    loadAnalytics();
  }

  rejectCookie() {
    this.hideCookieMessage();
    setConsentedToCookie(false);
  }

  showCookieMessage() {
    this.$module.hidden = false;
  }

  hideCookieMessage() {
    this.$module.hidden = true;
  }
}
