import { initFormAnalytics, 
  initExternalLinkAnalytics, 
  initNavigationAnalytics, 
  loadAnalytics } from "./analytics"

global.ga = jest.fn()

describe("Analytics", () => {
  afterEach(() => {
    global.ga.mockClear()
  })

  describe("loadAnalytics", () => {
    beforeEach(() => {
      // GTM needs a script tag on the page so we create an emptry script
      // tag. It doesn't have an attributes so we can ignore it in the tests
      document.head.appendChild(document.createElement('script'));
    })
  
    it('adds dynamically adds a script tag', () => {
      loadAnalytics()
      // GTM will have a src and it will be the only script tag
      expect(document.querySelectorAll('script[src]')).toHaveLength(1)
    })

    it ('takes uses a default tracking ID', () => {
      loadAnalytics()
      const createGAInstanceWithID = ga.mock.calls[0][1]
      expect(createGAInstanceWithID).toEqual('UA-112932657-1')
    })

    it ('takes accepts a custom tracking ID', () => {
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
      const sendPageView = ga.mock.calls.filter(currentvalue => {if (currentvalue[1] === 'anonymizeIp') return currentvalue })[0]
      expect(sendPageView[2]).toEqual(true)
    })
  })

  describe("initFormAnalytics", () => {
    beforeEach(() => {
      // Note: not a <form> because JSDOM throws a fit https://github.com/jsdom/jsdom/issues/1937
      document.body.innerHTML = `
        <div data-ga-event-form="Some form">
          <input type="checkbox" data-ga-event-form-input="A ticked item" checked>
          <input type="checkbox" data-ga-event-form-input="An unticked item">
          <input type="checkbox" data-ga-event-form-input="Another ticked item" checked>
          <input type="submit">
        </div>
        `
      initFormAnalytics()
    })

    it("triggers correct GA event when users submit with checked checkboxes", () => {
      document.querySelector("[type=submit]").click()
      expect(ga.mock.calls).toMatchSnapshot()
    })
  })

  describe("initExternalLinkAnalytics", () => {
    beforeEach(() => {
      document.body.innerHTML = `
        <div>
          <a href="http://example.com"></a>
          <a href="https://google.com"></a>

          <a href="http://localhost/foo"></a>
          <a href="/foo"></a>
          <a href="#foo"></a>
        </div>
        `
      initExternalLinkAnalytics()
    })

    it("triggers correct GA events when users click on external links", () => {
      Array.from(document.querySelectorAll("a")).forEach($el => $el.click())
      expect(ga.mock.calls).toMatchSnapshot()
    })
  })

  describe("initNavigationAnalytics", () => {
    beforeEach(() => {
      document.body.innerHTML = `
        <div data-ga-event-navigation="Some navigation">
          <a href="#about"></a>
          <a href="http://example.com"></a>
        </div>
        `
      initNavigationAnalytics()
    })

    it("triggers correct GA events when users click on navigation links", () => {
      Array.from(document.querySelectorAll("a")).forEach($el => $el.click())
      expect(ga.mock.calls).toMatchSnapshot()
    })
  })
})
