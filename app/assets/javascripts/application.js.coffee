//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery-ui/draggable
//= require jquery-ui/droppable
//= require jquery-ui/datepicker
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require chosen-jquery
//= require bootstrap/modal
//= require bootstrap/dropdown
//= require bootstrap/scrollspy
//= require bootstrap/tab
//= require bootstrap/tooltip
//= require bootstrap/popover
//= require bootstrap/collapse
//= require bootstrap/carousel
//= require bootstrap/alert
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive
//= require dnd
//= require experience_points
//= require infusion_pages
//= require issues
//= require knob
//= require lessons
//= require issues
//= require notes
//= require offerings
//= require problems
//= require reports
//= require resources
//= require standards
//= require static_pages
//= require students
//= require users
//= require enrollment_change_requests
//= require leads

jQuery ->
  $('body').tooltip
    selector: "[data-toggle~='tooltip']"

  $("#datatable").dataTable
    pagingType: "simple_numbers"
    bPaginate: true  #hide pagination control
    bFilter: true    #hide filter control
    bJQueryUI: true

  $(".chosen").chosen()
  $(".chosen-select").chosen()
  $( "#sortable" ).sortable()
  $( "#sortable" ).disableSelection()
  $( "#datepicker" ).datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear:true
  $( ".datepicker" ).datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear:true

  #!
  # * jQuery UI Touch Punch 0.2.3
  # *
  # * Copyright 2011–2014, Dave Furfero
  # * Dual licensed under the MIT or GPL Version 2 licenses.
  # *
  # * Depends:
  # *  jquery.ui.widget.js
  # *  jquery.ui.mouse.js
  #

  # Detect touch support

  # Ignore browsers without touch support

  ###*
  Simulate a mouse event based on a corresponding touch event
  @param {Object} event A touch event
  @param {String} simulatedType The corresponding mouse event
  ###
  simulateMouseEvent = (event, simulatedType) ->

    # Ignore multi-touch events
    return  if event.originalEvent.touches.length > 1
    event.preventDefault()
    touch = event.originalEvent.changedTouches[0]
    simulatedEvent = document.createEvent("MouseEvents")

    # Initialize the simulated mouse event using the touch event's coordinates
    # type
    # bubbles
    # cancelable
    # view
    # detail
    # screenX
    # screenY
    # clientX
    # clientY
    # ctrlKey
    # altKey
    # shiftKey
    # metaKey
    # button
    simulatedEvent.initMouseEvent simulatedType, true, true, window, 1, touch.screenX, touch.screenY, touch.clientX, touch.clientY, false, false, false, false, 0, null # relatedTarget

    # Dispatch the simulated event to the target element
    event.target.dispatchEvent simulatedEvent
    return
  $.support.touch = "ontouchend" of document
  return  unless $.support.touch
  mouseProto = $.ui.mouse::
  _mouseInit = mouseProto._mouseInit
  _mouseDestroy = mouseProto._mouseDestroy
  touchHandled = undefined

  ###*
  Handle the jQuery UI widget's touchstart events
  @param {Object} event The widget element's touchstart event
  ###
  mouseProto._touchStart = (event) ->
    self = this

    # Ignore the event if another widget is already being handled
    return  if touchHandled or not self._mouseCapture(event.originalEvent.changedTouches[0])

    # Set the flag to prevent other widgets from inheriting the touch event
    touchHandled = true

    # Track movement to determine if interaction was a click
    self._touchMoved = false

    # Simulate the mouseover event
    simulateMouseEvent event, "mouseover"

    # Simulate the mousemove event
    simulateMouseEvent event, "mousemove"

    # Simulate the mousedown event
    simulateMouseEvent event, "mousedown"
    return


  ###*
  Handle the jQuery UI widget's touchmove events
  @param {Object} event The document's touchmove event
  ###
  mouseProto._touchMove = (event) ->

    # Ignore event if not handled
    return  unless touchHandled

    # Interaction was not a click
    @_touchMoved = true

    # Simulate the mousemove event
    simulateMouseEvent event, "mousemove"


  ###*
  Handle the jQuery UI widget's touchend events
  @param {Object} event The document's touchend event
  ###
  mouseProto._touchEnd = (event) ->

    # Ignore event if not handled
    return  unless touchHandled

    # Simulate the mouseup event
    simulateMouseEvent event, "mouseup"

    # Simulate the mouseout event
    simulateMouseEvent event, "mouseout"

    # If the touch interaction did not move, it should trigger a click

    # Simulate the click event
    simulateMouseEvent event, "click"  unless @_touchMoved

    # Unset the flag to allow other widgets to inherit the touch event
    touchHandled = false


  ###*
  A duck punch of the $.ui.mouse _mouseInit method to support touch events.
  This method extends the widget with bound touch event handlers that
  translate touch events to mouse events and pass them to the widget's
  original mouse event handling methods.
  ###
  mouseProto._mouseInit = ->
    self = this

    # Delegate the touch handlers to the widget's element
    self.element.bind
      touchstart: $.proxy(self, "_touchStart")
      touchmove: $.proxy(self, "_touchMove")
      touchend: $.proxy(self, "_touchEnd")


    # Call the original $.ui.mouse init method
    _mouseInit.call self


  ###*
  Remove the touch event handlers
  ###
  mouseProto._mouseDestroy = ->
    self = this

    # Delegate the touch handlers to the widget's element
    self.element.unbind
      touchstart: $.proxy(self, "_touchStart")
      touchmove: $.proxy(self, "_touchMove")
      touchend: $.proxy(self, "_touchEnd")


    # Call the original $.ui.mouse destroy method
    _mouseDestroy.call self