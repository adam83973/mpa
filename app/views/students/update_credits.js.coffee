jQuery ->
  $('#creditsModal').modal('hide')
  $('#totalCredits').delay(1000).replaceWith('<div id="totalCredits" data-totalCredits="<%= @student.credits %>">
  <div class="circle-text">
  <div>
  <h1 style="float:center;">Credits</h1>
  <h2><%= @student.credits %></h2>
  </div>
  </div><!--/.circle-text -->
  </div><!--/#totalCredits -->')
  $('#creditsModal form')[0].reset()