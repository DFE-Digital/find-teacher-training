import { triggerAnalyticsEvent } from './analytics'

function NoResultsTracking ($module) {
  this.$module = $module
}

NoResultsTracking.prototype.init = function () {
  const $module = this.$module

  if (!$module) {
    return
  }

  const $errorMessage = $module.querySelector('span.govuk-error-message')

  if ($errorMessage) {
    const searchTerm = document.querySelector('#provider').value
    triggerAnalyticsEvent('Search by provider: No Results', searchTerm, true)
  }
}

export default NoResultsTracking
