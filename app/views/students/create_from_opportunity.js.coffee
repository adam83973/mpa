if document.getElementById("opportunity_show") is null
  # Hides new student modal
  $('#newStudentModal').modal('hide')
  alert "Opportunity has been added."
  location.reload()

else
  alert "Student has been added."
  location.reload()