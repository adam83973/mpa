jQuery ->
  if !(document.getElementById("lead_note") is null)
    $('#lead_note').replaceWith('<div id="lead_notes"><%= render "/leads/lead_notes" %></div>')