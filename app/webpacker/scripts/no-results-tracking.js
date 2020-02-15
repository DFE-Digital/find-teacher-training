function NoResultsTracking($module) {
  this.$module = $module;
}

const triggerAnalyticsEvent = (category, action) => {
  ga("send", "event", {
    eventCategory: category,
    eventAction: action,
    transport: "beacon",
    nonInteraction: true
  });
};

NoResultsTracking.prototype.init = function() {
  const $module = this.$module;

  if (!$module) {
    return;
  }

  const $errorMessage = $module.querySelector("span.govuk-error-message");

  if ($errorMessage) {
    const searchTerm = document.querySelector("#provider").value;
    triggerAnalyticsEvent("Search by provider: No Results", searchTerm);
  }
};

export default NoResultsTracking;
