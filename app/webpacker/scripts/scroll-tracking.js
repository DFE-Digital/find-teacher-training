import throttle from 'lodash.throttle'
import { triggerAnalyticsEvent } from './analytics'

function ScrollTracking ($module) {
  this.$module = $module
}

let scrolledPastOneThird = false
let scrolledPastTwoThirds = false
let scrolledToBottom = false

function onScroll () {
  const h = document.documentElement
  const b = document.body
  const st = 'scrollTop'
  const sh = 'scrollHeight'

  const percent = parseInt(((h[st] || b[st]) / ((h[sh] || b[sh]) - h.clientHeight)) * 100)
  if (percent >= 33 && percent < 66 && !scrolledPastOneThird) {
    scrolledPastOneThird = true
    triggerAnalyticsEvent('Page: Scrolling', '33%', true)
  } else if (percent >= 66 && percent < 90 && !scrolledPastTwoThirds) {
    scrolledPastTwoThirds = true
    triggerAnalyticsEvent('Page: Scrolling', '66%', true)
  } else if (percent >= 90 && !scrolledToBottom) {
    scrolledToBottom = true
    triggerAnalyticsEvent('Page: Scrolling', '99%', true)
  }
}

ScrollTracking.prototype.init = function () {
  var $module = this.$module

  if (!$module) {
    return
  }

  document.addEventListener('scroll', throttle(onScroll, 250), false)
}

export default ScrollTracking
