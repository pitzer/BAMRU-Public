require 'mail'

class AlertMail

  def self.send

    mail = Mail.new do
      from    'mikel@test.lindsaar.net'
      to      'you@test.lindsaar.net'
      subject 'This is a test email'
      body    File.read('body.txt')
    end

    mail.to_s #=> "From: mikel@test.lindsaar.net\r\nTo: you@...

    mail = Mail.new do
      from     'me@test.lindsaar.net'
      to       'you@test.lindsaar.net'
      subject  'Here is the image you wanted'
      body     File.read('body.txt')
      add_file :filename => 'somefile.png', :content => File.read('/somefile.png')
    end

    mail.deliver!

  end

end