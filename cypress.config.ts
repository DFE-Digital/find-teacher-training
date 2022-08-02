import { defineConfig } from 'cypress'

export default defineConfig({
  blockHosts: 'www.google-analytics.com',
  video: true,
  e2e: {
    // We've imported your old cypress plugins here.
    // You may want to clean this up later by importing these.
    setupNodeEvents(on, config) {
      return require('./cypress/plugins/index.ts')(on, config)
    },
  },
})
