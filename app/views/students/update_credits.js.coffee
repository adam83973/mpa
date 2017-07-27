jQuery ->
  $('#creditsModal').modal('hide')
  $('#totalCredits').delay(1000).replaceWith('<div id="totalCredits" data-totalCredits="<%= @student.credits %>">
  <h3>Credits: <%= @student.credits %></h3></div><!--/#totalCredits -->')
  $('#creditsModal form')[0].reset()