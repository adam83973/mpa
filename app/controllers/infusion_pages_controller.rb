class InfusionPagesController < ApplicationController
  before_action :authenticate_user!, except: [:tag_contact]
  before_action :authorize_admin, except: [:tag_contact]

  rescue_from Rack::Timeout::RequestTimeoutException, :with => :rescue_from_timeout
  rescue_from Infusionsoft::UnexpectedError, :with => :rescue_from_unexpected

  def home
  	if params[:search]
  		# get contacts with matching last name
      @contacts = Infusionsoft.data_query_order_by('Contact', 50, 0, {:LastName=> params[:search]+'%'}, [:Id, :FirstName, :LastName, :ContactType, :Email], :FirstName, true)
      # data clean up - blank out missing names, create ContactId = Id
      @contacts.each do |i|
        i["FirstName"] == nil ? i["FirstName"]="" : nil
        i["ContactId"] = i["Id"]
      end
    end

  	if params[:FirstName] && params[:LastName]
  		data = { :FirstName => params[:FirstName], :LastName => params[:LastName] }
  		newcontact = Infusionsoft.contact_add(data)
      if newcontact.nil?
        flash[:error] = "Unable to create new contact."
      else
        flash[:notice] = "New contact created."
        redirect_to infusion_pages_edit_path(ContactId: newcontact)
      end
    end
  end

  def add_contact
    data = { :FirstName => params[:FirstName], :LastName => params[:LastName], :Email => params[:Email] }
    @newcontact = Infusionsoft.contact_add(data)

    Infusionsoft.contact_add_to_group(@newcontact, 91)
    Infusionsoft.email_optin(params[:Email], "Program enrollment.")

    respond_to do |format|
      if params[:Show]
        @user = User.find(params[:UserId].to_i)
        @user.update_attribute :infusion_id, @newcontact
        format.js
        format.json { render json: @newcontact }
      else
        format.js
        format.json { render json: @newcontact }
      end
    end
  end

  def possible_contacts
    if params[:search]
      @user = User.find(params[:UserId].to_i) if params[:UserId]
      # get contacts with matching last name
      @contacts = Infusionsoft.data_query_order_by('Contact', 50, 0, {:LastName=> params[:search]+'%'}, [:Id, :FirstName, :LastName, :ContactType, :Email], :FirstName, true)
      # data clean up - blank out missing names, create ContactId = Id
      @contacts.each do |i|
        i["FirstName"] == nil ? i["FirstName"]="" : nil
        i["ContactId"] = i["Id"]
      end
    end
    respond_to do |format|
      if @contacts
        format.js
      end
    end
  end

  def add_existing_id
    @user = User.find(params[:UserId])
    respond_to do |format|
      if  @user.update_attribute :infusion_id, params[:Id]
        format.json { render json: @user }
      end
    end
  end

  def edit # requires params[:ContactId]
    count = 0
    begin
      @user = Infusionsoft.contact_load(params[:ContactId], [:Id, :FirstName, :LastName, :ContactType, :Email, :Phone1Type, :Phone1, :Phone2Type, :Phone2, :StreetAddress1, :PostalCode, :City, :State])
      # check for credit cards associated to ContactId and render on edit page
      @credit_card = Infusionsoft.data_find_by_field('CreditCard', 10, 0, :ContactId, params[:ContactId], [:Id, :NameOnCard, :CardType, :Last4, :ExpirationMonth, :ExpirationYear, :Status])
      # remove all deleted cards from @credit_card array
      @credit_card.delete_if {|i| i["Status"] == 2}
      # check to see if parent exists in app user table. returns empty array if no match found
      @app_user = User.where("infusion_id = ?", params[:ContactId]).first

      if !@app_user
         @candidates = User.where("first_name =? AND last_name = ?", @user["FirstName"], @user["LastName"])
      end
    rescue
      if count < 3
        retry
      end
    end
  end

  def update
  	# put all user params into an instance variable hash
  	@user_update = params
  	# get the infusionsoft user id from the hash
  	user_update_id = params[:Id]
  	# remove key,value pairs from hash
    count = 0

    @user_update.except!(:utf8, :Id, :NameOnCard, :CardType, :CardNumber, :ExpirationMonth, :ExpirationYear, :controller, :action, :NewCustomer)

    begin
  	   @user_update.except!(:utf8, :Id, :NameOnCard, :CardType, :CardNumber, :ExpirationMonth, :ExpirationYear, :controller, :action, :NewCustomer)
  	  result = Infusionsoft.contact_update(user_update_id, @user_update.to_unsafe_h)
    rescue
      if count < 3
        count = count + 1
        retry
      end
    end

    if result
      flash[:notice] = "Contact Updated"
    else
      flash[:alert] = "Contact Update Failed"
    end

    redirect_to :back
  end

  def credit_card
  	@credit_card = params
  	# add ContactId to hash (renaming Id)
  	@credit_card.merge!(ContactId: @credit_card[:Id])
  	# remove kay,value pairs from hash
  	@credit_card.extract!(:utf8, :Id, :controller, :action)
<<<<<<< HEAD
    # convert params to hash
    hash = {}
    @credit_card = @credit_card.each{|k,v| hash[k] = v}
