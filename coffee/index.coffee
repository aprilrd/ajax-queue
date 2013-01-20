require ['jquery', 'ajax-queue'], ($, AJAXQueue) -> 
  $ ->
    console.log AJAXQueue

    window.ajaxManager = new AJAXQueue(5, false)
    ajaxManager.put({
      url: 'http://google.com'
      method: 'get'
      })
    ajaxManager.put({
      url: 'http://facebook.com'
      method: 'get'
      })
    ajaxManager.put({
      url: 'http://twitter.com'
      method: 'get'
      })
    ajaxManager.put({
      url: 'http://naver.com'
      method: 'get'
      })
    ajaxManager.put({
      url: 'http://metamarkets.com'
      method: 'get'
      })
    ajaxManager.put({
      url: 'http://wikipedia.org'
      method: 'get'
      })
    ajaxManager.put({
      url: 'http://sfwar.com'
      method: 'get'
      })