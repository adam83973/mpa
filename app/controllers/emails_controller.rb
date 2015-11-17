class EmailsController < ActionController::Base
  def show
    @email = Ahoy::Message.where(token: params[:token]).first
    @user = User.find(params[:id])

    if @email
      respond_to do |format|
        format.html
        format.json { render json: @resource }
      end
    else
      redirect_to @user, alert: "It doesn't look like this email was saved correctly."
    end
  end
end
