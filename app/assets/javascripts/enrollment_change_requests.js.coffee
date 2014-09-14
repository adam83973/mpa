# ------- EnrollmentChangeRequest javascript -------
# logic to controll completion of form
$enrollment_change_request_type = $('#enrollment_change_request_type')
$hold_dates = $('#hold_dates')
$type_suggestions = $('#type_suggestions')
$hold_date_suggestions = $('#hold_date_suggestions')
$termination_date_suggestions = $('#termination_date_suggestions')
$termination_date = $('#termination_date')
$enrollment_change_request_hold_return_date = $('#enrollment_change_request_hold_return_date')
$enrollment_change_request_end_date = $('#enrollment_change_request_end_date')
$enrollment_change_request_hold_start_date = $('#enrollment_change_request_hold_start_date')
$reason_id = $('#reason_id')
$billing_authorization = $('#billing_authorization')
$hold_date_suggestions = $('#hold_date_suggestions')
$reason_suggestions = $('#reason_suggestions')
$enrollment_change_request_reason_id = $('#enrollment_change_request_reason_id')
$other_reason = $('#other_reason')
$authorize_billing_suggestions = $('#authorize_billing_suggestions')
$submit_suggestions = $('#submit_suggestions')
$enrollment_change_request_submit = $('#enrollment_change_request_submit')

# logic for when change request type is selected
$enrollment_change_request_type.on 'change', ->
  if $(this).val() is ""
    alert "Please make a selection" # alert user to make selection of hold or termination
  else if $(this).val() is "0"
    # if hold is selected
    $hold_dates.show() # show field for hold dates
    $type_suggestions.hide() # hide suggestions for type when type is selected
    $hold_date_suggestions.show() # show help for filling in date fields
    $termination_date_suggestions.hide() # hide sugestions if type selection has changed
    $termination_date.hide() # hide dates if type selection has changed
    $enrollment_change_request_hold_return_date.attr('disabled', 'disabled')
  else if $(this).val() is "1"
    $type_suggestions.hide() # hide suggestions for type when type is selected
    $hold_date_suggestions.hide() # hide dates if type selection has changed
    $hold_dates.hide() # hide dates if type selection has changed
    $termination_date_suggestions.show() # show help for filling in date fields
    $termination_date.show() # show field for hold dates
    $enrollment_change_request_end_date.datepicker
      dateFormat: 'yy-mm-dd',
      changeMonth: true,
      changeYear: true,
      minDate: (+30)

# logic for when hold return date is added. disable type select box
$enrollment_change_request_hold_return_date.on 'change', ->
  if $enrollment_change_request_hold_start_date.val() is ""
    alert "Please select a date for the hold to begin."
  else if not isValidDate($enrollment_change_request_hold_start_date.val())
    alert "Date to start hold is not a valid date. yyyy-mm-dd"
  else
    $reason_id.show()
    $billing_authorization.show()
    $hold_date_suggestions.hide() # show help for filling in date fields
    $reason_suggestions.show() # show help for filling in date fields

# logic for termination whe end date is entered. disable the date field and the type select.
# remove disable attr from possible return date. Invalid date logic to ensure correct date is entered.
$enrollment_change_request_end_date.on 'change', ->
  if $enrollment_change_request_end_date.val() is ""
    alert "Please select a date for the hold to begin."
  else if not isValidDate($enrollment_change_request_end_date.val())
    alert "End is not a valid date. yyyy-mm-dd"
  else
    $(this).attr('disabled', 'disabled')
    $enrollment_change_request_type.attr('disabled', 'disabled')
    $('#enrollment_change_request_possible_return_date').removeAttr('disabled')
    $reason_id.show()
    $termination_date_suggestions.hide() # show help for filling in date fields
    $reason_suggestions.show() # show help for filling in date fields
    $('#enrollment_change_request_possible_return_date').datepicker
      dateFormat: 'yy-mm-dd',
      changeMonth: true,
      changeYear: true,
      minDate: new Date(new Date($enrollment_change_request_end_date.val()).getTime()+(2*24*60*60*1000))

