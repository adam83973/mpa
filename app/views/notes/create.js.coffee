jQuery ->
  if !(document.getElementById("lead_note") is null)
    $('#lead_note').html('<%= render "/leads/lead_notes" %>')

  if !(document.getElementById("student_note") is null)
    $('#student_note').html('<%= render "/students/students_notes" %>')

  if !(document.getElementById("user_note") is null)
    $('#user_note').html('<%= render "/users/user_notes" %>')