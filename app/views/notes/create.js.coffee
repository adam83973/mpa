if document.getElementById("user_notes")
  $('#user_notes').html('<%= escape_javascript(render "/users/user_notes") %>')
else if document.getElementById("student_notes")
  $('#student_notes').html('<%= escape_javascript(render "/students/students_notes") %>')
else if document.getElementById("opportunity_notes")
  $('#opportunity_notes').html('<%= escape_javascript(render "/opportunities/opportunity_notes") %>')
else if document.getElementById("lesson_notes")
  $('#lesson_notes').html('<%= escape_javascript(render "/lessons/lesson_notes") %>')

  # Hide Show Note Info ---
$('.note_info_toggle').on "click", ->
  $note_info = $(this).closest('.card').find('.note_info')
  if $note_info.css("display") is "none"
    $note_info.slideDown()
    $(this).find(".fa-angle-double-down").removeClass("fa-angle-double-down").addClass("fa-angle-double-up")
  else
    $note_info.slideUp()
    $(this).find(".fa-angle-double-up").removeClass("fa-angle-double-up").addClass("fa-angle-double-down")

$(".notes #complete").on "click", ->
  if confirm "Has this task been completed?"
    note.completed($(this).val())
  else
    return false
