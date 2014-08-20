//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery-ui/draggable
//= require jquery-ui/droppable
//= require jquery-ui/datepicker
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require chosen-jquery
//= require bootstrap/modal
//= require bootstrap/dropdown
//= require bootstrap/scrollspy
//= require bootstrap/tab
//= require bootstrap/tooltip
//= require bootstrap/popover
//= require bootstrap/collapse
//= require bootstrap/carousel
//= require bootstrap/alert
//= require rails.validations
//= require rails.validations.simple_form
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive
//= require dnd
//= require experience_points
//= require infusion_pages
//= require issues
//= require knob
//= require lessons
//= require issues
//= require notes
//= require offerings
//= require problems
//= require reports
//= require resources
//= require standards
//= require static_pages
//= require students
//= require users

jQuery ->
  $('body').tooltip
    selector: "[data-toggle~='tooltip']"

  $("#datatable").dataTable
    pagingType: "simple_numbers"
    bPaginate: true  #hide pagination control
    bFilter: true    #hide filter control
    bJQueryUI: true

  $(".chosen").chosen()
  $(".chosen-select").chosen()
  $( "#sortable" ).sortable()
  $( "#sortable" ).disableSelection()
