class OfferingsStudentsController < ApplicationController
  def index
    @offeringsstudents = OfferingsStudent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offeringsstudents }
    end
  end

  def import
    OfferingsStudent.import(params[:file])
    redirect_to offerings_students_path, notice: "Students imported."
  end

  def student_name(offeringsstudents)
    student = Student.find(offeringsstudents)

  end
end


User.where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%").limit(10)