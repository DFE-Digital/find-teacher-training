/**
 * @jest-environment jsdom
 */

jest.mock('./analytics', () => {
  return { loadAnalytics : jest.fn() }
})

jest.mock('./cookie-helper')

import CookieBanner from './cookie-banner'
import {checkConsentedToCookieExists} from './cookie-helper'

const templateHTML = `
<div class="govuk-cookie-banner" role="region" aria-label="Cookies on Find postgraduate teacher training" data-module="govuk-cookie-banner" data-qa="cookie-banner">
  <div class="govuk-cookie-banner__message govuk-width-container" hidden="hidden" data-module="govuk-cookie-banner-choice-message" data-qa="cookie-banner-choice-message">
    <div class="govuk-grid-row">
      <div class="govuk-grid-column-two-thirds">
        <h2 class="govuk-cookie-banner__heading">Cookies on Find postgraduate teacher training</h2>
        <div class="govuk-cookie-banner__content">
          <p>We use some essential cookies to make this service work.</p>
          <p>We’d also like to use analytics cookies so we can understand how you use the service and make improvements.</p>
        </div>
      </div>
    </div>

    <div class="govuk-button-group">
      <button name="button" type="submit" class="govuk-button" data-accept-cookie="true">Accept analytics cookies</button>
      <button name="button" type="submit" class="govuk-button" data-accept-cookie="false">Reject analytics cookies</button>
      <a data-qa="cookie-banner__preference-link" class="govuk-link" href="/cookies">View cookies</a>
    </div>
  </div>

  <div class="govuk-cookie-banner__message govuk-width-container" hidden="hidden" data-module="govuk-cookie-banner-confirmation-message" data-qa="cookie-banner-confirmation-message">
    <div class="govuk-grid-row">
      <div class="govuk-grid-column-two-thirds">
        <h2 class="govuk-cookie-banner__heading">Cookies on Find postgraduate teacher training</h2>
        <div class="govuk-cookie-banner__content">
          <p>
            You’ve
            <span id="user-answer"></span>
              analytics cookies. You can
            <a data-qa="cookie-banner__preference-link" class="govuk-link" href="/cookies">change your cookie settings</a>
              at any time.
          </p>
        </div>
      </div>
    </div>

    <div class="govuk-button-group">
      <button name="button" type="submit" class="govuk-button" data-accept-cookie="hide-banner">Hide this message</button>
    </div>
  </div>

  <div class="govuk-cookie-banner__message govuk-width-container" data-module="govuk-cookie-banner-fallback-message" data-qa="cookie-banner-fallback-message">
    <div class="govuk-grid-row">
      <div class="govuk-grid-column-two-thirds">
        <h2 class="govuk-cookie-banner__heading">Cookies on Find postgraduate teacher training</h2>
        <div class="govuk-cookie-banner__content">
          <p>We use cookies to make this service work and collect analytics information. To accept or reject cookies, turn on JavaScript in your browser settings or reload this page.</p>
        </div>
      </div>
    </div>
  </div>
</div>`;

describe('CookieBanner', () => {

  beforeEach(() => {
    document.body.innerHTML = templateHTML
  })

  describe('constructor', () => {
    beforeEach(() => {
      document.body.innerHTML = templateHTML
    })

    afterEach(() => {
      jest.clearAllMocks()
    })

    it('doesn’t run if theres no cookie banner markup', () => {
      document.body.innerHTML = ''
      const banner = new CookieBanner()

      expect(banner.$fallbackMessageModule).toBeNull()
    })

    it('binds events to all banner buttons', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false);
      jest.spyOn(CookieBanner.prototype, 'bindEvents');
      new CookieBanner()

      expect(CookieBanner.prototype.bindEvents).toHaveBeenCalledTimes(1)
    })

    it('displays the cookie banner only if user has not consented/rejected', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false);
      const banner = new CookieBanner()

      expect(banner.$cookieBannerModule.hidden).toBeFalsy()
      expect(banner.$fallbackMessageModule.hidden).toBeTruthy()
    })
  })

  describe('acceptCookie', () => {
    it('hides the cookie choice message once a user has accepted cookies', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()

      expect(banner.$choiceMessageModule.hidden).toBeTruthy()
    })

    it('sets consented-to-cookies', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => null);
      const banner = new CookieBanner()
      banner.acceptCookie()

      expect(checkConsentedToCookieExists).toBeTruthy()
    })
  })

  describe('rejectCookie', () => {
    it('hides the cookie choice message once a user has rejected cookies', () => {
      const banner = new CookieBanner()
      banner.rejectCookie()

      expect(banner.$choiceMessageModule.hidden).toBeTruthy()
    })

    it('sets consented-to-cookies', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => null);
      const banner = new CookieBanner()
      banner.rejectCookie()

      expect(checkConsentedToCookieExists).toBeTruthy()
    })
  })

  describe('showConfirmationMessage', () => {
    it('shows the confirmation message with "accepted" content', () => {
      const banner = new CookieBanner()
      banner.showConfirmationMessage("accepted")

      expect(banner.$confirmationMessageModule.hidden).toBeFalsy()
      expect(banner.$confirmationMessageModule.querySelector('[id="user-answer"]').innerHTML).toEqual('accepted')
    })

    it('shows the confirmation message with "rejected" content', () => {
      const banner = new CookieBanner()
      banner.showConfirmationMessage("rejected")

      expect(banner.$confirmationMessageModule.hidden).toBeFalsy()
      expect(banner.$confirmationMessageModule.querySelector('[id="user-answer"]').innerHTML).toEqual('rejected')
    })
  })

  describe('hideCookieBanner', () => {
    it('hides the cookie banner' , () => {
      const banner = new CookieBanner()
      banner.showConfirmationMessage()
      banner.hideCookieBanner()

      expect(banner.$cookieBannerModule.hidden).toBeTruthy()
    })
  })
})
