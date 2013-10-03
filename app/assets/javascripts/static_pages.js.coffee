# ---- Attendance Modal ----------------
  # Hide attendance modal and reload page. ---
# .on('click', 'button', ->
#     $(this).hide()
#     location.reload())
# Handle ajax events ---
jQuery ->
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
  $('.students_attending').on('mouseover', -> $(this).css({"background-color":"#fbfbfb"; "border":"1px solid black"}))
                          .on('mouseleave', -> $(this).css({ "background-color":"##e4e4e4"; "border":"1px solid white"}))
                          .on('mouseover', 'a:not(:nth-child(2))', -> $(this).css({'color':'black'}))
                          .on('mouseleave', 'a:not(:nth-child(2))', -> $(this).css({'color':'#0088cc'}))

# Hide form on close. ---
  $classform = $('.classform')
  $classform.on('click', ':submit'
    -> $classform.slideUp())

# Disable start class button until offering and week are selected. ---
  $('.classform :input').on "keypress change", ->
    empty = false
    $(".classform :input").each ->
      empty = true if $(this).val() is ""
      if empty
        $("#startclass").attr "disabled", "disabled"
      else
        $("#startclass").removeAttr "disabled"

# ---- Grades modal ----------------

  # Reset grades form when closed. ---
  $('#gradesModal :button').on( 'click', ->
    $("#gradesModal form")[0].reset())

  # Hide modal on close. ---
  $("#gradesModal").on('click', ':submit', ->
    $('#gradesModal').slideUp())

  # Add student's information to grades modal when link is clicked from student in list. ---
  $('.students_attending').on( 'click', 'a', ->
    student_id = $(this).data('student-id')
    week = $(this).data('week')
    $('#grade_student_id').val(student_id)
    $('#grade_lesson_id').val(week))

# Disable submit button until input fields are populated. ---
  $(".modal-body-grades :input").on "keypress change", ->
    empty = false
    $(".modal-body-grades :input").each ->
      empty = true if $(this).val() is ""
      if empty
        $("#add-grade").attr "disabled", "disabled"
      else
        $("#add-grade").removeAttr "disabled"