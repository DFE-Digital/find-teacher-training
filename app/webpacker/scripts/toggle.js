function Toggle ($module) {
  this.$module = $module
}

Toggle.prototype.init = function () {
  // Check for module
  var $module = this.$module
  if (!$module) {
    return
  }

  // Check for button
  var $toggleButton = $module.querySelector('.js-toggle')
  if (!$toggleButton) {
    return
  }

  // Handle $toggleButton click events
  $toggleButton.addEventListener('click', this.handleClick.bind(this))
}

/**
* Toggle class
* @param {object} node element
* @param {string} className to toggle
*/
Toggle.prototype.toggleClass = function (node, className) {
  if (node.className.indexOf(className) > 0) {
    node.className = node.className.replace(' ' + className, '')
  } else {
    node.className += ' ' + className
  }
}

/**
* An event handler for click event on $toggleButton
* @param {object} event event
*/
Toggle.prototype.handleClick = function (event) {
  var $module = this.$module
  var $toggleButton = event.target || event.srcElement
  var $target = $module.querySelector('#' + $toggleButton.getAttribute('aria-controls'))

  // If a button with aria-controls, handle click
  if ($toggleButton && $target) {
    this.toggleClass($target, 'govuk-toggle__target--open')
    this.toggleClass($toggleButton, 'govuk-toggle__link--open')

    $toggleButton.setAttribute('aria-expanded', $toggleButton.getAttribute('aria-expanded') !== 'true')
    $target.setAttribute('aria-hidden', $target.getAttribute('aria-hidden') === 'false')
  }
}

export default Toggle
