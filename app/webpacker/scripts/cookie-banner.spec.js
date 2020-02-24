jest.mock('./analytics', () => {
  return { loadAnalytics: jest.fn() }
})

jest.mock('./cookie-helper')

import CookieBanner from './cookie-banner'
import { loadAnalytics } from './analytics'
import { setConsentedToCookie, checkConsentedToCookieExists } from './cookie-helper'

const templateHTML = `
  <div class="app-cookie-banner app-cookie-banner--hidden" data-module="app-cookie-banner" aria-label="Cookie banner" role="region" data-qa="cookie-banner">
    <div class="govuk-width-container">
      <p class="govuk-body">
        We use cookies to <a class="govuk-link app-cookie-banner__link" data-qa="cookie-banner__info-link" href="/cookies">collect information</a>
        about how you use this service.
      </p>
      <p class="govuk-body govuk-!-margin-bottom-0">
        <button type="button" class="govuk-button govuk-!-margin-bottom-2" data-qa="cookie-banner__accept">Accept all cookies</button>
        <span class="app-cookie-banner__line-message">
          or <a class="govuk-link app-cookie-banner__link" data-qa="cookie-banner__preference-link" href="/cookies">set your cookie preferences</a>
        </span>
      </p>
    </div>
  </div>`

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
    })

    it('binds event to "Accept" button', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false)
      jest.spyOn(CookieBanner.prototype, 'bindEvents')
      new CookieBanner()
      expect(CookieBanner.prototype.bindEvents).toHaveBeenCalledTimes(1)
    })

    it('displays the Cookie Banner if user has not consented/rejected', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => false)
      const banner = new CookieBanner()
      expect(banner.$module.className).not.toContain('app-cookie-banner--hidden')
      expect(banner.$module.className).toContain('app-cookie-banner')
    })

    it('hides the Cookie Banner if user has consented/rejected', () => {
      checkConsentedToCookieExists.mockImplementationOnce(() => true)
      const banner = new CookieBanner()
      expect(banner.$module.className).toContain('app-cookie-banner--hidden')
      expect(banner.$module.className).toContain('app-cookie-banner')
    })
  })

  describe('acceptCookie', () => {
    it('hides the cookie banner once a user has accepted cookies', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(banner.$module.className).toContain('app-cookie-banner--hidden')
    })

    it('only loads analytics once a user has accepted cookies', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(loadAnalytics).toBeCalled()
    })

    it('sets consented-to-cookies to true', () => {
      const banner = new CookieBanner()
      banner.acceptCookie()
      expect(setConsentedToCookie).toBeCalled()
    })
  })
})
