# ---- Admin Page ----------------
# Hide schedule from admin view
jQuery ->
  # change locations
  $("#location_id").on 'change', ->
    id = $(this).val()
    url = "http://app.mathplusacademy.com?location_id=" + id
    window.location.replace(url)

  $( ".datepicker" ).datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear:true

  $("#hide_schedule").on 'click', ->
    if $("#hide_schedule").text() is "Hide Schedule"
      $(".daily-schedule").slideUp()
      $("#hide_schedule").text('Show Schedule')
    else if $("#hide_schedule").text() is "Show Schedule"
      $(".daily-schedule").slideDown()
      $("#hide_schedule").text('Hide Schedule')

# ---- Attendance Modal ----------------
  $('#attendanceModal').on 'shown.bs.modal', ->
    $('.chzn', this).chosen(
        allow_single_deselect: true
      )
    $submitButton = $("#attendance_form").find('input[name="commit"]').prop("disabled", true)
    $('#experience_point_student_id').on 'change', ->
      if $('#experience_point_student_id').val()
        $submitButton.prop("disabled", false)
  $('#attendanceModal').on 'hidden.bs.modal', ->
    location.reload()
# Handle attendance ajax events ---
  $("#attendance_form")
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.attr( 'data-origText',  $submitButton.val() )
    $submitButton.val( "Submitting..." )
  .bind 'ajax:success', (evt, data, status, xhr) ->
    $form = $(this)
    $form[0].reset()
    alert "Student Added!"
  .bind 'ajax:complete', (evt, xhr, status) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
    $('#experience_point_student_id_chosen').find('span').html('Select an Option')
    $('#experience_point_student_id_chosen').find('abbr').remove()
  .bind 'ajax:error', (evt, xhr, status, error) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
    $form = $(this)
    alert "Student #{error}!"
    $form[0].reset()
    $('#experience_point_student_id_chosen').find('abbr').remove()
    $('#experience_point_student_id_chosen').find('span').html('Select an Option')

# Autofocus student_id field on attendanceModal show ---
  $("#attendanceModal").on 'shown', ->
    $(this).find("[autofocus]:first").focus()

  $("#attendanceModal").on 'click', 'button', ->
    $(this).hide()
    location.reload()

# ---- Students Attending ----------------

  #add student through button on class roll
  $(".class_attendance_form")
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
    $submitButton = $(this).find('input[name="commit"]')
    $('div[id^="accordion"]').find('input[name="commit"]').attr("disabled", "disabled")
    $submitButton.attr( 'data-origText',  $submitButton.val() )
    $submitButton.val( "Submitting..." )
  .bind 'ajax:success', (evt, data, status, xhr) ->
    $form = $(this)
  .bind 'ajax:complete', (evt, xhr, status) ->
    $form = $(this)
    $form.hide()
    $('div[id^="accordion"]').find('input[name="commit"]').removeAttr("disabled")

  #remove student without reload
  $('.student_attending')
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
    studentName = $(this).data('studentname')
    if not confirm "Are you sure you want to remove #{studentName}?"
      xhr.abort()
      alert "#{studentName} was not removed from class."
  # .bind 'ajax:success', (evt, data, status, xhr) ->
  #   alert 'Student removed from class.'
  .bind 'ajax:complete', (evt, xhr, status) ->
    studentName = $(this).data('studentname')
    alert "#{studentName} was removed from class."
    $(this).hide 'fade'

  # Add code to cancel if user rejects confirm.
  # .bind 'ajax:error', (evt, xhr, status, error) ->
# ---- Start Class ----------------
  $('#offering_id').chosen()

  # Hide form on close. ---
  $classform = $('.classform')
  $classform.on 'click', ':submit', ->
    $classform.slideUp()

  $week = $('#week')
  $week.on 'keypress', ->
     if isNaN($week.val())
       alert 'Numbers only!'

  # Disable start class button until offering and week are selected. ---
  $('.classform #week').on "keyup", ->
    empty = false
    $week = $('#week')
    # $(".classform :input").each ->
    empty = true if $week.val() is ""
    if empty or isNaN($week.val())
      $("#startclass").attr("disabled")
    else
      $("#startclass").removeAttr("disabled")

# ---- Grades modal ----------------
  $('#grade_student_id')
                        .on('mouseover', ->
                          $('.modal-header').find('span.student_id').prop('hidden', false)
                          $('.modal-header').css('padding-bottom','0px'))
                        .on('mouseleave', ->
                          $('.modal-header').find('span.student_id').prop('hidden', true)
                          $('.modal-header').css('padding-bottom','20px'))
  $('#grade_lesson_id')
                        .on('mouseover', ->
                          $('.modal-header').find('span.lesson_id').prop('hidden', false)
                          $('.modal-header').css('padding-bottom','0px'))
                        .on('mouseleave', ->
                          $('.modal-header').find('span.lesson_id').prop('hidden', true)
                          $('.modal-header').css('padding-bottom','20px'))
  $('#grade_score')
                        .on('mouseover', ->
                          $('.modal-header').find('span.score').prop('hidden', false)
                          $('.modal-header').css('padding-bottom','0px'))
                        .on('mouseleave', ->
                          $('.modal-header').find('span.score').prop('hidden', true)
                          $('.modal-header').css('padding-bottom','20px'))
  $('#grade_experience_point_attributes_experience_id')
                        .on('mouseover', ->
                          $('.modal-header').find('span.homework_score').prop('hidden', false)
                          $('.modal-header').css('padding-bottom','0px'))
                        .on('mouseleave', ->
                          $('.modal-header').find('span.homework_score').prop('hidden', true)
                          $('.modal-header').css('padding-bottom','20px'))
  $('#grade_experience_point_attributes_comment')
                        .on('mouseover', ->
                          $('.modal-header').find('span.comment').prop('hidden', false)
                          $('.modal-header').css('padding-bottom','0px'))
                        .on('mouseleave', ->
                          $('.modal-header').find('span.comment').prop('hidden', true)
                          $('.modal-header').css('padding-bottom','20px'))

  $('#grade_experience_point_attributes_comment').on 'keypress', ->
    comment = $('#grade_experience_point_attributes_comment').val()
    $('#grade_comment').val(comment)

  $('#grade_experience_point_attributes_experience_id').on 'change', ->
    $.ajax
      type: 'POST'
      url: "/experience_points/points_lookup"
      data: experience_id: $('#grade_experience_point_attributes_experience_id').val()
      success: (result) -> $('#grade_experience_point_attributes_points').val(result)

  # Reset grades form when closed. ---
  $('#gradesModal :button').on( 'click', ->
    $("#gradesModal form")[0].reset())

  # Hide modal on close. ---
  $("#gradesModal").on('click', ':submit', ->
    $('#gradesModal').slideUp())

  # Add student's information to grades modal when link is clicked from student in list. ---
  $('.student_attending').on( 'click', 'a', ->
    student_id = $(this).data('student-id')
    week = $(this).data('week')
    lesson = $(this).data('lesson')
    $('#grade_experience_point_attributes_student_id').val(student_id)
    $('#grade_student_id').val(student_id)
    $('#grade_lesson_id').val(lesson))

# Disable submit button until input fields are populated. ---
  $(".modal-body-grades :input").on "keypress change", ->
    empty = false
    $(".modal-body-grades :input").each ->
      empty = true if $(this).val() is ""
      if empty
        $("#add-grade").attr "disabled", "disabled"
      else
        $("#add-grade").removeAttr "disabled"
