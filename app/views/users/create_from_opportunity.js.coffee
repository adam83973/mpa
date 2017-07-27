if document.getElementById("opportunity_show") is null
  # Hides modal after parent is created.
  $('#newParentModal').modal('hide')

  # Launches student lookup modal and sets overflow to scroll since content is loaded after modal.
  $('#studentLookupModal').modal('show').css('overflow', 'scroll')

  # Render student lookup results in card table.
  $('#studentLookupModal').find('#studentLookupBody').html('<%= escape_javascript(render "/opportunities/opportunity_student_lookup") %>')
else
  alert "Parent has been added."
  location.reload()