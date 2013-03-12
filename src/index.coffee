$ ->
  console.log AsyncQueue

  window.ajaxManager = new AsyncQueue(5, false)
  ajaxManager.enqueue({
    url: 'http://google.com'
    method: 'get'
    })
  ajaxManager.enqueue({
    url: 'http://facebook.com'
    method: 'get'
    })
  ajaxManager.enqueue({
    url: 'http://twitter.com'
    method: 'get'
    })
  ajaxManager.enqueue({
    url: 'http://naver.com'
    method: 'get'
    })
  ajaxManager.enqueue({
    url: 'http://metamarkets.com'
    method: 'get'
    })
  ajaxManager.enqueue({
    url: 'http://wikipedia.org'
    method: 'get'
    })
  ajaxManager.enqueue({
    url: 'http://sfwar.com'
    method: 'get'
    })