define 'ajax-queue', ['jquery'], ($) ->
  class Queue
    constructor: ->
      @list = []
      @length = 0

    push: ({spec}) ->
      item = {
        spec: spec
        id: id
      }
      @list.push item
      ++@length
      return true

    shift: ->
      --@length
      return @list.shift()

    remove: (id) ->
      for item, i in @list
        if item.id is id
          @list.splice(i, 1)
          return true
      return false

  class PriorityQueue extends Queue
    push: ({spec, priority, id}) ->
      item = {
        spec: spec
        priority: priority
        timestamp: new Date()
        id: id
      }
      @list.push item
      @list.sort((a, b) ->
        if a.priority is b.priority
          return a.timestamp - b.timestamp
        return a.priority - b.priority
      )
      ++@length
      return true

  class AsyncQueue
    constructor: (@availableConnections, @usePriority) ->
      @id = 0
      @working = {}
      if @usePriority
        @queue = new PriorityQueue() #PRIORITY Queue
      else
        @queue = new Queue() # FIFO

    _increment: -> # increment available connections
      if @queue.length
        @next()
        return
      ++@availableConnections
      return

    _decrement: -> # decrement available connections
      --@availableConnections
      return

    _ajaxCall: (spec) ->
      # Do something
      $.ajax(spec)
      return

    enqueue: (spec, priority = 5) -> # Do checking and necessary changes to reflect
      _this = this
      ++@id
      # Validate the spec in AJAX

      beforeSendFunction = spec.beforeSend
      spec.beforeSend = (jqXHR, settings) ->
        _this._decrement()
        _this.working[id] = jqXHR
        if beforeSendFunction?
          return beforeSendFunction.call(this, jqXHR, settings)
        return

      completeFunction = spec.complete
      spec.complete = (jqXHR, textStatus) ->
        _this._increment()
        delete _this.working[id]
        if completeFunction?
          return completeFunction?.call(this, jqXHR, textStatus)
        return

      if @availableConnections is 0
        @queue.push(spec, priority, id)
      else
        @_ajaxCall(spec)

      return {
        abort: =>
          return @abort(id)
      }

    next: ->
      @_ajaxCall(@queue.shift().spec)
      return

    abort: (id) ->
      # look in the queue, if found remove
      return true if @queue.remove(id)
      # look in the working, if found remove
      if @working[id]
        @working[id].abort?()
        delete @working[id]
        return true
      return false

  return AsyncQueue
