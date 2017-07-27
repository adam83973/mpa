# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# update product inventory via products table
$('.update-product-quantity').on 'click', ->
  id = $(this).closest('td').data('id')
  $('#product_id').val(id)
  $('#update-quantity-modal').modal('show')

$('#update-quantity-modal').on 'shown.bs.modal', ->
  $('#product_quantity').focus()

$('#update-product-quantity')
.bind 'ajax:success', (evt, data, status, xhr) ->
  $form = $(this)
  id = $form.find('#product_id').val()
  $("table").find("td[data-id='" + id + "']").html("<a class='update-product-quantity' href='javascript:void(0)''>#{$('#product_quantity').val()}</a>")
  $form[0].reset()
.bind 'ajax:complete', (evt, data, status, xhr) ->
  $('#update-quantity-modal').modal('hide')
  $('.update-product-quantity').on 'click', ->
    id = $(this).closest('td').data('id')
    $('#product_id').val(id)
    $('#update-quantity-modal').modal('show')
