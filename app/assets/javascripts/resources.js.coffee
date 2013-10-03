# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#resources_table").dataTable
      "bPaginate": true,   #hide pagination control
      "bFilter": true,     #hide filter control
      "bJQueryUI": true

  $('#new_resource').fileupload
    dataType: "script"
    add: (e, data) ->
        types = /(\.|\/)(gif|jpe?g|png|pdf)$/i
        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", data.files[0]))
          $('#new_resource').append(data.context)
          data.submit()
        else
          alert("#{file.name} is not an image or pdf file.")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')

  $('#resource_problem_ids').chosen()

  $('#resource_activity_ids').chosen()