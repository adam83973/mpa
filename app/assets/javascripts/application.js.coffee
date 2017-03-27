//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/sortable
//= require jquery-ui/widgets/draggable
//= require jquery-ui/widgets/droppable
//= require jquery-ui/widgets/datepicker
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require tether
//= require bootstrap
//= require bootstrap-switch
//= require chosen-jquery
//= require d3
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require dnd
//= require assignments
//= require experience_points
//= require infusion_pages
//= require issues
//= require knob
//= require lessons
//= require help_sessions
//= require issues
//= require notes
//= require offerings
//= require problems
//= require processing_challenge_1
//= require processing_challenge_3
//= require reports
//= require resources
//= require standards
//= require static_pages
//= require students
//= require transactions
//= require users
//= require enrollment_change_requests
//= require leads
//= require registrations
//= require opportunities
//= require timeline
//= require jscolor
//= require badges
//= require Chart.min

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
    # bJQueryUI: true
    renderer:
      header: "jqueryui"
      pageButton: "jqueryui"

  $(".chosen").chosen
    allow_single_deselect: true

  $(".chosen-select").chosen()

  $( "#sortable" ).sortable()
  # $( "#sortable" ).disableSelection()

  $( ".datepicker" ).datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    yearRange: '1950:2019'

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
