jQuery ->
  $('#user_action_needed').html('<h3>Needs Action: <%= @user_action_needed.count %></h3>
  <div class="notes">
  <ul class="list-unstyled">
  <% @user_action_needed.each do |note| %>
  <li>
  <%= escape_javascript(render "/shared/note_template", note: note) %>
  </li>
  <% end %>
  </ul>
  </div>')

  $('#notes').html('<div class="notes">
  <ul class="list-unstyled">
  <% @user_action_needed.each do |note| %>
  <li>
  <%= escape_javascript(render "/shared/note_template", note: note) %>
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