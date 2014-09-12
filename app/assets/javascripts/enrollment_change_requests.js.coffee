# ------- EnrollmentChangeRequest javascript -------

$('#enrollment_change_request_type').on 'change', ->
  if $(this).val() is ""
    alert "Please make a selection"
  else if $(this).val() is "0"
    $('#hold_dates').show()
    $('#type_suggestions').hide()
    $('#hold_date_suggestions').show()
  else if $(this).val() is "1"
    $('#termination_date').show()