class OfferingsUsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin

  def index
    @offerings_users = OfferingsUser.order(:user_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offerings_users }
      format.csv { send_data @offerings_users.to_csv }
    end
  end

  def import
    OfferingsUser.import(params[:file])
    redirect_to offerings_users_path, notice: "User Class Assignment imported."
  end

  def user_name(offeringsstudents)
      student = User.find(offeringsstudents)
  end

  def destroy
    @offerings_user = OfferingsUser.where("offering_id = ?", params[:offering_id])
    @offerings_user.destroy
  end
end

#User.where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%").limit(10)

