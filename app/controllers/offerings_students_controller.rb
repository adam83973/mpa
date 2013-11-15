class OfferingsStudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin

  def index
    @offeringsstudents = OfferingsStudent.order(:student_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offeringsstudents }
      format.csv { send_data @offeringsstudents.to_csv }
    end
  end

  def import
    OfferingsStudent.import(params[:file])
    redirect_to offerings_students_path, notice: "Students imported."
  end

  def student_name(offeringsstudents)
      student = Student.find(offeringsstudents)
  end

  def destroy
    @offerings_student = OfferingsStudent.where("offering_id = ?", params[:offering_id])
    @offerings_student.destroy
  end
end

#User.where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%").limit(10)

