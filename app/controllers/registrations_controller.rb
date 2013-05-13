class RegistrationsController < Devise::RegistrationsController
  attr_accessible: :current_password

  attr_accessor :current_password

  prepend_before_filter :require_no_authentication, :only => []
  prepend_before_filter :authenticate_scope!

  def new
    super
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    super
  end
end