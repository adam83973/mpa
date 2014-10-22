jQuery ->
  if !(document.getElementById("lead_notes") is null)
    $('#lead_notes').html('<%= escape_javascript(render "/leads/lead_notes") %>')

  if !(document.getElementById("students_notes") is null)
    $('#students_notes').html('<%= escape_javascript(render "/students/students_notes") %>')

  if !(document.getElementById("user_note") is null)
    $('#user_note').html('<%= escape_javascript(render "/users/user_notes") %>')

    # Hide Show Note Info ---
  $('.note_info_toggle').on "click", ->
    $note_info = $(this).closest('.well').find('.note_info')
    if $note_info.css("display") is "none"
      $note_info.slideDown()
      $(this).find(".fa-angle-double-down").removeClass("fa-angle-double-down").addClass("fa-angle-double-up")
    else
      $note_info.slideUp()
      $(this).find(".fa-angle-double-up").removeClass("fa-angle-double-up").addClass("fa-angle-double-down")