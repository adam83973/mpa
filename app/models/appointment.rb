class Appointment < ActiveRecord::Base
  #attr_accessible :clientId, :locationId, :location_id, :reasonId, :time, :user_id, :calendarId, :visitMinutes, :note, :status, :hwHelpChild, :hwHelpClass, :hwHelpReason

  belongs_to :user
  belongs_to :location

  MY_CHILD = ["struggles with math or lack confident", "is bored and needs a challenge.", "is doing fine, but we are looking for more.", "..." ]

  def self.process(appointment_request)
    # response is appointment information type: JSON
    if Location.where(check_appointments_id: appointment_request['location']['locationId']).first
      location = Location.where(check_appointments_id: appointment_request['location']['locationId']).first
      location_id = location.id
      company = Company.find_by_subdomain(location.subdomain)
    else
      puts 'No valid location. Aborting appointment processing.'
      return
    end

    # format appointment DateTime
    appointment_time = appointment_request['appointmentDateTimeClient'] ? DateTime.parse(appointment_request['appointmentDateTimeClient']) : DateTime.now

    # see if parent is already associated with an appointment_id
    parent = User.find_by_check_appointments_id( appointment_request['client']['clientId'] )

    # if parent can't be found with appointment id and they have an email try searching with email
    if !parent && !appointment_request['client']['emailAddress'].empty?
      parent = User.find_by_email appointment_request['client']['emailAddress'].downcase
      if !parent
        generated_password = Devise.friendly_token.first(8)
        puts "Created parent."
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
    if appointment = find_by_calendarId(appointment_request['calendarid'])

      # Update appointment record if appointment exists
      appointment.update_attributes(reasonId:      appointment_request['reason']['reasonId'],
                                    visitMinutes:  appointment_request['reason']['visitMinutes'],
                                    time:          DateTime.parse(appointment_request['appointmentDateTimeClient']).to_time,
                                    note:          appointment_request['note'],
                                    status:        appointment_request['status'])
      puts 'Appointment updated.'
    else
      appointment = create!(clientId:      appointment_request['client']['clientId'],
                            calendarId:    appointment_request['calendarid'],
                            locationId:    appointment_request['location']['locationId'],
                            reasonId:      appointment_request['reason']['reasonId'],
                            visitMinutes:  appointment_request['reason']['visitMinutes'],
                            time:          DateTime.parse(appointment_request['appointmentDateTimeClient']),
                            user_id:       parent.id,
                            location_id:   location_id,
                            note:          appointment_request['note'],
                            status:        appointment_request['status'])

      puts 'Appointment created.'
      if appointment_request['status'] != "CANCELLED"
        # If appointment is assessment post note to app and to slack_note_content
        if appointment_request['reason']['reasonId'] == company.check_appointments_assessment_id
          self.slack_and_app_notifications(parent, appointment_request, appointment)
          puts 'Slack notification sent.'
        end
      end
    end

    # If appointment is hw help add related information.
    if appointment_request['reason']['reasonId'] == company.check_appointments_homework_help_id
      hw_help_info = self.format_hw_help_fields(appointment_request)

      if hw_help_info
        appointment.update_attributes(hwHelpChild:   hw_help_info["Child's Name"],
                                      hwHelpClass:   hw_help_info["Child's Class"],
                                      hwHelpReason:  hw_help_info["Reason for HW Help"])
      end
    end
  end

  private
    def self.slack_and_app_notifications(parent, appointment_request, appointment)
      # Application note
      note = parent.notes.build({content: self.application_note_content(appointment_request, appointment),
                                user_id: parent.class.system_admin_id,
                                location_id: appointment.location_id,
                                action_date: Date.today})

      note.save!

      if Rails.env.production?
        # Slack Message
        HTTParty.post("https://hooks.slack.com/services/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",
        {:body =>
          {text: "Location: #{appointment.location.name}\n#{self.note_content(appointment_request, appointment)}",
          username: "Assessment Scheduled",
          icon_emoji: ":smiley:",}.to_json,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
        })
      end
    end

    def self.note_content(appointment_request, appointment)
      content = appointment_request['customFieldDesc']

      content += "Appointment: #{appointment.time.in_time_zone('Eastern Time (US & Canada)').strftime("%b %d,%l:%M%p")}"

      content
    end

    def self.application_note_content(appointment_request, appointment)
      "Please add #{'Opportunity'.pluralize(appointment['customField1'].to_i)}:\n" + self.note_content(appointment_request, appointment)
    end

    def self.format_hw_help_fields(appointment_request)
      hw_help_fields = {}
      title_field_ids = [66355, 66357, 66359]
      if appointment_request['fields']
        appointment_request['fields'].each do |field|
          case field['schedulerPreferenceFieldDefnId']
          when *title_field_ids
            # add fields whose label needs titlized
            hw_help_fields["#{field['label']}"] = field['value']
          end
        end
      end

      hw_help_fields
    end
end
