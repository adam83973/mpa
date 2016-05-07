//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery-ui/draggable
//= require jquery-ui/droppable
//= require jquery-ui/datepicker
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require bootstrap
//= require chosen-jquery
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
//= require p5.min
//= require processing_challenge_1
//= require processing_challenge_3
//= require reports
//= require resources
//= require standards
//= require static_pages
//= require students
//= require users
//= require enrollment_change_requests
//= require leads
//= require registrations
//= require opportunities
//= require timeline
//= require jscolor
//= require badges
//= require Chart

jscolor.dir = '/path/to/assets/'

jQuery ->
  $('body').tooltip
    selector: "[data-toggle~='tooltip']"

# -------------Highlight.js Initialization--------------------
  $(document).ready ->
    $('pre code').each (i, block) ->
      hljs.highlightBlock(block)

  $("#datatable").dataTable
    pagingType: "simple_numbers"
    bPaginate: true  #hide pagination control
    bFilter: true    #hide filter control
    bJQueryUI: true

  $(".chosen").chosen
    allow_single_deselect: true

  $(".chosen-select").chosen()

  $( "#sortable" ).sortable()
  $( "#sortable" ).disableSelection()

  $( ".datepicker" ).datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true

  $(".datepickerFutureOnly").datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    minDate: 1

  $(".datepickerTodayAndOn").datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    minDate: 0

  $( ".datepickerTwoWeeks" ).datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear:true,
    minDate: 15
