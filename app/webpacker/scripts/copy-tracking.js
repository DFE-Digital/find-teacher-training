import { triggerAnalyticsEvent } from './analytics'

function CopyTracking($module) {
  this.$module = $module;
}

CopyTracking.prototype.init = function() {
  const $module = this.$module;

  if (!$module) {
    return;
  }

  $module.addEventListener("copy", e => {
    if (event.clipboardData) {
      const selectedText = window.getSelection().toString();
      triggerAnalyticsEvent("Page: Copying", selectedText, true);
    }
  });
};

export default CopyTracking;
