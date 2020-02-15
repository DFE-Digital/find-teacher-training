const ANALYTICAL_COOKIES = [
  '_ga', '_gat', '_gat_UA-112932657-7', '_gid'
]

/** @description sets the cookie with the users consent and returns its value
 * @param {Boolean} usersAnswer - user consents to cookies true/false
 * @returns {Boolean} true, if it successfully set the consented-to-cookies
*/
const setConsentedToCookie = (usersAnswer) => {
  if (typeof usersAnswer === "boolean"){
    setCookie('consented-to-cookies',usersAnswer, { days: 182 })
    removeOptionalCookies(usersAnswer)
    return true
  } else {
    throw new Error('consent-to-cookies: Only accepts boolean parameters');
  }
}

/** @summary fetches the consented-to-cookies cookie value
 * @returns {Boolean} 
*/
const fetchConsentedToCookieValue = () => {
  // Convert string to boolean value (Should be a boolean value)
  // Also a good safe guard if the value is anything than boolean
  // it will return false.
  return String(getCookie('consented-to-cookies')) == "true"
}

/** @summary Checks if consented-to-cookies cookie exists 
 * @returns {Boolean} true if it find the consented-to-cookies & false if it does not find it
*/
const checkConsentedToCookieExists = () => {
  return getCookie('consented-to-cookies') == null ? false : true;
}

/** @summary Removes pre-consented cookies
 *  @description  In the past, we used to automatically add Cookies to a users
 *  device. We ask users for their consent before doing this. To ensure all users
 *  have a chance to consent/reject cookies, we have to find and expire any existing
 *  cookies.
 * 
 *  @todo We should remove this around February 2021 so that we can be sure existing users 
 *  have been given the chance to consent or reject cookies
 * 
*/
const removeAllPreviousUsedCookies = () =>  {
  const preConstentCookieExist = String(getCookie('seen_cookie_message')) == "yes"
  const constentCookieExist = String(getCookie('consented-to-cookies')) == "true"

  const cookies = document.cookie.split(/;/)

  if (preConstentCookieExist || constentCookieExist === false) {
    for (let i = 0, len = cookies.length; i < len; i++) {
      const cookie = cookies[i].split(/=/);
      const cookieName = cookie[0].trim();
      if (cookieName !== '_find_teacher_training_session' ){
        setCookie(cookieName, '', {days: -1})
      }
    }
  }
}



/** 
 *  @private
 *  @summary Removes optional cookies such as GA related cookies
 *  @param {Boolean} userDecision - false if they rejcected cookies or true 
 *  if they consented
 *  @description If a user has decided to reject cookies then we have
 *  to expire any optional cookie that has been set. In our case its 
 *  will be cookies created by Google Analytics. 
 */
const removeOptionalCookies = (userDecision) => {
  if (userDecision=== false) {
    ANALYTICAL_COOKIES.forEach( cookieName => {
      const doesCookieExist = getCookie(cookieName) == null ? false : true;
      
      if(doesCookieExist) {
        setCookie(cookieName, '', {days: -1})
      }
    })
  }
}

/** 
 *  @private
 *  @summary Fetches and returns a cookie by cookie name
 *  @param {string} name - Cookie name which the method should lookup
 *  @returns {string} Cookie string in key=value format
 *  @returns {null} if Cookie is not found
 *  @description If a user has decided to reject cookies then we have
 *  to expire any optional cookie that has been set. In our case its 
 *  will be cookies created by Google Analytics. 
 */
function getCookie (name) {
  let nameEQ = name + '='
  let cookies = document.cookie.split(';')
  for (let i = 0, len = cookies.length; i < len; i++) {
    let cookie = cookies[i]
    while (cookie.charAt(0) === ' ') {
      cookie = cookie.substring(1, cookie.length)
    }
    if (cookie.indexOf(nameEQ) === 0) {
      return decodeURIComponent(cookie.substring(nameEQ.length))
    }
  }
  return null
}

/** 
 *  @private
 *  @summary Sets a cookie
 *  @param {string} name - Cookie name
 *  @param {string} value - Value the cookie will be set to
 *  @param {object} options - used to set cookie options like secure/ expiry date etc
 *  @example chocolateChip cookie value is tasty and expires in 2 days time
 *  setCookie('chocolateChip', 'Tasty', {days: 2 })
 *  @example Delete/Expire existing chocolateChip cookie
 *  setCookie('chocolateChip', '', {days: -1 })
 */
function setCookie (name, value, options) {
  if (typeof options === 'undefined') {
    options = {}
  }
  var cookieString = name + '=' + value + '; path=/'
  if (options.days) {
    var date = new Date()
    date.setTime(date.getTime() + (options.days * 24 * 60 * 60 * 1000))
    cookieString = cookieString + '; expires=' + date.toGMTString()
  }
  if (document.location.protocol === 'https:') {
    cookieString = cookieString + '; Secure'
  }
  document.cookie = cookieString
}


export {
  setConsentedToCookie,
  fetchConsentedToCookieValue,
  checkConsentedToCookieExists,
  removeAllPreviousUsedCookies
}
