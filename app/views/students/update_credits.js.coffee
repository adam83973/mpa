jQuery ->
  $('#creditsModal').modal('hide')
  $('#totalCredits').delay(1000).replaceWith('<div id="totalCredits" style="text-align:center;" data-totalCredits="<%= @student.credits %>">
    <div class="circle-text">
    <div>
    <h4 style="margin-bottom:20px;">Total Credits</h4>
    <h1 style="font-size:5em;"><%= @student.credits %></h1>
    </div>
    </div>
    </div>')
  $('#creditsModal form')[0].reset()