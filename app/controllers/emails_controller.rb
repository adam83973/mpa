class EmailsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  def new
    @email = Email.new
    @employee_emails = []
    User.employees.each{ |employee| @employee_emails << "#{employee.full_name} <#{employee.email}>"}
    @employee_emails << "All Employees" << "All Teachers" << "All Teaching Assistants"
  end

  def create
    @email = Email.new(params[:email])
    @email.request = request

    @email.to_email.delete_if{ |email| email.empty? }

    case @email.to_email.first
    when "All Employees"
      @email.to_email.delete_if{ |email| email == "All Employees" }
      User.employees.each{ |employee| @email.to_email << "#{employee.email}"}
    when "All Teachers"
      @email.to_email.delete_if{ |email| email == "All Teachers" }
      User.teachers.each{ |employee| @email.to_email << "#{employee.email}"}
    when "All Teaching Assistants"
      @email.to_email.delete_if{ |email| email == "All Teaching Assistants" }
      User.teaching_assistants.each{ |employee| @email.to_email << "#{employee.email}"}
    end

    respond_to do |format|
      if @email.deliver
        format.html { redirect_to emails_path, notice: 'Message Sent.' }
      else
        flash.now[:error] = 'Cannot send message.'
        render :new
      end
    end
  end
end