# logic for hold when start date is entered. set to handle scenario when restart date is entered first.
# remove disabled attr from return field and initialize datepicker for return field with restricted date
# range greater than current day but no more than three months from current day.
$enrollment_change_request_hold_start_date.on 'change', ->
  if not isValidDate($enrollment_change_request_hold_start_date.val())
    alert "Date to start hold is not a valid date. yyyy-mm-dd"
  else if isValidDate($enrollment_change_request_hold_start_date.val()) and isValidDate($enrollment_change_request_hold_return_date.val())
    $enrollment_change_request_type.attr('disabled', 'disabled')
    $reason_id.show()
    $billing_authorization.show()
    $hold_date_suggestions.hide() # show help for filling in date fields
    $reason_suggestions.show() # show help for filling in date fields
  else
    $enrollment_change_request_type.attr('disabled', 'disabled')
    $enrollment_change_request_hold_return_date.removeAttr('disabled')
    minDate = new Date($enrollment_change_request_hold_start_date.val())
    daysToAdd = "2"
    $enrollment_change_request_hold_return_date.datepicker
      dateFormat: 'yy-mm-dd',
      changeMonth: true,
      changeYear: true,
      minDate: new Date(minDate.getTime()+(2*24*60*60*1000))
      maxDate: new Date(minDate.getTime()+(95*24*60*60*1000))

$enrollment_change_request_reason_id.on 'change', ->
  if $enrollment_change_request_reason_id.val() is "3" and $enrollment_change_request_type.val() is "0"
    $other_reason.show()
    $authorize_billing_suggestions.show()
    $reason_suggestions.hide() # hide help for filling in date fields
  else if $enrollment_change_request_reason_id.val() is "3" and $enrollment_change_request_type.val() is "1"
    $other_reason.show()
    $reason_suggestions.hide() # hide help for filling in date fields
    $submit_suggestions.show()
    $enrollment_change_request_submit.show()
    $('#customer_experience').show()
  else if $enrollment_change_request_type.val() is "1"
    $reason_suggestions.hide() # hide help for filling in date fields
    $submit_suggestions.show()
    $enrollment_change_request_submit.show()
    $('#customer_experience').show()
  else
    $other_reason.hide()
    $authorize_billing_suggestions.show()
    $reason_suggestions.hide() # hide help for filling in date fields

# Show submit button after billing authorization is accepted.
$('#enrollment_change_request_restart_billing_authorization').on 'change', ->
  $(this).attr("disabled", "disabled")
  if $(this).val() is "1"
    $enrollment_change_request_submit.show()

$('#enrollment_change_request_reset').on 'click', ->
  location.reload()

# Custom datepicker options for form date fields

$enrollment_change_request_hold_start_date.datepicker
  dateFormat: 'yy-mm-dd',
  changeMonth: true,
  changeYear: true,
  minDate: 0

###*
isValidDate(str)
@param string str value yyyy-mm-dd
@return boolean true or false
IF date is valid return true
###
isValidDate = (str) ->

  # STRING FORMAT yyyy-mm-dd
  return false  if str is "" or not str?

  # m[1] is year 'YYYY' * m[2] is month 'MM' * m[3] is day 'DD'
  m = str.match(/(\d{4})-(\d{2})-(\d{2})/)

  # STR IS NOT FIT m IS NOT OBJECT
  return false  if m is null or typeof m isnt "object"

  # CHECK m TYPE
  return false  if typeof m isnt "object" and m isnt null and m.size isnt 3
  ret = true #RETURN VALUE
  thisYear = new Date().getFullYear() #YEAR NOW
  minYear = 1999 #MIN YEAR

  # YEAR CHECK
  ret = false  if (m[1].length < 4) or m[1] < minYear or m[1] > thisYear

  # MONTH CHECK
  ret = false  if (m[1].length < 2) or m[2] < 1 or m[2] > 12

  # DAY CHECK
  ret = false  if (m[1].length < 2) or m[3] < 1 or m[3] > 31
  ret