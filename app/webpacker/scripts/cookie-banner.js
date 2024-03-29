import {loadAnalytics} from "./analytics";
import {setConsentedToCookie,
  checkConsentedToCookieExists,
  removeAllPreviousUsedCookies} from './cookie-helper'

export default class CookieBanner {
  constructor() {
    this.$fallbackMessageModule = document.querySelector('[data-module="govuk-cookie-banner-fallback-message"]')

    // If the page doesn't have the fallback banner then stop
    if (!this.$fallbackMessageModule) {
      return;
    }

    this.$fallbackMessageModule.hidden = true;

    this.$cookieBannerModule = document.querySelector('[data-module="govuk-cookie-banner"]');
    this.$choiceMessageModule = document.querySelector('[data-module="govuk-cookie-banner-choice-message"]');
    this.$confirmationMessageModule = document.querySelector('[data-module="govuk-cookie-banner-confirmation-message"]');
    this.acceptButton = this.$choiceMessageModule.querySelector('[data-accept-cookie="true"]');
    this.rejectButton = this.$choiceMessageModule.querySelector('[data-accept-cookie="false"]');
    this.hideMessageButton = this.$confirmationMessageModule.querySelector('[data-accept-cookie="hide-banner"]');

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
    this.acceptButton.addEventListener("click", () => this.showConfirmationMessage("accepted"));
    this.rejectButton.addEventListener("click", () => this.rejectCookie());
    this.rejectButton.addEventListener("click", () => this.showConfirmationMessage("rejected"));
    this.hideMessageButton.addEventListener("click", () => this.hideCookieBanner());
  }

  acceptCookie() {
    this.hideModule(this.$choiceMessageModule);
    setConsentedToCookie(true);
    loadAnalytics();
  }

  rejectCookie() {
    this.hideModule(this.$choiceMessageModule);
    setConsentedToCookie(false);
  }

  showConfirmationMessage(content) {
    this.$confirmationMessageModule.hidden = false;
    this.$confirmationMessageModule.querySelector('[id="user-answer"]').textContent=`${content}`;
  }

  hideCookieBanner() {
    this.hideModule(this.$cookieBannerModule);
  }

  showCookieMessage() {
    this.$choiceMessageModule.hidden = false;
  }

  hideModule(module) {
    module.hidden = true;
  }
}
