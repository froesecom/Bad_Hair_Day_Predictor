class UserMailer < ActionMailer::Base
  default from: "badhairdaypredictor@gmail.com"

  def contact_email(from_user, message)
    @from_user = from_user
    @message = message
    mail(to: 'froesecom@gmail.com', subject: 'Bad Hair Day')
  end
end
