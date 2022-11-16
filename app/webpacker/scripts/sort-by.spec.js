/**
 * @jest-environment jsdom
 */

import initSortBy from "./sort-by";

const templateHTML = `
        <form id="form">
          <select class="govuk-select">
            <option value>Select a option</option>
          </select>
        </form>`;

describe('initSortBy', () => {

  beforeEach(() => {
    document.body.innerHTML = templateHTML
  })

  describe('onchange ', () => {
    it('has been attached', () => {

      expect(document.querySelector(".govuk-select").onchange).toBeNull();

      initSortBy({sortbyFormId: "form", sortbyFormSelectClass: "govuk-select"});

      expect(document.querySelector(".govuk-select").onchange).toBeTruthy();
    })
  })
})
