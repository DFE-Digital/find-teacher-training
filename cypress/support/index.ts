// ***********************************************************
// This example support/index.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************
require("./commands.ts");

global.URL = Cypress.env("BASE_URL");

if(!global.URL) {
  switch (Cypress.env("ENVIRONMENT")) {
    case "qa":
      global.URL = "https://qa.find-postgraduate-teacher-training.service.gov.uk";
      break;
    case "staging":
      global.URL = "https://staging.find-postgraduate-teacher-training.service.gov.uk";
      break;
    case "production":
      global.URL = "https://www.find-postgraduate-teacher-training.service.gov.uk";
      break;
    case "sandbox":
      global.URL = "https://sandbox.find-postgraduate-teacher-training.service.gov.uk";
      break;      
    default:
      global.URL = "https://www.find-postgraduate-teacher-training.service.gov.uk";
      break;
  }
}
