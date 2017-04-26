# Manage opportunity creation from opportunity modal on admin home
# ---- Opportunity Modal ----------------
# Opportunity creation from home page.
# Once successfully submitted lookup parent modal is launched.
$("#new_opportunity")
.bind 'ajax:beforeSend', (evt, xhr, settings) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.attr( 'data-origText',  $submitButton.val() )
  $submitButton.val( "Submitting..." )
  # Stop submission if parent name is blank
  if !($('#opportunity_parent_name').val()) or $('#opportunity_parent_name').length is 0
    alert "You must enter a parent name."
    $submitButton.val( $submitButton.data('origtext') )
    false
  else if !($('#opportunity_location_id').val())
    alert "You must select a location."
    $submitButton.val( $submitButton.data('origtext') )
    false
  else if !($('#opportunity_parent_phone').val()) and !($('#opportunity_parent_email').val())
    alert "You must an email or phone number for this record."
    $submitButton.val( $submitButton.data('origtext') )
    false
.bind 'ajax:success', (evt, data, status, xhr) ->
  $form = $(this)
  $form[0].reset()
.bind 'ajax:complete', (evt, xhr, status) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $("#opportunityModal").modal('hide')
  #parent lookup modal launched see opportunities/create.js.coffee
.bind 'ajax:error', (evt, xhr, status, error) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $form = $(this)
  alert "Opportunity #{error}!"
  $form[0].reset()

# Reset new opportunity form if form is closed and reapply chosen on modal show
$("#opportunityModal").on 'shown.bs.modal', ->
    $('.opportunity_other_source').hide()
    $('.chosen').chosen('destroy').chosen()
    $('#opportunity_appointment_date, #opportunity_trial_date').datepicker
      dateFormat: 'yy-mm-dd'

$('#opportunity_source').on 'change', ->
  if $(this).val() is "7"
    $('.opportunity_other_source').show()
  else
    $('.opportunity_other_source').hide()
    $('#opportunity_other_source').val('')

# Reset new opportunity form if form is closed
$("#opportunityModal").on 'hide.bs.modal', ->
  $("#new_opportunity")[0].reset()

# When no match is found user clicks "no match" parent lookup modal is closed and new user modal is opened
$('#opporunityParentNoMatch').on 'click', ->
  $('#parentLookupModal').modal('hide')
  $('#newParentModal').modal('show')
  opportunity_id = $('#parent_lookup_table').data('opportunityid')
  $('#user_opportunity_id').val(opportunity_id)

# When no match is found user clicks "no match" student lookup modal is closed and new student modal is opened
$('#opporunityStudentNoMatch').on 'click', ->
  $('#addStudentInformationModal').modal('hide')
  $('#studentLookupModal').modal('hide')
  $('#newStudentModal').modal('show')
  opportunity_id = $('#student_lookup_table').data('opportunityid')
  user_id = $('#student_lookup_table').data('userid')
  $('#student_opportunity_id').val(opportunity_id)
  $('#student_user_id').val(user_id)

# If no student is found in the sytem launch new student form.
$('#opporunityStudentUserNoMatch').on 'click', ->
  $('#addStudentInformationModal').modal('hide')
  $('#newStudentModal').modal('show')
  opportunity_id = $(this).data('opportunityid')
  $('#student_opportunity_id').val(opportunity_id)

# If user does not want to add a student they can opt out by selecting skip.
$('#skipNewStudent').on 'click', ->
  if confirm "Are you sure you don't want to create a student account?"
    $('#new_student')[0].reset
    $('#newStudentModal').modal('hide')
    alert "Opportunity created!"
    location.reload()

$('#opporunityUserNoMatch').on 'click', ->
  $('#addUserInformationModal').modal('hide')
  $('#newParentModal').modal('show')
  opportunity_id = $(this).data('opportunityid')
  $('#user_opportunity_id').val(opportunity_id)

