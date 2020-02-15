import {setConsentedToCookie, 
  fetchConsentedToCookieValue,
  checkConsentedToCookieExists,
  removeAllPreviousUsedCookies,
  removeOptionalCookies } from './cookie-helper'

const setCookie = (cookieName, value) => {
  document.cookie = `${cookieName}=${value};`
}

const clearCookie = (cookieName) => {
  document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 GMT`
}

const fetchAllCookies = () => {
  let allCookies = []

  if (document.cookie) {
    document.cookie.split(/;/).forEach( cookie => {
      allCookies.push(cookie.trim())
    })
  }
  return allCookies
}

describe("cookie helper methods", () => {

  afterEach(() => {
    clearCookie('consented-to-cookies')
  })

  describe('setConsentedToCookie', () => {
    it ('uses a boolean value to set a cookie', () => {
      const response = setConsentedToCookie(true)
      expect(document.cookie).toEqual("consented-to-cookies=true")
      expect(response).toEqual(true)
    })

    it ('uses a boolean value to set a cookie - User rejects cookies', () => {
      const response = setConsentedToCookie(false)
      expect(document.cookie).toEqual("consented-to-cookies=false")
      expect(response).toEqual(true)
    })

    it('removes optional cookies if a user rejected cookie', () => {
      const fakeEssentialCookies = ['taste', 'smell', 'sight']
      const fakeOptionalCookies = ['_ga', '_gat']

      fakeEssentialCookies.forEach( cookieName => {
        setCookie(cookieName, 1)
      })
      fakeOptionalCookies.forEach( cookieName => {
        setCookie(cookieName, 1)
      })

      expect(fetchAllCookies().length)
      .toEqual((fakeEssentialCookies.length + fakeOptionalCookies.length))
      setConsentedToCookie(false)
      // Add 1 to expected value because of the consented-to-cookied cookie
      expect(fetchAllCookies().length).toEqual((fakeEssentialCookies.length + 1))
    })

    it("raises an error if user responses is not boolean", () => {
      expect(setConsentedToCookie).toThrowError(new Error("consent-to-cookies: Only accepts boolean parameters"))
    })
  })

  describe('fetchConsentedToCookieValue', () => {
    it ('uses a boolean value to set a cookie - User accepted cookies', () => {
      setCookie('consented-to-cookies', true)
      const response = fetchConsentedToCookieValue()
      expect(response).toEqual(true)
    })

    it ('uses a boolean value to set a cookie - User rejected cookies', () => {
      setCookie('consented-to-cookies', false)
      const response = fetchConsentedToCookieValue()
      expect(response).toEqual(false)
    })

    it ('consented-to-cookies has invalid value', () => {
      setCookie('consented-to-cookies', 'maybe-I-consent')
      const response = fetchConsentedToCookieValue()
      expect(response).toEqual(false)
    })  
  })

  describe('checkConsentedToCookieExists', () => {
    it('returns true if cookie exists - User rejected', () => {
      setCookie('consented-to-cookies', false)
      const response = checkConsentedToCookieExists()
      expect(response).toEqual(true)
    })
    
    it('returns true if cookie exists - User consented', () => {
      setCookie('consented-to-cookies', true)
      const response = checkConsentedToCookieExists()
      expect(response).toEqual(true)
    })
    
    it('returns false if cookie does not exist', () => {
      setCookie('some-other-cookie', "not-consented")
      const response = checkConsentedToCookieExists()
      expect(response).toEqual(false)
      clearCookie('some-other-cookie')
    })
  })

  describe('removeAllPreviousUsedCookies', () => {
    const fakeExistingCookie = ['taste', 'smell', 'sight']
    
    beforeEach( () => {
      fakeExistingCookie.forEach( cookieName => {
        setCookie(cookieName, 1)
      })
    })

    afterEach(() => {
      fakeExistingCookie.forEach( cookieName => {
        clearCookie(cookieName)
      })
    })

    describe('existing user visiting after we started asking for consent', () => {
      const fakeExistingCookie = [
        'seen_cookie_message',
        'taste', 'smell' , 'sight']
    
      beforeEach( () => {
        fakeExistingCookie.forEach( cookieName => {
          if (cookieName === 'seen_cookie_message') {
            setCookie(cookieName, 'yes')  
          } else {
            setCookie(cookieName, 1)
          }
        })
      })
      
      it('expires all existing cookies', () => {
        expect(fetchAllCookies().length).toEqual(fakeExistingCookie.length)
        removeAllPreviousUsedCookies()
        expect(fetchAllCookies().length).toEqual(0)
      })
    })

    describe('existing user visiting after they consented', () => {
      const fakeExistingCookie = [
        'consented-to-cookies',
        'taste', 'smell' , 'sight']
    
      beforeEach( () => {
        fakeExistingCookie.forEach( cookieName => {
          if (cookieName === 'consented-to-cookies'){
            setCookie(cookieName, true)  
          } else {
            setCookie(cookieName, 1)
          }
        })
      })
      
      it('does not alter any existing cookies', () => {
        expect(fetchAllCookies().length).toEqual(fakeExistingCookie.length)
        removeAllPreviousUsedCookies()
        expect(fetchAllCookies().length).toEqual(fakeExistingCookie.length)
      })

    })
    it('expires all existing cookies', () => {
      expect(fetchAllCookies().length).toEqual(fakeExistingCookie.length)
      removeAllPreviousUsedCookies()
      expect(fetchAllCookies().length).toEqual(0)
    })

    it('does not expire session cookie', () => {
      expect(fetchAllCookies().length).toEqual(fakeExistingCookie.length)
      setCookie('_find_teacher_training_session', 'some-random-text')
      expect(fetchAllCookies().length).toEqual((fakeExistingCookie.length + 1))
      removeAllPreviousUsedCookies()
      expect(fetchAllCookies().length).toEqual(1)
    })
  })
})
