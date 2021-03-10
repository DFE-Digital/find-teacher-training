import {loadAnalytics} from "./analytics";
import {setConsentedToCookie,
  checkConsentedToCookieExists,
  removeAllPreviousUsedCookies} from './cookie-helper'

export default class CookieBanner {
  constructor() {
    this.$fallbackModule = document.querySelector('[data-module="govuk-fallback-cookie-banner"]')

    //If the page doesn't have the fallback banner then stop
    if (!this.$fallbackModule) {
      return;
    }

    this.$fallbackModule.hidden = true;

    this.$cookieModule = document.querySelector('[data-module="govuk-cookie-banner"]');

    this.$hideMessageModule = document.querySelector('[data-module="govuk-hide-cookie-banner"]');

    this.acceptButton = this.$cookieModule.querySelector(
      '[data-accept-cookie="true"]'
    );

    this.rejectButton = this.$cookieModule.querySelector(
      '[data-accept-cookie="false"]'
    );

    this.hideMessageButton = this.$hideMessageModule.querySelector(
      '[data-accept-cookie="hide-banner"]'
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
    this.acceptButton.addEventListener("click", () => this.showHideMessage("accepted"));
    this.rejectButton.addEventListener("click", () => this.rejectCookie());
    this.rejectButton.addEventListener("click", () => this.showHideMessage("rejected"));
    this.hideMessageButton.addEventListener("click", () => this.hideMessage());
  }

  acceptCookie() {
    this.hideBannerMessage(this.$cookieModule);
    setConsentedToCookie(true);
    loadAnalytics();
  }

  rejectCookie() {
    this.hideBannerMessage(this.$cookieModule);
    setConsentedToCookie(false);
  }

  showHideMessage(content) {
    this.$hideMessageModule.hidden = false;
    this.$hideMessageModule.querySelector('[id="user-answer"]').textContent=`${content}`;
  }

  hideMessage(){
    this.hideBannerMessage(this.$hideMessageModule);
  }

  showCookieMessage() {
    this.$cookieModule.hidden = false;
  }

  hideBannerMessage(module) {
    module.hidden = true;
  }
}