$('#addOpportunity').on 'click', ->
  $('#user_location_id').val($('#opportunity_location_id').val())
  $('#user_first_name').val(($('#opportunity_parent_name').val().split(" "))[0])
  $('#user_last_name').val(($('#opportunity_parent_name').val().split(" "))[1])
  $('#user_phone').val($('#opportunity_parent_phone').val())
  $('#user_email').val($('#opportunity_parent_email').val())
  $('#student_first_name').val($('#opportunity_student_name').val())

# Search possible contacts in Infusionsoft and render in table in add parent modal
$('#infusion_id_lookup').on 'click', ->
  $.ajax
    type: 'GET'
    url: "/infusion_pages/possible_contacts"
    data: search: $('#user_last_name').val()
    success: () ->

# Search possible contacts in Infusionsoft and render in table in add parent modal
$('.interest_level').on 'click', ->
  interest_level = $(this)
  $.ajax
    type: 'GET'
    url: "/opportunities/update_interest"
    data: { id: $(this).data('id'), interest_level: $(this).data('interest-level') }
    success: (data, textStatus, jqXHR) ->
      level = interest_level.data('interest-level')
      flame = interest_level.parent().siblings().first().find('.flame')
      switch level
        when 0
          flame.html('<i class="glyphicon glyphicon-fire pull-right"></i>')
        when 1
          flame.html('<i style="color:orange;" class="glyphicon glyphicon-fire pull-right"></i>')
        when 2
          flame.html('<i style="color:red;" class="glyphicon glyphicon-fire pull-right"></i>')
      alert 'Interest level updated.'

# Apply chosen to select fields when Opportunity Modal is loaded fix for chosen rendering after modal

