jQuery ->
  $('#creditsModal').modal('hide')
  $('#totalCredits').delay(1000).replaceWith('<div id="totalCredits"><h3>Total Credits: <%=raw @student.credits %></h3></div>')
  $('#creditsModal form')[0].reset()