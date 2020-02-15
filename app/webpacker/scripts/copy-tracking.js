function CopyTracking($module) {
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

CopyTracking.prototype.init = function() {
  const $module = this.$module;

  if (!$module) {
    return;
  }

  $module.addEventListener("copy", e => {
    if (event.clipboardData) {
      const selectedText = window.getSelection().toString();
      triggerAnalyticsEvent("Page: Copying", selectedText);
    }
  });
};

export default CopyTracking;
