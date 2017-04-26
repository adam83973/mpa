# Hides parent lookup modal and sets overflow to scroll since content is loaded after modal.
$('#parentLookupModal').modal('hide')

# Launches parent lookup modal and sets overflow to scroll since content is loaded after modal.
$('#studentLookupModal').modal('show').css('overflow', 'scroll')

# Render parent lookup results in card table.
$('#studentLookupModal').find('#studentLookupBody').html('<%= escape_javascript(render "/opportunities/opportunity_student_lookup") %>')