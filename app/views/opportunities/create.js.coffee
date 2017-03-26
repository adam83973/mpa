# Launches parent lookup modal and sets overflow to scroll since content is loaded after modal.
$('#parentLookupModal').modal('show').css('overflow', 'scroll')

# Render parent lookup results in card table.
$('#parentLookupModal').find('#parentLookupBody').html('<%= escape_javascript(render "/opportunities/opportunity_parent_lookup") %>')