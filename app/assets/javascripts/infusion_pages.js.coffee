# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#infusion_page_startBillDate').datepicker
    dateFormat: 'yy-mm-dd'

  # add student's last attendance to infusion audit report.
  $('#load_attendance').on 'click', ->
    $.each $('.active-registration'), (index, value) ->
      $active_registration = $(this)
      student_id = $active_registration.data('student-id')
      $.ajax
        type:'get'
        url: '/students/last_attendance.json'
        data: { student_id: student_id }
        success: (data, status, xhr) ->
        dataType: 'JSON'
        complete: (data1) ->
          last_attendance = data1.responseText
          $active_registration.append("(#{last_attendance})")

  $('#end_subscription').bind 'click', ->
    $contactId = $('#end_subscription').data('contactid')
    if confirm "Would you like to cancel this subscription? OK to confirm."
      if confirm "Would you like the customer to receive a termination confirmation?"
        $.ajax
          type:'get'
          url: '/infusion_pages/add_to_terimination_sequence'
          data: { contactId: $contactId }
          success: (data, status, xhr) ->
            alert "Parent added to termination sequence."
          error: (data) ->
            alert "Error. Parent was not added to termination sequence."
      else
        true
    else
      false
