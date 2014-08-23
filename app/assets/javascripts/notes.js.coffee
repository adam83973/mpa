# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# ---- Lead Modal ----------------
# Handle lead ajax events ---
  $(".new_note").each ->
    $(this).bind 'ajax:beforeSend', (evt, xhr, settings) ->
      $submitButton = $(this).find('input[name="commit"]')
      $submitButton.attr( 'data-origText',  $submitButton.val() )
      $submitButton.val( "Submitting..." )
    .bind 'ajax:success', (evt, data, status, xhr) ->
      $form = $(this)
      $form[0].reset()
      alert "Note Added!"
    .bind 'ajax:complete', (evt, xhr, status) ->
      $submitButton = $(this).find('input[name="commit"]')
      $submitButton.val( $submitButton.data('origtext') )
      $lead_toolbar = $(this).closest('.lead_group').find('.lead_toolbar')
      $lead_toolbar.slideUp()
    .bind 'ajax:error', (evt, xhr, status, error) ->
      $submitButton = $(this).find('input[name="commit"]')
      $submitButton.val( $submitButton.data('origtext') )
      $form = $(this)
      alert "Note #{error}!"
      $form[0].reset()

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