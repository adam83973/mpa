jQuery ->
  ignoreDrag = (e) ->
    e.originalEvent.stopPropagation()
    e.originalEvent.preventDefault()

  onDrop = (e) ->
    e.preventDefault()


  $('div[id^="lead"]').on 'click', ->
    console.log "clicked"

  $("#assessment_completed")
    .bind('dragenter', ignoreDrag)
    .bind('dragover', ignoreDrag)
    .bind('drop', onDrop)

  $('div[id^="lead"]').draggable ->
    $dragged = $(this)
  $(".leads").droppable drop: (event, ui) ->
    $dropP = $(this).find("p")
    $dropP.html( "Lead Updated!" )
    drop.update($(this).attr('id'),$(ui.draggable).data('id'))
    $(ui.draggable).empty().remove()
    setTimeout ->
      $dropP.fadeOut()
    , 2000


drop =
  update: (dragged_id, received_id) ->
    $.ajax
      type: 'POST'
      url: "/leads/update_stage"
      data: { id: received_id, stage: dragged_id }
      success: (result) ->