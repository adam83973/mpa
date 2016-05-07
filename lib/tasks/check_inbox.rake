require 'pp'

LABEL_ID = 'Label_1'

task :check_inbox => :environment do
  client = Google::APIClient.new
  client.authorization.access_token = Token.last.fresh_token
  service = client.discovered_api('gmail')
  result = client.execute(
    :api_method => service.users.messages.list,
    :parameters => {'userId' => 'me', 'labelIds' => ['INBOX', LABEL_ID]},
    :headers => {'Content-Type' => 'application/json'})

  messages = JSON.parse(result.body)['messages'] || []

  messages.each do |msg|
    details = get_details(msg['id'])
    send_to_slack(details)
    remove_label(msg['id'])
  end
end

def get_details(id)
  client = Google::APIClient.new
  client.authorization.access_token = Token.last.fresh_token
  service = client.discovered_api('gmail')
  result = client.execute(
    :api_method => service.users.messages.get,
    :parameters => {'userId' => 'me', 'id' => id, 'format' => 'full'},
    :headers => {'Content-Type' => 'application/json'})
  data = JSON.parse(result.body)

  body = Base64.decode64(data['payload']['parts'][0]['parts'][0]['body']['data']) if data['payload']['parts'][0]['parts'][0]['body']['data']

  puts body

  {subject: get_gmail_attribute(data, 'Subject'),
   from: get_gmail_attribute(data, 'From',),
   body: body}
end

def get_gmail_attribute(gmail_data, attribute)
  headers = gmail_data['payload']['headers']
  array = headers.reject { |hash| hash['name'] != attribute }
  array.first['value']
end

def remove_label(id)
  client = Google::APIClient.new
  client.authorization.access_token = Token.last.fresh_token
  service = client.discovered_api('gmail')
  client.execute(
    :api_method => service.users.messages.modify,
    :parameters => { 'userId' => 'me', 'id' => id },
    :body_object => { 'removeLabelIds' => [LABEL_ID] },
    :headers => {'Content-Type' => 'application/json'})
end

def send_to_slack(details)
  HTTParty.post("https://hooks.slack.com/services/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",
  {
    :body => {
      username: "Voicemail Received!",
      icon_emoji: ":mega:",
      attachments:
        [
          {
            fallback: "#{details[:body][0...20]}...",
            color: "#36a64f",
            pretext: "View message:",
            text: "#{details[:body]}"
          }
        ]
    }.to_json,
    :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  })
end
