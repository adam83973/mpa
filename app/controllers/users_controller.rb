class UsersController < ApplicationController
  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    ########
    if @user.role == "Parent" && @user.infusion_id != nil
      # retrieve subscriptions for contact
      @active_subscription = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => @user.infusion_id}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
      # loop through array of hashes and remove inactive subscriptions
      @active_subscription.delete_if {|i| i["Status"] == "Inactive"}
      # attach subscription plan names
      @active_subscription.each do |i|
        subscriptions.each do |j|
          if i["ProgramId"].to_i == j["Id"].to_i
            i["ProgramName"] = j["ProgramName"]
          end
        end
      end

      # get invoices and display recent ones
      @invoices = Infusionsoft.data_query_order_by('Invoice', 10, 0, {:ContactId => @user.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
      @invoices.each do |i|
        if i["PayStatus"] == 0
          i["Status"] = "<span class='label label-important'>Unpaid</span>"
        elsif i["RefundStatus"] == 1
          i["Status"] = "<span class='label label-warning'>Partial Refund</span>"
        elsif i["RefundStatus"] == 2
          i["Status"] = "<span class='label label-warning'>Full Refund</span>"
        else
          i["Status"] = "<span class='label label-success'>Paid</span>"
        end
      end
    end
    ########


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    ########
    # If Parent has no Infusionsoft Id, then search for matches in Infusionsoft and provide ids
    @contacts = nil
    if @user.role == "Parent" && @user.infusion_id == nil
      # get contacts with matching last name
      @contacts = Infusionsoft.data_query_order_by('Contact', 50, 0, {:LastName=> @user.last_name}, [:Id, :FirstName, :LastName, :ContactType, :Email], :FirstName, true)
      # data clean up - blank out missing names, create ContactId = Id
      @contacts.each do |i|
        i["FirstName"] == nil ? i["FirstName"]="" : nil
        i["ContactId"] = i["Id"]
      end
    end
    ########
  end

  # POST /users
  # POST /users.json
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

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def import
    User.import(params[:file])
    redirect_to users_path, notice: "Users imported."
  end
end
