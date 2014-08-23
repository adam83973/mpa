jQuery ->
  $('#user_action_needed').html('<h3>Needs Action: <%= @user_action_needed.count %></h3>
  <div class="notes">
  <ul class="list-unstyled">
  <% @user_action_needed.each do |note| %>
  <li>
  <div class="well well-sm">
  <p>
  "<%= note.content %>"
  </p>
  <hr style="margin:0 0 10px 0;">
  <div class="row">
  <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
  <div class="checkbox" style="margin:0;">
  <label>
  <%= check_box_tag "complete", "#{note.id}" %> Completed
  </label>
  </div>
  </div>
  <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
  <%= note.user.full_name%> (<%= note.created_at.strftime("%D")%>)
  </div>
  </div>
  </div>
  </li>
  <% end %>
  </ul>
  </div>')

  #click listener to mark note completed when checkbox is clicked
  $(".notes #complete").on "click", ->
    if confirm "Has this task been completed?"
      note.completed($(this).val())
    else
      return false


  #AJAX call to mark note completed
  note =
    completed: (note_id) ->
      $note_id = note_id
      $.ajax
        type: 'POST'
        url: '/notes/completed'
        data: id: note_id
        error: (xhr) ->
          console.log xhr
        success: (data) ->