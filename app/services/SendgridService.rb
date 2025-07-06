class SendgridService
  require 'net/http'
  require 'json'

  def self.send_email(to:, subject:, html_content:)
    uri = URI('https://api.sendgrid.com/v3/mail/send')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{ENV['SENDGRID_API_KEY']}"
    request['Content-Type'] = 'application/json'

    request.body = {
      personalizations: [{
        to: [{ email: to }]
      }],
      from: { email: 'preifma41@gmail.com' },
      subject: subject,
      content: [{ type: 'text/html', value: html_content }]
    }.to_json

    response = http.request(request)
    response.code == '202'
  end
end
