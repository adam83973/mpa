# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('#new_badge').fileupload
  dataType: "script"
  add: (e, data) ->
    types = /(\.|\/)(gif|jpe?g|png|pdf)$/i
    file = data.files[0]
    if types.test(file.type) || types.test(file.name)
      data.context = $(tmpl("template-upload", data.files[0]))
      $('#new_badge').append(data.context)
      data.submit()
    else
      alert("#{file.name} is not an image or pdf file.")
  progress: (e, data) ->
    if data.context
      progress = parseInt(data.loaded / data.total * 100, 10)
      data.context.find('.progress-bar').css('width', progress + '%')

# Badge request processing
$('.badge-request-approval').on 'click', ->
  card = $(this).closest('li')
  button = $(this)
  badge_request_id = $(this).closest('li').data('badge-request-id')
  button.attr('disabled','disabled');

  $.ajax
    type: 'GET'
    url: "/badge_requests/approval"
    data: id: badge_request_id
    error: (xhr, status, error) ->
      alert "#{error}"
      button.removeAttr('disabled')
    success: (result) ->
      alert "Approved!"
      card.remove()

# Badge request form submission
$write_up = $('#badge_request_write_up')

$('#badge_request_badge_id').on 'change', ->
  badge_id = $(this).val()

  if badge_id
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: "/badges/write_up_required"
      data: id: badge_id
      error: (xhr, status, error) ->
        alert "#{error}"
      success: (result) ->
        if result
          $('.badge_request_write_up').show()
          $write_up.data('writeup-required','true')
        else
          $('.badge_request_write_up').hide()
          $write_up.data('writeup-required','false')
  else
    $('.badge_request_write_up').hide()
    $write_up.data('writeup-required','false')


$('#new_badge_request').on 'click', 'input[type="submit"]', ->
  $write_up = $('#badge_request_write_up')
  $student_id = $('#badge_request_student_id')
  $badge_id = $('#badge_request_badge_id')

  academic_integrity = "By submitting this request you certify that your student has completed the requirements for this badge. For more information about badge requirements please see the button labeled \'More Info\'.\n \nYou also agree that this student has adhered to our policy of academic integrity.\n \nAcademic integrity includes a commitment to the values of honesty, trustworthiness, fairness, and respect. These values are essential to the overall success of an academic society."

  if $write_up.data('writeup-required') and $write_up.val()
    if $badge_id.val() and $student_id.val()
      confirm academic_integrity
    else
      alert 'Make sure you select a student and a badge.'
      false
  else if $write_up.data('writeup-required') and not $write_up.val()
    alert 'You must complete a write-up and submit it with this badge.'
    false
  else
    if $badge_id.val() and $student_id.val()
      confirm academic_integrity
    else
      alert 'Make sure you select a student and a badge.'
      false
