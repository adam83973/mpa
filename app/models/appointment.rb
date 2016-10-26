class Appointment < ActiveRecord::Base
  #attr_accessible :clientId, :locationId, :location_id, :reasonId, :time, :user_id, :calendarId, :visitMinutes, :note, :status, :hwHelpChild, :hwHelpClass, :hwHelpReason

  belongs_to :user
  belongs_to :location

  MY_CHILD = ["struggles with math or lack confident", "is bored and needs a challenge.", "is doing fine, but we are looking for more.", "..." ]

  def self.process(appointment_request)
    # response is appointment information type: JSON
    location_id = Location.where(check_appointments_id: appointment_request['location']['locationId']).first.id
    puts "Location #{location_id} cached"
    appointment_time = appointment_request['appointmentDateTimeClient'] ? DateTime.parse(appointment_request['appointmentDateTimeClient']) : DateTime.now
    puts "Appointment time cached"
    # see if parent is already associated with an appointment_id
    parent = User.find_by_check_appointments_id( appointment_request['client']['clientId'] )
    puts "Find parent by clientId"
    # if parent can't be found with appointment id and they have an email try searching with email
    if !parent && !appointment_request['client']['emailAddress'].empty?
      parent = User.find_by_email appointment_request['client']['emailAddress'].downcase
      puts "Find parent by email"
      if !parent
        generated_password = Devise.friendly_token.first(8)
        puts "Create parent"
        parent = User.create!(
                              check_appointments_id:    appointment_request['client']['clientId'],
                              first_name:               appointment_request['client']['firstName'],
                              last_name:                appointment_request['client']['lastName'],
                              location_id:              location_id,
                              email:                    appointment_request['client']['emailAddress'],
                              phone:                    appointment_request['client']['cellPhone'],
                              password:                 generated_password,
                              active:                   false,
                              role:                     "Parent")
      end
    end

    # Check to see if appointment already exists
    if appointment = find_by_calendarId(appointment_request['calendarId'])
      # Update appointment record if appointment exists
      appointment.update_attributes({
        reasonId:      appointment_request['reason']['reasonId'],
        visitMinutes:  appointment_request['reason']['visitMinutes'],
        time:          DateTime.parse(appointment_request['appointmentDateTimeClient']).to_time,
        note:          appointment_request['note'],
        status:        appointment_request['status']})
        puts "Appointment updated!"
    else
      appointment = create!(
                            clientId:      appointment_request['client']['clientId'],
                            calendarId:    appointment_request['calendarid'],
                            locationId:    appointment_request['location']['locationId'],
                            reasonId:      appointment_request['reason']['reasonId'],
                            visitMinutes:  appointment_request['reason']['visitMinutes'],
                            time:          DateTime.parse(appointment_request['appointmentDateTimeClient']),
                            user_id:       parent.id,
                            location_id:   location_id,
                            note:          appointment_request['note'],
                            status:        appointment_request['status']
                          )
      puts "Appointment created!"
    end

    # If appointment is hw help add related information.
    if appointment_request['reason']['reasonId'] == 37118
      puts "HW Help information added!"
      appointment.update_attributes({
        hwHelpChild:   appointment_request['fieldDataList'][4]['value'],
        hwHelpClass:   appointment_request['fieldDataList'][5]['value'],
        hwHelpReason:  appointment_request['fieldDataList'][6]['value']})
    end

    # If appointment is assessment post note to app and to slack_note_content
    if appointment_request['reason']['reasonId'] == 37117
      # Application note
      note = parent.notes.build({
        content: self.application_note_content(appointment_request, appointment),
        user_id: parent.system_admin_id,
        location_id: appointment.location_id,
        action_date: Date.today})

      note.save!
      puts "Application note added!"

      # Slack Message
      HTTParty.post("https://hooks.slack.com/services/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",
      {:body => {text: "Location: #{appointment.location.name}\n #{self.slack_note_content(appointment_request, appointment)}",
                  username: "Assessment Scheduled",
                  icon_emoji: ":smiley:",}.to_json,
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                  })
      puts "Slack message sent!"
    end
  end

  private

    def self.slack_note_content(appointment_request, appointment)
      assessment_fields = self.format_assessment_fields(appointment_request)

      content = ""

      assessment_fields.each_with_index{|(k, v), i| content += "#{k} #{v}\n" if !v.empty?}

      content += "Appointment: #{appointment.time.in_time_zone('Eastern Time (US & Canada)').strftime("%b %d,%l:%M%p")}"

      content
    end

    def self.application_note_content(appointment_request, appointment)
      assessment_fields = format_assessment_fields(appointment_request)
      "<strong>Please add #{'Opportunity'.pluralize(appointment['customField1'].to_i)}:</strong>\n" + slack_note_content(appointment_request, appointment)
    end

    def self.format_assessment_fields(appointment_request)
      puts appointment_request['fields'].inspect
      assessment_fields = {"Number Of Children:" =>  appointment_request['fields'][4]['value'],
                           "Child 1 Name:" =>        appointment_request['fields'][5]['value'],
                           "Child 1 Grade:" =>       appointment_request['fields'][6]['value'],
                           "Child 2 Name:" =>        appointment_request['fields'][7]['value'],
                           "Child 2 Grade:" =>       appointment_request['fields'][8]['value'],
                           "Child 3 Name:" =>        appointment_request['fields'][9]['value'],
                           "Child 3 Grade:" =>       appointment_request['fields'][10]['value'],
                           "My Child " =>            appointment_request['fields'][11]['value'],
                           "Comments:" =>            appointment_request['fields'][12]['value'],
                           "Source:" =>              appointment_request['fields'][13]['value']
                          }
      assessment_fields
    end
end
