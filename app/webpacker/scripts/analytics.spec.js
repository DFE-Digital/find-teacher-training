jest.mock('./cookie-helper')

import { initFormAnalytics,
  initExternalLinkAnalytics,
  initNavigationAnalytics,
  loadAnalytics } from "./analytics"

import { fetchConsentedToCookieValue } from './cookie-helper'

global.ga = jest.fn()

const setupPage = (HTMLContent, callback) => {
  fetchConsentedToCookieValue.mockImplementation(() => true);
  document.body.innerHTML = HTMLContent
  callback()
}

describe("Analytics", () => {
  afterEach(() => {
    global.ga.mockClear()
  })

  describe("loadAnalytics", () => {
    describe("when a user consents to cookies", () => {
      beforeEach(() => {
        fetchConsentedToCookieValue.mockImplementationOnce(() => true);
        // GTM needs a script tag on the page so we create an emptry script
        // tag. It doesn't have an attributes so we can ignore it in the tests
        document.head.appendChild(document.createElement('script'));
      })

      afterEach(() => {
        jest.clearAllMocks();
      })

      it('dynamically adds a script tag', () => {
        loadAnalytics()
        // GTM will have a src and it will be the only script tag
        expect(document.querySelectorAll('script[src]')).toHaveLength(1)
      })

      it ('uses a default tracking ID', () => {
        loadAnalytics()
        const createGAInstanceWithID = ga.mock.calls[0][1]
        expect(createGAInstanceWithID).toEqual('UA-112932657-1')
      })

      it ('accepts a custom tracking ID', () => {
        loadAnalytics('NoT-a-Real-ID-123')

        const createGAInstanceWithID = ga.mock.calls[0][1]
        expect(createGAInstanceWithID).toEqual('NoT-a-Real-ID-123')
      })

      it ('records a page view', () => {
        loadAnalytics()
        const sendPageView = ga.mock.calls.filter(currentvalue => {if (currentvalue[0] === 'send') return currentvalue })[0]
        expect(sendPageView[1]).toEqual('pageview')
      })

      it ('anonymises the users IP Address', () => {
        loadAnalytics()
        const anonymizeIp = ga.mock.calls.filter(currentvalue => {if (currentvalue[1] === 'anonymizeIp') return currentvalue })[0]
        expect(anonymizeIp[2]).toEqual(true)
      })
    })

    describe("when a user rejects cookies", () => {
      beforeEach(() => {
        fetchConsentedToCookieValue.mockImplementation(() => false);

        // GTM needs a script tag on the page so we create an emptry script
        // tag. It doesn't have an attributes so we can ignore it in the tests
        document.head.appendChild(document.createElement('script'));
      })

      afterEach(()=>{
        jest.clearAllMocks()
        document.head.innerHTML = ''
      })

      // Jest doesn't seem to be clearing down the script tage
      // TODO find a way to remove script tags that are direct children of <html>
      it.skip('dynamically adds a script tag', () => {
        loadAnalytics()
        // GTM will have a src and it will be the only script tag
        expect(document.querySelectorAll('script[src]')).toHaveLength(0)

      })

      it ('uses a default tracking ID', () => {
        loadAnalytics()
        expect(global.ga).not.toHaveBeenCalled()
      })

      it ("accepts a custom tracking ID - but does not run it", () => {
        loadAnalytics('NoT-a-Real-ID-123')
        expect(global.ga).not.toHaveBeenCalled()
      })

      it ('does not record a page view', () => {
        loadAnalytics()
        const sendPageView = ga.mock.calls.filter(currentvalue => {if (currentvalue[0] === 'send') return currentvalue })[0]
        expect(sendPageView).toBeUndefined()
      })

      it ('does not try anonymises the users IP Address because its the user is not being tracked', () => {
        loadAnalytics()
        const anonymizeIp = ga.mock.calls.filter(currentvalue => {if (currentvalue[1] === 'anonymizeIp') return currentvalue })[0]
        expect(anonymizeIp).toBeUndefined()
      })
    })
  })

  describe("initFormAnalytics", () => {
    beforeEach(() => {

      // Note: not a <form> because JSDOM throws a fit https://github.com/jsdom/jsdom/issues/1937
      const testContent = `
        <div data-ga-event-form="Some form">
          <input type="checkbox" data-ga-event-form-input="A ticked item" checked>
          <input type="checkbox" data-ga-event-form-input="An unticked item">
          <input type="checkbox" data-ga-event-form-input="Another ticked item" checked>
          <input type="submit">
        </div>
        `
      setupPage(testContent,initFormAnalytics)
    })

    it("triggers correct GA event when users submit with checked checkboxes", () => {
      document.querySelector("[type=submit]").click()
      expect(ga.mock.calls).toMatchSnapshot()
    })
  })

  describe("initExternalLinkAnalytics", () => {
    beforeEach(() => {
      const testContent = `
        <div>
          <a href="http://example.com"></a>
          <a href="https://google.com"></a>

          <a href="http://localhost/foo"></a>
          <a href="/foo"></a>
          <a href="#foo"></a>
        </div>
        `
      setupPage(testContent,initExternalLinkAnalytics)
    })

    it("triggers correct GA events when users click on external links", () => {
      Array.from(document.querySelectorAll("a")).forEach($el => $el.click())
      expect(ga.mock.calls).toMatchSnapshot()
    })
  })

  describe("initNavigationAnalytics", () => {
    beforeEach(() => {
      const testContent = `
        <div data-ga-event-navigation="Some navigation">
          <a href="#about"></a>
          <a href="http://example.com"></a>
        </div>
        `
      setupPage(testContent,initNavigationAnalytics)
    })

    it("triggers correct GA events when users click on navigation links", () => {
      Array.from(document.querySelectorAll("a")).forEach($el => $el.click())
      expect(ga.mock.calls).toMatchSnapshot()
    })
  })
})
