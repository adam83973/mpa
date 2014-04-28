# ---- Admin Page ----------------
# Hide schedule from admin view
jQuery ->
  $("#hide_schedule").on 'click', ->
    if $("#hide_schedule").text() is "hide schedule"
      $(".daily-schedule").slideUp()
      $("#hide_schedule").text('show schedule')
    else if $("#hide_schedule").text() is "show schedule"
      $(".daily-schedule").slideDown()
      $("#hide_schedule").text('hide schedule')


# ---- Leads JS ----------------
# Hide Show Lead Note Form ---
  $('.stage_attr').on "click", ->
    $lead_toolbar = $(this).closest('.lead_group').find('.lead_toolbar')
    if $lead_toolbar.css("display") is "none"
      $lead_toolbar.slideDown()
    else
      $lead_toolbar.slideUp()

# ---- Lead Modal ----------------
# Handle lead ajax events ---
  $("#new_lead")
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.attr( 'data-origText',  $submitButton.val() )
    $submitButton.val( "Submitting..." )
  .bind 'ajax:success', (evt, data, status, xhr) ->
    $form = $(this)
    $form[0].reset()
    alert "Lead Added!"
    setTimeout ->
      location.reload()
    , 1000
  .bind 'ajax:complete', (evt, xhr, status) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
    $("#leadModal").modal('hide')
  .bind 'ajax:error', (evt, xhr, status, error) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
    $form = $(this)
    alert "Lead #{error}!"
    $form[0].reset()

# ---- Lead Modal ----------------
# Handle note ajax events --- see note.js.coffee

  $('#stage_list').find('.lead_toolbar').each ->
    $(this).css("display", "none")

# ---- Attendance Modal ----------------
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
  .bind 'ajax:error', (evt, xhr, status, error) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
    $form = $(this)
    alert "Student #{error}!"
    $form[0].reset()

# Autofocus student_id field on attendanceModal show ---
  $("#attendanceModal").on 'shown', ->
    $(this).find("[autofocus]:first").focus()

  $("#attendanceModal").on 'click', 'button', ->
    $(this).hide()
    location.reload()

# ---- Students Attending ----------------
  # Update styling to attending students on mouse over and leave. ---
  $('.student_attending').on('mouseover', -> $(this).css({"background-color":"#fbfbfb"; "border":"1px solid black"}))
                          .on('mouseleave', -> $(this).css({ "background-color":"##e4e4e4"; "border":"1px solid white"}))
                          .on('mouseover', 'a:not(:nth-child(2))', -> $(this).css({'color':'black'}))
                          .on('mouseleave', 'a:not(:nth-child(2))', -> $(this).css({'color':'#0088cc'}))

  #add student through button on class roll
  $(".class_attendance_form")
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.attr( 'data-origText',  $submitButton.val() )
    $submitButton.val( "Submitting..." )
  .bind 'ajax:success', (evt, data, status, xhr) ->
    $form = $(this)
  .bind 'ajax:complete', (evt, xhr, status) ->
    $form = $(this)
    $form.hide()

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

  # Hide form on close. ---
  $classform = $('.classform')
  $classform.on 'click', ':submit', ->
    $classform.slideUp()

  $week = $('#week')
  $week.on 'keypress', ->
     if isNaN($week.val())
       alert 'Numbers only!'

  # Disable start class button until offering and week are selected. ---
  $('.classform :input').on "keypress change", ->
    empty = false
    $(".classform :input").each ->
      empty = true if $(this).val() is ""
      $week = $('#week')
      if empty or isNaN($week.val())
        $("#startclass").prop "disabled", true
      else
        $("#startclass").prop "disabled", false

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