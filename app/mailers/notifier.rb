class Notifier

  def self.welcome(developer, url)
    message = Mail.new do
      from Settings.admin_email
      to developer.email
      subject 'Mogade Account Registration'
      html_part do
        content_type 'text/html; charset=UTF-8'
        body Notifier.append_environment_warning + <<-eos
          <p>Hi #{developer.name},</p>
          <p>You recently registered for an account at mogade.com. To complete the process, please click on the following link:</p>
          <p><a href="#{url}">#{url}</a></p>
          <p>Sincerely,<br />Mogade</p>
        eos
      end
    end
    message.delivery_method(Mail::Postmark, :api_key => Settings.postmark_key)
    message.deliver
   end
   
   def self.send_password(developer, url)
     message = Mail.new do
       from Settings.admin_email
       to developer.email
       subject 'Mogade Password Reset'
       html_part do
         content_type 'text/html; charset=UTF-8'
         body Notifier.append_environment_warning + <<-eos
           <p>Hi #{developer.name},</p>
           <p>A request was recently made to reset your password. If you did't make this request, or if you found your original password, you can safely ignore this message:</p>
           <p>Otherwise, to reset your password, click on the following link:</p>
           <p><a href="#{url}">#{url}</a></p>
           <p>The above link will expire in 24 hours</p>
           <p>Sincerely,<br />Mogade</p>
         eos
       end
     end
     message.delivery_method(Mail::Postmark, :api_key => Settings.postmark_key)
     message.deliver  
   end
   
   private 
   def self.append_environment_warning
     return '' if Rails.env == 'production'     
     "<p>NOT PRODUCTION</p><p>This email was sent from a testing environment (#{Rails.env})</p>"
   end
end
