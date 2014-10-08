jQuery ->
  if !(document.getElementById("lead_notes") is null)
    $('#lead_notes').html('<%= escape_javascript(render "/leads/lead_notes") %>')

  if !(document.getElementById("students_notes") is null)
    $('#students_notes').html('<%= escape_javascript(render "/students/students_notes") %>')

  if !(document.getElementById("user_note") is null)
    $('#user_note').html('<%= escape_javascript(render "/users/user_notes") %>')

  if !(document.getElementById("opportunity_notes") is null)
    $('#opportunity_notes').html('<%= escape_javascript(render "/opportunities/opportunity_notes") %>')

  $("#opportunity<%= @opportunity.id %>").siblings('.opportunity_toolbar').find('.last_note').html('<%= @opportunity.notes.last ? @opportunity.notes.last.content : "None" %> <%= @opportunity.notes.last ? "(#{@opportunity.notes.last.created_at.strftime("%D")})" : "" %>')