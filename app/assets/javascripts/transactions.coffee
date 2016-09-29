# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Listener on location field for credits modal to update products available at selected location
$transaction_product_id = $('#transaction_product_id')
$transaction_process = $('#transaction_process')
$transaction_location_id = $('#transaction_location_id')
$transaction_student_id = $('#transaction_student_id')

$transaction_process.on 'change', ->
  switch $(this).val()
    when '0'
      $('.transaction_location').show()
      $('.transaction_student').show()
    when '1'
      $('.transaction_location').show()
      $('.transaction_student').hide().val('')
    when '2','3'
      $('.transaction_location').show()
      $('.transaction_student').hide('')

$transaction_product_id.on 'change', ->
  if $transaction_process.val() is '2' || $transaction_process.val() is '3'
    $('.transaction_quantity').show()


$transaction_location_id.on 'change', ->
	$.ajax
		type:'get',
		url: '/products/products_by_location.json'
		data: {location_id: $(this).val(), credits: $transaction_product_id.data('credits')}
		dataType: 'JSON'
		success: (data, status, xhr) ->
			products = data
			$transaction_product_id.html("")
			$.each data, (index, value) ->
        $transaction_product_id.append($("<option></option>").attr("data-credits", value[2]).attr("value", value[0]).text(value[1]))
        $transaction_product_id.prop('disabled', false).trigger("chosen:updated").show()
        $(".transaction_product").show().find(".chosen-disabled").removeClass("chosen-disabled")
        $transaction_product_id.removeClass("disabled").prop('disabled', false)
        $transaction_product_id.chosen('destroy').chosen()

$transaction_credits_product_id = $('#transaction_credits_product_id')
$('#transaction_credits_location_id').on 'change', ->
	$.ajax
		type:'get',
		url: '/products/products_by_location.json'
		data: {location_id: $(this).val(), credits: true}
		dataType: 'JSON'
		success: (data, status, xhr) ->
			products = data
			$transaction_credits_product_id.html("")
			$.each data, (index, value) ->
        $transaction_credits_product_id.append($("<option></option>").attr("data-credits", value[2]).attr("value", value[0]).text(value[1]))
        $transaction_credits_product_id.prop('disabled', false).trigger("chosen:updated")
        # $(".transaction_product").show().find(".chosen-disabled").removeClass("chosen-disabled")
        # $transaction_credits_product_id.removeClass("disabled").prop('disabled', false)
        # $transaction_credits_product_id.chosen('destroy').chosen()
