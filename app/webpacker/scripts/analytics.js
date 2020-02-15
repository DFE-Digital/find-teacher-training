const triggerAnalyticsEvent = (category, action) => {
  ga("send", "event", {
    eventCategory: category,
    eventAction: action,
    transport: "beacon"
  });
};

export const initFormAnalytics = () => {
  // How to use:
  //
  // 1. Attach `data-ga-event-form="Helpful Namespace"` to <form> elements
  // 2. Attach `data-ga-event-form-input="Helpful Label" to <input>s of type checkbox or radio
  //
  // When users click on [type='submit'] in the form, an analytics event is triggered with the
  // namespace followed by the specified labels of the checked inputs.

  const dataAttrForm = "data-ga-event-form";
  const dataAttrInput = "data-ga-event-form-input";

  const attachAnalyticsToForm = $form => {
    const namespace = $form.getAttribute(dataAttrForm);
    const $submitBtn = $form.querySelector('[type="submit"]');

    $submitBtn.addEventListener("click", () => {
      const $checkedInputs = $form.querySelectorAll("[" + dataAttrInput + "]:checked");
      const values = [];

      for (let j = 0; j < $checkedInputs.length; j++) {
        values.push($checkedInputs[j].getAttribute(dataAttrInput));
      }

      triggerAnalyticsEvent("Form: " + namespace, values.join(", "));
    });
  };

  const $forms = document.querySelectorAll("[" + dataAttrForm + "]");

  for (let i = 0; i < $forms.length; i++) {
    attachAnalyticsToForm($forms[i]);
  }
};

export const initExternalLinkAnalytics = () => {
  // This will attach event listeners to all links with hrefs that point to external resource.

  const externalLinkSelector = 'a[href^="http"]:not([href*="' + window.location.hostname + '"])';

  const trackClickEvent = event => {
    triggerAnalyticsEvent("External Link Clicked", event.target.getAttribute("href"));
  };

  const $links = document.querySelectorAll(externalLinkSelector);

  for (let i = 0; i < $links.length; i++) {
    $links[i].addEventListener("click", trackClickEvent);
  }
};

export const initNavigationAnalytics = () => {
  // How to use:
  //
  // 1. Attach `data-ga-event-navigation="Helpful Namespace"` to a container that has links
  //
  // When users click on a[href] in the container, an analytics event is triggered with the
  // namespace followed by the href.

  const dataAttrNav = "data-ga-event-navigation";

  const attachAnalyticsToNav = $nav => {
    const namespace = $nav.getAttribute(dataAttrNav);

    const trackClickEvent = event => {
      triggerAnalyticsEvent(namespace + " Navigation Link Clicked", event.target.getAttribute("href"));
    };

    const $links = $nav.querySelectorAll("a[href]");

    for (let i = 0; i < $links.length; i++) {
      $links[i].addEventListener("click", trackClickEvent);
    }
  };

  const $navs = document.querySelectorAll("[" + dataAttrNav + "]");

  for (let i = 0; i < $navs.length; i++) {
    attachAnalyticsToNav($navs[i]);
  }
};
