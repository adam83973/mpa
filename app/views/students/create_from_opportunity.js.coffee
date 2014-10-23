if document.getElementById("opportunity_show") is null
  # Hides student lookup modal
  $('#newStudentModal').modal('hide')

  alert "Opportunity has been added."
else
  alert "Student has been added."
  location.reload()