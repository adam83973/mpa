jQuery ->
  $('#creditsModal').modal('hide').after ->
    $('#totalCredits').replaceWith('<h3>Total Credits: <%=raw @student.credits %></h3>').delay(800)
    $('#creditsModal form')[0].reset()