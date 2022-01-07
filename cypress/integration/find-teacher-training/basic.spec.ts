/// <reference types="Cypress" />

Cypress.Cookies.defaults({
  preserve: "_find_teacher_training_session"
})

describe("Basic", () => {
  before(() => {
    cy.clearCookies()
    cy.visit(URL);
    cy.contains("Continue").click();
  });


  afterEach(() => {
    cy.checkForDefaultTitle();
  });

  it("should have correct title", () => {
    cy.title().should("include", "Find courses by location or by training provider");
  });

  it("should have js-enabled", () => {
    cy.get("body").should("have.class", "js-enabled");
  });

  it("should show a validation error if user does not select a location", () => {
    cy.contains("Continue").click();
    cy.get(".govuk-error-summary").should("exist");
  });

  it("should let user search Across England", () => {
    cy.contains("Across England").click();
    cy.contains("Continue").click();
    cy.get(".govuk-error-summary").should("not.exist");
    cy.get("h1").should("contain", "Which age group do you want to teach?");
  });

  it("should show a validation error if user does not select an age group", () => {
    cy.contains("Continue").click();
    cy.get(".govuk-error-summary").should("exist");
  });

  it("should let user select an age group", () => {
    cy.contains("Secondary").click();
    cy.contains("Continue").click();
    cy.get("h1").should("contain", "Which secondary subjects are you interested in?");
  });

  it("should show a validation error if user does not select a subject", () => {
    cy.contains("Continue").click();
    cy.get(".govuk-error-summary").should("exist");
  });

  it("should let user search for Business Studies", () => {
    cy.contains("Secondary").click();
    cy.contains("Business studies").click();
    cy.contains("Continue").click();
    cy.get(".govuk-error-summary").should("not.exist");
    cy.get("[id=filter-line]").contains("Business studies courses in England");
  });

  it("should let users view a course", () => {
    cy.get(".app-search-result__item-title:first").click();
    cy.get("h1").should("contain", "Business");
  });

  it("should show an enriched course", () => {
    cy.contains("Apply").should("exist");
  });
});
