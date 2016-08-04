# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#assignment_offering_id').on 'change', ->
    offering_id = $(this).val()
    if offering_id
      $.ajax
        type: 'GET'
        url: '/offerings/course_id.json'
        data: id: offering_id
        dataType: 'JSON'
        error: (xhr) ->
          console.log xhr
        success: (data) ->
          $('#assignment_course_id').val(data)
    else
      $('#assignment_course_id').val(null)