=======
>>>>>>> staging

  	result = Infusionsoft.data_add('CreditCard', @credit_card.to_unsafe_h)

  	result ? flash[:notice] = "CC Added" : flash[:error] = "CC Add Failed"

    redirect_to :back
  end

  def subscription
    @user = User.find(params[:userId])

    if @user.infusion_id
      count = 0
      begin
        # create array of subscriptions names and values for dropdown
        @dropdown = [["One Student Classes", 5]]

        # get subscriber info from Infusionsoft
        @subscriber = Infusionsoft.data_load('Contact', @user.infusion_id, [:FirstName, :LastName])
        # check for credit cards associated to Id and render on edit page
        @credit_card = Infusionsoft.data_find_by_field('CreditCard', 10, 0, :ContactId, @user.infusion_id, [:Id, :NameOnCard, :CardType, :Last4, :ExpirationMonth, :ExpirationYear, :Status])
        # remove all deleted cards from @credit_card array
        @credit_card.delete_if {|i| i["Status"] != 3}
        @credit_card_options = []
        @credit_card.each do |i|
          @credit_card_options << [i["CardType"] + " xxxx" + i["Last4"], i["Id"]]
        end
        # retrieve subscriptions for contact
        @active_subscription = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => @user.infusion_id, :Status => "Active"}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
        @active_subscription.sort_by! {|hsh| hsh["Status"]}
      rescue
        count < 3 ? retry : ""

        @active_subscriptions.each do |active_subscription|
          active_subscription["ProgramName"] = "One Student Classes"
        end
      end
      # get invoices and display recent ones
      @invoices = Infusionsoft.data_query_order_by('Invoice', 10, 0, {:ContactId => @user.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
      @invoices.each do |i|
        if i["PayStatus"] == 0
          i["Status"] = "<span class='badge badge-important'>Unpaid</span>"
        elsif i["RefundStatus"] == 1
          i["Status"] = "<span class='badge badge-warning'>Partial Refund</span>"
        elsif i["RefundStatus"] == 2
          i["Status"] = "<span class='badge badge-warning'>Full Refund</span>"
        else
          i["Status"] = "<span class='badge badge-success'>Paid</span>"
        end
      end
    else
    end
  end

  def update_subscription
    # get subscription details to populate into form
    @subscription_details = Infusionsoft.data_load('CProgram', params[:cProgramId], [:DefaultPrice, :DefaultFrequency, :DefaultCycle])
    @price = @subscription_details["DefaultPrice"]
    redirect_to infusion_pages_subscription_path(params.merge(price: @price))
  end

  def add_subscription
    @user = User.find_by_infusion_id(params[:ContactId])
    # calculate days from now until bill date
    startBilling = params[:startBillDate]
    startDate = DateTime.parse(startBilling)
    daysUntilCharge = (startDate - DateTime.now).to_i + 1
    result = nil
    # add subcription with default price and qty = 1
    if Rails.env.production?
      result = Infusionsoft.invoice_add_recurring_order(params[:ContactId], true, params[:cProgramId], params[:merchantAccountId].to_i, params[:creditCardId].to_i, 0, daysUntilCharge)
    else
      result = Infusionsoft.invoice_add_recurring_order(params[:ContactId].to_i, true, params[:cProgramId].to_i, 1, params[:creditCardId].to_i, 1, daysUntilCharge)
    end

    data = { :Qty => params[:qty], :BillingAmt => params[:price] }
    Infusionsoft.data_update('RecurringOrder', result, data)

    if result
      flash[:notice] = "Subscription Added"
      # update recurring order with qty and price from form input
    else
      flash[:error] = "Subscription Failed"
    end

    # Handle initial deposit
    if params[:deposit].to_f > 0.0
      # create blank invoice
      invoice = Infusionsoft.invoice_create_blank_order(params[:ContactId], "Deposit", DateTime.now, 0, 0)
      # add deposit to order
      product_id = 966
      type = 3 # Service
      Infusionsoft.invoice_add_order_item(invoice, product_id, type, params[:deposit].to_f, 1, "Deposit", "Deposit")
      Infusionsoft.invoice_add_payment_plan(invoice, true, params[:creditCardId].to_i, params[:merchantAccountId].to_i, 1, 1, 0.0, startDate, startDate, 1, 30)
      # charge now
      #cc_result = Infusionsoft.invoice_charge_invoice(invoice, "API Payment", params[:creditCardId].to_i, params[:merchantAccountId].to_i, false)
      #flash[:warning] = "Deposit result: #{cc_result}"
    end

    redirect_to infusion_pages_subscription_path(userId: @user.id)
    # redirect_to :back
  end

  def delete_user
    result = Infusionsoft.data_delete('Contact', params[:Id])
    if result
      flash[:notice] = "User deleted"
    else
      flash[:error] = "User delete failed"
    end
    redirect_to :back
  end

  def end_subscription
    today = DateTime.now
    result = Infusionsoft.data_update('RecurringOrder', params[:Id], {:EndDate => today, :Status => "Inactive", :AutoCharge => "N", :BillingCycle => 2})
    if result
      flash[:notice] = "Subscription ended"
    else
      flash[:error] = "Subscription end failed"
    end
    redirect_to :back
  end

  def audit
    @parents = User.where("role = ?", "Parent").where("active = ? OR balance_due > ?", true, 0).order("balance_due DESC")
  end

  def subscription_audit
    @parents = User.where(role: 'Parent')
  end

  def registration_audit
    @parents = User.where(role: 'Parent')
  end

  def tag_contact
    @contact_id = params[:contact_id]
    @tag_ids = params[:tag_ids]
    @tag_ids.each{ |tag_id| Infusionsoft.contact_add_to_group(@contact_id, tag_id)}

    respond_to do |format|
      format.html
    end
  end

  def add_to_terimination_sequence
    contactId = params[:contactId]
    group_id = Rails.env.production? ? 1744 : 111
    if Infusionsoft.contact_add_to_group(contactId, group_id)
      render nothing: true, status: 200
    else
      render text: "Sequence was not started.", status: :bad_request
    end
  end

  private
    def rescue_from_timeout
      redirect_to :back, alert: 'Your request was not processed. Please try again.'
    end

    def rescue_from_unexpected
      redirect_to infusion_pages_subscription_path(userId: @user.id)
    end
end
