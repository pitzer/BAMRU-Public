require 'gmail'

class AlertMail

  def self.send(msg = "BAMRU.org 500 error")

    gmail = Gmail.new(GMAIL_USER, GMAIL_PASS)

    alert_message = gmail.generate_message do
      to      EXCEPTION_ALERT_EMAILS
      from    "BAMRU.org"
      subject "BAMRU.org Exception (#{Time.now.strftime("%H:%M")})"
      body    msg
    end

    alert_message.deliver!

    gmail.logout

  end

end