/**
 * @jest-environment jsdom
 */

jest.mock('./analytics', () => {
  return { loadAnalytics : jest.fn() }
})

jest.mock('./cookie-helper')

import CookieBanner from './cookie-banner'
import { loadAnalytics } from './analytics'
import {setConsentedToCookie, fetchConsentedToCookieValue,checkConsentedToCookieExists} from './cookie-helper'

const templateHTML = `
<div class="govuk-cookie-banner" role="region" aria-label="Cookie banner" data-module="govuk-cookie-banner" data-qa="cookie-banner" hidden>
  <div class="govuk-cookie-banner__message govuk-width-container">
    <div class="govuk-grid-row">
      <div class="govuk-grid-column-two-thirds">
          <h2 class="govuk-cookie-banner__heading govuk-heading-m">
            Cookies on Find postgraduate teacher training
          </h2>

        <div class="govuk-cookie-banner__content">

          <p class="govuk-body">We use some essential cookies to make this service work.</p>
          <p class="govuk-body">We’d also like to use analytics cookies so we can understand how you use the service and make improvements.</p>

        </div>
      </div>
    </div>

    <div class="govuk-button-group">

          <button type="button" class="govuk-button" data-accept-cookie="true">Accept analytics cookies</button>
          <button type="button" class="govuk-button" data-accept-cookie="false">Reject analytics cookies</button>
          <a data-qa="cookie-banner__preference-link" class="govuk-link" href="/cookies">View cookies</a>

    </div>
  </div>
</div>

<div class="govuk-cookie-banner" role="region" aria-label="Cookie banner" hidden="hidden" data-module="govuk-hide-cookie-banner" data-qa="cookie-banner">
  <div class="govuk-cookie-banner__message govuk-width-container">
    <div class="govuk-grid-row">
      <div class="govuk-grid-column-two-thirds">

        <div class="govuk-cookie-banner__content">

          <p>You’ve <span id="user-answer"></span> analytics cookies. You can <a data-qa="cookie-banner__preference-link" class="govuk-link" href="/cookies">change your cookie settings</a> at any time.</p>

        </div>
      </div>
    </div>

    <div class="govuk-button-group">

          <button type="button" class="govuk-button" data-accept-cookie="hide-banner">Hide this message</button>

    </div>
  </div>
</div>

<div class="govuk-cookie-banner" role="region" aria-label="Cookie banner" data-module="govuk-fallback-cookie-banner" data-qa="cookie-banner" hidden="">
  <div class="govuk-cookie-banner__message govuk-width-container">
    <div class="govuk-grid-row">
      <div class="govuk-grid-column-two-thirds">
          <h2 class="govuk-cookie-banner__heading govuk-heading-m">
            Cookies on Find postgraduate teacher training
          </h2>

        <div class="govuk-cookie-banner__content">

          <p class="govuk-body">We use cookies to make this service work and collect analytics information. To accept or reject cookies, turn on JavaScript in your browser settings or reload this page.</p>

        </div>
      </div>
    </div>

    <div class="govuk-button-group">

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

    it('doesn\'t run if theres no cookie banner markup', () => {
      document.body.innerHTML = ''
      const banner = new CookieBanner()
      expect(banner.$fallbackModule).toBeNull()
    } )

    it('binds events to all banner buttons', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false);
      jest.spyOn(CookieBanner.prototype, 'bindEvents');
      new CookieBanner()
      expect(CookieBanner.prototype.bindEvents).toHaveBeenCalledTimes(1)
    })

    it('displays the Cookie Banner only if user has not consented/rejected', () => {

      checkConsentedToCookieExists.mockImplementationOnce(() => false);

      const banner = new CookieBanner()
      expect(banner.$cookieModule.hidden).toBeFalsy()
      expect(banner.$fallbackModule.hidden).toBeTruthy()

    })

    it('hides the Cookie Banner if user has consented/rejected', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => true );

      const banner = new CookieBanner()
      expect(banner.$cookieModule.hidden).toBeTruthy()
    })
  })

  describe('acceptCookie', () => {
    it('hides the cookie banner once a user has accepted cookies', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(banner.$cookieModule.hidden).toBeTruthy()

    })

    it('sets consented-to-cookies', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => null);
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(checkConsentedToCookieExists).toBeTruthy()
    })
  })

  describe('rejectCookie', () => {
    it('hides the cookie banner once a user has rejected cookies', () => {
      const banner = new CookieBanner()
      banner.rejectCookie()
      expect(banner.$cookieModule.hidden).toBeTruthy()
    })

    it('sets consented-to-cookies', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => null);
      const banner = new CookieBanner()
      banner.rejectCookie()
      expect(checkConsentedToCookieExists).toBeTruthy()
    })
  })

  describe('showAcceptedHideMessage', () => {
    it('shows the hide message banner with "accepted" content', () => {
      const banner = new CookieBanner()
      banner.showHideMessage("accepted")
      expect(banner.$hideMessageModule.hidden).toBeFalsy()
      expect(banner.$hideMessageModule.querySelector('[id="user-answer"]').innerHTML).toEqual('accepted')
    })

    it('shows the hide message banner with "rejected" content', () => {
      const banner = new CookieBanner()
      banner.showHideMessage("rejected")
      expect(banner.$hideMessageModule.hidden).toBeFalsy()
      expect(banner.$hideMessageModule.querySelector('[id="user-answer"]').innerHTML).toEqual('rejected')
    })

  })

  describe('hideMessage', () => {
    it('hides the hide message banner' , () => {
      const banner = new CookieBanner()
      banner.showHideMessage()
      banner.hideMessage()
      expect(banner.$hideMessageModule.hidden).toBeTruthy()
    })
  })
})
