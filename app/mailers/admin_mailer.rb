class AdminMailer < ActionMailer::Base
  default from: "info@mathplusacademy.com"

  def return_from_hold(student)
    @user = student.user
    @student = student

    
  end
end
