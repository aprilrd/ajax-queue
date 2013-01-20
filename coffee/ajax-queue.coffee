define 'ajax-queue', ['jquery'], ($) ->
  class PriorityQueue
    constructor: ->
      @sortedList = []
      @length = 0

    push: (item) ->
      item.priority ?= 0
      item.timestamp = new Date()
      @sortedList.push item
      @sortedList.sort((a, b) -> 
        if a.priority is b.priority
          return a.timestamp - b.timestamp
        return a.priority - b.priority
      )
      ++@length
      return true

    shift: ->
      --@length
      return @sortedList.shift()

  class AJAXQueue
    constructor: (@availableConnections, @usePriority) ->
      if @usePriority
        @queue = new PriorityQueue() #PRIORITY Queue
      else
        @queue = [] # FIFO

    _increment: -> # increment available connections
      if @queue.length
        @next()
        return
      ++@availableConnections
      return

    _decrement: -> # decrement available connections
      --@availableConnections
      return

    _ajaxCall: (item) ->
      # Do something
      $.ajax(item)
      return

    put: (item) -> # Do checking and necessary changes to reflect
      # Validate the item in AJAX
      beforeSendFunction = item.beforeSend
      item.beforeSend = (jqXHR, settings) =>
        @_decrement()
        return beforeSendFunction?(jqXHR, settings)

      completeFunction = item.complete
      item.complete = (jqXHR, textStatus) =>
        console.log "complete"
        @_increment()
        return completeFunction?(jqXHR, textStatus)

      if @availableConnections is 0
        @queue.push(item)
      else
        @_ajaxCall(item)

      return true

    next: ->
      @_ajaxCall(@queue.shift())
      return

  return AJAXQueue
