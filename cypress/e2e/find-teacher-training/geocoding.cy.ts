/// <reference types="Cypress" />

describe("Geocoding", () => {
  beforeEach(() => {
    cy.clearCookies();
    cy.visit(URL);
    cy.contains("Continue").click();
  });

  afterEach(() => {
    cy.checkForDefaultTitle();
  });

  it("should let user search by location", () => {
    cy.contains("By city").click();
    cy.get("#location").type("westmin");
    cy.contains("Westminster, London").click();
    cy.contains("Continue").click();
    cy.get(".govuk-error-summary").should("not.exist");
    cy.get("h1").should("contain", "Which age group do you want to teach?");
  });

  it("should let user select an age group", () => {
    cy.contains("By city").click();
    cy.get("#location").type("westmin");
    cy.contains("Westminster, London").click();
    cy.contains("Continue").click();

    cy.contains("Primary").click();
    cy.contains("Continue").click();
    cy.get("h1").should("contain", "Primary courses with subject specialisms");
  });

  it("should let user search for a Primary course", () => {
    cy.contains("By city").click();
    cy.get("#location").type("westmin");
    cy.contains("Westminster, London").click();
    cy.contains("Continue").click();
    cy.contains("Primary").click();
    cy.contains("Continue").click();

    cy.contains("Primary with English").click();
    cy.contains("Find courses").click();
    cy.get(".govuk-error-summary").should("not.exist");
    cy.get("[id=filter-line]").contains("Primary with English courses in Westminster, London");
  });

  it("should let users view a course", () => {
    cy.contains("By city").click();
    cy.get("#location").type("westmin");
    cy.contains("Westminster, London").click();
    cy.contains("Continue").click();
    cy.contains("Primary").click();
    cy.contains("Continue").click();
    cy.contains("Primary with English").click();
    cy.contains("Find courses").click();

    cy.get(".app-search-result__provider-name:first").click();
    cy.get("h1").should("contain", "Primary");
  });
});
