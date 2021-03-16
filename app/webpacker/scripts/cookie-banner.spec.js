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
      expect(banner.$module).toBeNull()
    } )

    it('binds event to "Accept" button', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false);
      jest.spyOn(CookieBanner.prototype, 'bindEvents');
      new CookieBanner()
      expect(CookieBanner.prototype.bindEvents).toHaveBeenCalledTimes(1)
    })

    it('binds event to "Reject" button', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false);
      jest.spyOn(CookieBanner.prototype, 'bindEvents');
      new CookieBanner()
      expect(CookieBanner.prototype.bindEvents).toHaveBeenCalledTimes(1)
    })

    it('displays the Cookie Banner if user has not consented/rejected', () => {

      checkConsentedToCookieExists.mockImplementationOnce(() => false);

      const banner = new CookieBanner()
      expect(banner.$module.hidden).toBeFalsy()
    })

    it('hides the Cookie Banner if user has consented/rejected', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => true );

      const banner = new CookieBanner()
      expect(banner.$module.hidden).toBeTruthy()
    })
  })

  describe('acceptCookie', () => {
    it('hides the cookie banner once a user has accepted cookies', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(banner.$module.hidden).toBeTruthy()
    })

    it('only loads analytics once a user has accepted cookies', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(loadAnalytics).toBeCalled()
    })

    it('sets consented-to-cookies to true', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(setConsentedToCookie).toHaveBeenCalled()
      expect(checkConsentedToCookieExists).toBeTruthy()
    })
  })

  describe('rejectCookie', () => {
    it('hides the cookie banner once a user has rejected cookies', () => {
      const banner = new CookieBanner()
      banner.rejectCookie()
      expect(banner.$module.hidden).toBeTruthy()
    })

    it('does not load analytics once a user has rejected cookies', () => {
      const banner = new CookieBanner()
      banner.rejectCookie()
      expect(loadAnalytics).not.toHaveBeenCalled()
    })

    it('sets consented-to-cookies to false', () => {
      const banner = new CookieBanner()
      banner.rejectCookie()
      expect(setConsentedToCookie).toHaveBeenCalled()
      expect(banner.checkConsentedToCookieExists).not.toBeTruthy()
    })
  })
})
