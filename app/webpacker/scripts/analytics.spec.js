import { initFormAnalytics, initExternalLinkAnalytics, initNavigationAnalytics } from "./analytics"

global.ga = jest.fn()

describe("Analytics", () => {
  afterEach(() => {
    global.ga.mockClear()
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