$('#oppStudentInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#oppClassInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#addStudentInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#addUserInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

# Toggle opportunity information and actions from student show
$('.opportunity_info_toggle').on "click", ->
    $opp_info = $(this).closest('.card').find('.opportunity_info')
    if $opp_info.css("display") is "none"
      $opp_info.slideDown()
      $(this).find(".fa-chevron-down").removeClass("fa-chevron-down").addClass("fa-chevron-up")
    else
      $opp_info.slideUp()
      $(this).find(".fa-chevron-up").removeClass("fa-chevrone-up").addClass("fa-chevron-down")


$('.card-header').find('.add_to_class').on 'click', ->
  $registration_offering =  $('.registration_offering')
  $('#addToClassModal').modal('show')
  $('.registration_student').find('select').val($(this).data('studentid'))
  $registration_offering.find('select').val($(this).data('offeringid'))
  $registration_offering.find('.hidden').val($(this).data('offeringid'))
  $('#registration_opportunity_id').val($(this).data('opportunityid'))

# Convert opportunity to registration from student show.
$('.opportunity_info').find('.add_to_class').on 'click', ->
  $registration_offering =  $('.registration_offering')
  $registration_student = $('.registration_student')
  $('#addToClassModal').modal('show')
  $registration_offering.find('select').val($(this).data('offeringid'))
  $registration_offering.find('.hidden').val($(this).data('offeringid'))
  $registration_student.find('select').val($(this).data('studentid'))
  $registration_student.find('.hidden').val($(this).data('studentid'))
  $('#registration_opportunity_id').val($(this).data('opportunityid'))

# Manage trial date entry based on offering selection. Doesn't allow user to enter trial date
# without selecting offering first.
$opportunity_trial_date = $('#opportunity_trial_date')
$opportunity_offering_id = $('#opportunity_offering_id')

$opportunity_trial_date.on 'change', ->
  if $opportunity_offering_id.val()
  else
    $opportunity_trial_date.val('')
    $opportunity_trial_date.attr("disabled", "disabled")
    $('.opportunity_offering').addClass('has-warning')
    alert "You must select a class offering before adding a trial date."

$opportunity_offering_id.on 'change', ->
  if $opportunity_offering_id.val() and ($opportunity_trial_date.attr("disabled") is "disabled")
    $opportunity_trial_date.removeAttr("disabled")
  else if $opportunity_offering_id.val() is ''
    $opportunity_trial_date.val('')

# Show possible restart date field if possible restart is selected as status
$opportunity_status = $('#opportunity_status')
$opportunity_possible_restart_date = $('.opportunity_possible_restart_date')

$opportunity_status.on 'change', ->
  if $opportunity_status.val() is '6'
    $opportunity_possible_restart_date.show()
  else
    $opportunity_possible_restart_date.hide()

# Hide Show Opportunity Note Form
$('.status_attr').on "click", ->
  $opportunity_toolbar = $(this).closest('.opportunity_group').find('.opportunity_toolbar')
  if $opportunity_toolbar.css("display") is "none"
    $(this).find('.fa').removeClass('fa-plus').addClass('fa-minus')
    $opportunity_toolbar.slideDown()
    $opportunity_toolbar.find('input[id^="note_action_date"]').datepicker
      dateFormat: 'yy-mm-dd',
      changeMonth: true,
      changeYear:true
  else
    $opportunity_toolbar.slideUp()
    $(this).find('.fa').removeClass('fa-minus').addClass('fa-plus')


# ---- Opportunity Dashboard ----------------
dashboard = (id, fData) ->
  barColor = 'steelblue'

  # compute total for each location.
  segColor = (c) ->
    {
      'interested': '#2980b9'
      'appointment_scheduled': '#c0392b'
      'appointment_missed': '#27ae60'
      'trial': '#8e44ad'
      'undecided': '#d35400'
      'waitlisted': '#f39c12'
      'possible_restart': '#16a085'
    }[c]

  # function to handle histogram.

  histoGram = (fD) ->
    hG = {}
    hGDim =
      t: 60
      r: 0
      b: 30
      l: 0

    mouseover = (d) ->
      # utility function to be called on mouseover.
      # filter for selected state.
      st = fData.filter((s) ->
        s.location == d[0]
      )[0]
      nD = d3.keys(st.opportunities).map((s) ->
        {
          type: s
          opportunities: st.opportunities[s]
        }
      )
      # call update functions of pie-chart and legend.
      pC.update nD
      leg.update nD
      return

    mouseout = (d) ->
      # utility function to be called on mouseout.
      # reset the pie-chart and legend.
      pC.update tF
      leg.update tF
      return

    hGDim.w = 500 - (hGDim.l) - (hGDim.r)
    hGDim.h = 300 - (hGDim.t) - (hGDim.b)

    #create svg for histogram.
    hGsvg = d3.select(id).append('svg').attr('width', hGDim.w + hGDim.l + hGDim.r).attr('height', hGDim.h + hGDim.t + hGDim.b).append('g').attr('transform', 'translate(' + hGDim.l + ',' + hGDim.t + ')')
    # create function for x-axis mapping.
    x = d3.scaleBand().range([
      0
      hGDim.w
    ], 0.1).domain(fD.map((d) ->
      d[0]
    ))

    # Add x-axis to the histogram svg.
    hGsvg.append('g')
         .attr('class', 'x axis')
         .attr('transform', 'translate(0,' + hGDim.h + ')')
         .call   d3.axisBottom().scale(x)
    # Create function for y-axis map.
    y = d3.scaleLinear().rangeRound([
      hGDim.h
      0
    ]).domain([
      0
      d3.max(fD, (d) ->
        d[1]
      )
    ])

    # Create bars for histogram to contain rectangles and opportunities labels.
    bars = hGsvg.selectAll('.bar')
                .data(fD)
                .enter()
                .append('g')
                .attr('class', 'bar')

    #create the rectangles.
    bars.append('rect').attr('x', (d) ->
      x d[0]
    ).attr('y', (d) ->
      y d[1]
    ).attr('width', x.bandwidth()).attr('height', (d) ->
      hGDim.h - y(d[1])
    ).attr('fill', barColor).on('mouseover', mouseover).on 'mouseout', mouseout
    # mouseout is defined below.
    #Create the opportunities labels above the rectangles.
    bars.append('text').text((d) ->
      d3.format(',') d[1]
    ).attr('x', (d) ->
      x(d[0]) + x.bandwidth() / 2
    ).attr('y', (d) ->
      y(d[1]) - 5
    ).attr 'text-anchor', 'middle'

    # create function to update the bars. This will be used by pie-chart.
    hG.update = (nD, color) ->
      # update the domain of the y-axis map to reflect change in opportunities.
      y.domain [
        0
        d3.max(nD, (d) ->
          d[1]
        )
      ]
      # Attach the new data to the bars.
      bars = hGsvg.selectAll('.bar').data(nD)
      # transition the height and color of rectangles.
      bars.select('rect').transition().duration(500).attr('y', (d) ->
        y d[1]
      ).attr('height', (d) ->
        hGDim.h - y(d[1])
      ).attr 'fill', color
      # transition the opportunitiesuency labels location and change value.
      bars.select('text').transition().duration(500).text((d) ->
        d3.format(',') d[1]
      ).attr 'y', (d) ->
        y(d[1]) - 5
      return

    hG

  # function to handle pieChart.

  pieChart = (pD) ->
    pC = {}
    pieDim =
      w: 250
      h: 250

    # Utility function to be called on mouseover a pie slice.
    mouseover = (d) ->
      # call the update function of histogram with new data.
      hG.update fData.map((v) ->
        [
          v.location
          v.opportunities[d.data.type]
        ]
      ), segColor(d.data.type)
      return

    #Utility function to be called on mouseout a pie slice.

    mouseout = (d) ->
      # call the update function of histogram with all data.
      hG.update fData.map((v) ->
        [
          v.location
          v.total
        ]
      ), barColor
      return

    # Animating the pie-slice requiring a custom function which specifies
    # how the intermediate paths should be drawn.

    arcTween = (a) ->
      i = d3.interpolate(@_current, a)
      @_current = i(0)
      (t) ->
        arc i(t)

    pieDim.r = Math.min(pieDim.w, pieDim.h) / 2
    # create svg for pie chart.
    piesvg = d3.select(id).append('svg').attr('width', pieDim.w).attr('height', pieDim.h).append('g').attr('transform', 'translate(' + pieDim.w / 2 + ',' + pieDim.h / 2 + ')')
    # create function to draw the arcs of the pie slices.
    arc = d3.arc().outerRadius(pieDim.r - 10).innerRadius(0)
    # create a function to compute the pie slice angles.
    pie = d3.pie().sort(null).value((d) ->
      d.opportunities
    )
    # Draw the pie slices.
    piesvg.selectAll('path').data(pie(pD)).enter().append('path').attr('d', arc).each((d) ->
      @_current = d
      return
    ).style('fill', (d) ->
      segColor d.data.type
    ).on('mouseover', mouseover).on 'mouseout', mouseout
    # create function to update pie-chart. This will be used by histogram.

    pC.update = (nD) ->
      piesvg.selectAll('path').data(pie(nD)).transition().duration(500).attrTween 'd', arcTween
      return

    pC

  # function to handle legend.

  legend = (lD) ->
    leg = {}
    # create table for legend.
    legend = d3.select(id)
               .append('table')
               .attr('class', 'legend')
    # create one row per segment.
    tr = legend.append('tbody')
               .selectAll('tr')
               .data(lD)
               .enter()
               .append('tr')
    # create the first column for each segment.

    getLegend = (d, aD) ->
      # Utility function to compute percentage.
      d3.format(',.1%') d.opportunities / d3.sum(aD.map((v) ->
        v.opportunities
      ))

    tr.append('td')
      .append('svg')
      .attr('width', '16')
      .attr('height', '16')
      .append('rect')
      .attr('width', '16')
      .attr('height', '16')
      .attr 'fill', (d) ->
        segColor d.type

    # create the second column for each segment.
    tr.append('td').text (d) ->
      d.type

    # create the third column for each segment.
    tr.append('td').attr('class', 'legendFreq').text (d) ->
      d3.format(',') d.opportunities

    # create the fourth column for each segment.
    tr.append('td').attr('class', 'legendPerc').text (d) ->
      getLegend d, lD

    # Utility function to be used to update the legend.
    leg.update = (nD) ->
      # update the data attached to the row elements.
      l = legend.select('tbody').selectAll('tr').data(nD)
      # update the frequencies.
      l.select('.legendFreq').text (d) ->
        d3.format(',') d.opportunities
      # update the percentage column.
      l.select('.legendPerc').text (d) ->
        getLegend d, nD
      return

    leg

  fData.forEach (d) ->
    d.total = d.opportunities.interested + d.opportunities.appointment_scheduled + d.opportunities.appointment_missed + d.opportunities.trial + d.opportunities.undecided + d.opportunities.waitlisted + d.opportunities.possible_restart
    return

  # calculate total frequency by segment for all locations.
  tF = [
    'interested'
    'appointment_scheduled'
    'appointment_missed'
    'trial'
    'undecided'
    'waitlisted'
    'possible_restart'
  ].map((d) ->
    {
      type: d
      opportunities: d3.sum(fData.map((t) ->
        t.opportunities[d]
      ))
    }
  )
  # calculate total frequency by location for all segment.
  sF = fData.map((d) ->
    [
      d.location
      d.total
    ]
  )
  hG = histoGram(sF)
  pC = pieChart(tF)
  leg = legend(tF)

# only load if dashboard div exists.
if document.getElementById("dashboard") != null
  $.ajax
    type: 'GET'
    contentType: 'application/json; charset=utf-8'
    url: 'opportunities/data'
    dataType: 'json'
    success: (data) ->
      dashboard('#dashboard', data)
    error: (result) ->

aging_table = (aging_data, tickLables) ->
  # aging report
  width = 1300
  height = 500
  padding = 100
  data = []

  # flatten data to two dimensions
  for info, index in aging_data
    for opportunity in info.opportunities
      data.push [
                 opportunity.age
                 index + 1
                 opportunity.location_id
                 opportunity.id
                ]

  # create an svg container
  vis = d3.select('#aging_report')
          .append('svg:svg')
          .attr('width', width)
          .attr('height', height)

  # define the y scale  (vertical)
  yScale = d3.scaleLinear().domain([
    0
    tickLables.length
  ]).range([
    height - padding
    padding
  ])
  # map these to the chart height, less padding.
  #REMEMBER: y axis range has the bigger number first because the y value of zero is at the top of chart and increases as you go down.

  # define the x scale (horizontal)
  xScale = d3.scaleLinear().domain([
    1
    60
  ]).range([
    padding
    width - (padding * 2)
  ])
  # map these the the chart width = total width minus padding at both sides
  # define the y axis
  tickValues = Array(tickLables.length).fill().map((x,i)=>i+1)
  yAxis = d3.axisLeft(yScale).ticks(tickLables.length).tickValues(tickValues).tickFormat((d, i) -> tickLables[i].replace("_", "\n"))


  # define the y axis
  xAxis = d3.axisBottom(xScale).ticks(60, d3.format("d"))

  # draw y axis with labels and move in from the size by the amount of padding
  vis.append('g')
     .attr('transform', 'translate(' + padding + ',0)')
     .call yAxis
     .selectAll(".tick text")
     .call wrap

  # # draw x axis with labels and move to the bottom of the chart area
  vis.append('g')
     .attr('class', 'xaxis')
     .attr('transform', 'translate(0,' + (height - padding) + ')')
     .call xAxis

  # # text label for the x axis
  vis.append("text")
     .attr("transform",
            "translate(" + (width/2) + " ," + (height - padding/2) + ")")
     .style("text-anchor", "middle")
     .text("Days Old")

  # Add the scatterplot
  location_colors = [["#27ae60", "Powell"], ["#d35400", "New Albany"], ["#f39c12", "Mill Run"]]

  vis.selectAll("circle")
    .data(data)
    .enter()
    .append("a")
    .attr "xlink:href", (d) -> "/opportunities/#{d[3]}"
    .attr "target", "_blank"
    .append("circle")
    .attr("r", 3.5)
    .attr "cx", (d) ->
      if parseInt(d[0]) > 1 and parseInt(d[0]) < 60
        xScale(parseInt(d[0]))
    .attr "cy", (d) ->
      if parseInt(d[0]) > 1 and parseInt(d[0]) < 60
        yScale(d[1])
    .attr "fill", (d) ->
      if location_colors[d[2]-1]
        location_colors[d[2]-1][0]

  legendRectSize = 5;
  legendSpacing = .5;

  legend = vis.selectAll('.legend')
    .data(location_colors)
    .enter()
    .append('g')
    .attr('class', 'legend')
    .attr 'transform', (d, i) ->
      horz = width - padding * 3;
      vert = (i+1) * 15;
      'translate(' + horz + ',' + vert + ')';

  legend.append('circle')
    .attr('r', legendRectSize)
    .style('fill', (d) -> d[0])

  legend.append('text')
    .attr('x', legendRectSize + legendSpacing + 5)
    .attr('y', legendRectSize - legendSpacing)
    .text (d) -> d[1]


if document.getElementById("aging_report") != null
  $.ajax
    type: 'GET'
    contentType: 'application/json; charset=utf-8'
    url: 'opportunities/aging_data'
    dataType: 'json'
    success: (aging_data) ->
      tickLables = []
      for status in aging_data
        tickLables.push status.name
      aging_table aging_data, tickLables
    error: (result) ->

## Opportunity and business analytics
 # Step 2: Load the library.
if document.getElementById('auth-button')
  ((w, d, s, g, js, fjs) ->
    g = w.gapi or (w.gapi = {})
    g.analytics =
      q: []
      ready: (cb) ->
        @q.push cb
        return
    js = d.createElement(s)
    fjs = d.getElementsByTagName(s)[0]
    js.src = 'https://apis.google.com/js/platform.js'
    fjs.parentNode.insertBefore js, fjs

    js.onload = ->
      g.load 'analytics'
      return

    return
  ) window, document, 'script'
  gapi.analytics.ready ->
    # Step 3: Authorize the user.
    CLIENT_ID = '950777332412-sdf1umnm4gdolumd59jnvg0gu8771hth.apps.googleusercontent.com'
    gapi.analytics.auth.authorize
      container: 'auth-button'
      clientid: CLIENT_ID
    viewSelector = new (gapi.analytics.ViewSelector)(container: 'view-selector')
    timeline = new (gapi.analytics.googleCharts.DataChart)(
      reportType: 'ga'
      query:
        'dimensions': 'ga:date'
        'metrics': 'ga:sessions'
        'start-date': '30daysAgo'
        'end-date': 'yesterday'
      chart:
        type: 'LINE'
        container: 'timeline')
    gapi.analytics.auth.on 'success', (response) ->
      viewSelector.execute()
      return
    viewSelector.on 'change', (ids) ->
      newIds = query: ids: ids
      timeline.set(newIds).execute()
      return
    return

wrap = (text, width) ->
  text.each ->
    text = d3.select(this)
    words = text.text().split(/\s+/).reverse()
    word = undefined
    line = []
    lineNumber = 0
    lineHeight = 1.1
    y = text.attr('y')
    dy = parseFloat(text.attr('dy'))
    tspan = text.text(null).append('tspan').attr('x', 0).attr('y', y).attr('dy', dy + 'em')

    while word = words.pop()
      line.push word
      tspan.text line.join(' ')
      # if tspan.node().getComputedTextLength() > width
      line.pop()
      tspan.text line.join(' ')
      line = [ word ]
      tspan = text.append('tspan').attr('x', -20).attr('y', -12).attr('dy', ++lineNumber * lineHeight + dy + 'em').text(word)
    return
  return
