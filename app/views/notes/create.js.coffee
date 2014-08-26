jQuery ->
  if !(document.getElementById("lead_notes") is null)
    $('#lead_notes').html('<%= escape_javascript(render "/leads/lead_notes") %>')

  if !(document.getElementById("students_notes") is null)
    $('#students_notes').html('<%= escape_javascript(render "/students/students_notes") %>')

  if !(document.getElementById("user_note") is null)
    $('#user_note').html('<%= escape_javascript(render "/users/user_notes") %>')