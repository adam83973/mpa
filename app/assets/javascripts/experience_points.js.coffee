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

  $('.xp_chosen').chosen()

  $form = $('#new_experience_point') # cache

  $form.find(':input[type="submit"]').prop('disabled', true) # disable submit btn
  $form.on 'change', -> # monitor all inputs for changes
    disable = false
    $form.find(':input').not(':input[type="submit"]').not(':input[autocomplete="off"]').each (i, el) -> # test all inputs for values
      if $(el).val() == ''
        disable = true # disable submit if any of them are still blank
    $form.find(':input[type="submit"]').prop('disabled', disable)


