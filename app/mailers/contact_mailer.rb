class ContactMailer < ApplicationMailer
  def send_contact(from,subject,message)
    @from = from
    @subject = subject
    @message = message

    mail to: "andriyyy@gmail.com", subject:@subject
  end

end