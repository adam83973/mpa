# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  $("#xp").dataTable
      bPaginate: true,  #hide pagination control
      bFilter: true,     #hide filter control
      bJQueryUI: true

  $('#experience_point_experience_id').change ->
    $.ajax
      type: 'POST'
      url: "/experience_points/points_lookup"
      data: experience_id: $('#experience_point_experience_id').val()
      success: (result) -> $('#experience_point_points').val(result)

  $("#experience_point_experience_id").chosen()