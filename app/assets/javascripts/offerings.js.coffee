# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#offerings").dataTable
      "bPaginate": true,  #hide pagination control
      "bFilter": true,     #hide filter control
      "bJQueryUI": true,

  $('#capacity_check').on 'click', ->
    $.get "/offerings/at_capacity.json", {id: $(this).data('id')},(data) ->
      if data == "false"
        alert "Offering is not full!"
      else
        alert "Offering is full!"
