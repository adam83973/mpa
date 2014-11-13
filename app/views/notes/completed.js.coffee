
if document.getElementById("user_action_needed")
  $('#user_action_needed').html('<div style="height:300px;" class="panel panel-default">
  <div class="panel-heading">
  <h3 style="margin-bottom:0;" class="text-center">Needs Action: <%= @user_action_needed.count %></h3>
  </div>
  <div class="panel-body">
  <div style="margin-top:0;" class="notes">
  <ul class="list-unstyled">
  <% @user_action_needed.each do |note| %>
  <li>
  <%= escape_javascript(render "/shared/note_template", note: note) %>
  </li>
  <% end %>
  </ul>
  </div>
  </div>
  </div>')

if document.getElementById("user_note")
  $('#user_note').html('<%= escape_javascript(render "/users/user_notes") %>')

if document.getElementById("lead_notes")
  $('#lead_notes').html('<%= escape_javascript(render "/leads/lead_notes") %>')

if document.getElementById("student_notes")
  $('#student_notes').html('<%= escape_javascript(render "/students/students_notes") %>')

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