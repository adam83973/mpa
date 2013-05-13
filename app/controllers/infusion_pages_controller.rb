class InfusionPagesController < ApplicationController
  def home
  	if params[:search]
  		# get contacts with matching last name
      @contacts = Infusionsoft.data_query_order_by('Contact', 50, 0, {:LastName=> params[:search]+'%'}, [:Id, :FirstName, :LastName, :ContactType, :Email], :FirstName, true)
      # data clean up - blank out missing names, create ContactId = Id
      @contacts.each do |i|
        i["FirstName"] == nil ? i["FirstName"]="" : nil
        i["ContactId"] = i["Id"]
      end
      # alphabetize contacts by first name (errors out if first name is nil)
      # @contacts.sort_by! {|i| i["FirstName"]}
    end

  	if params[:FirstName] && params[:LastName]
  		data = { :FirstName => params[:FirstName], :LastName => params[:LastName] }
  		newcontact = Infusionsoft.contact_add(data)
      if newcontact.nil?
        flash[:error] = "Unable to create new contact."
      else
        flash[:notice] = "New contact created."
        redirect_to infusion_pages_edit_path(params.merge(ContactId: newcontact))
      end
    end
  end

  def edit # requires params[:ContactId]
    @user = Infusionsoft.contact_load(params[:ContactId], [:Id, :FirstName, :LastName, :ContactType, :Email, :Phone1Type, :Phone1, :Phone2Type, :Phone2, :StreetAddress1, :PostalCode, :City, :State])
    # check for credit cards associated to ContactId and render on edit page
    @credit_card = Infusionsoft.data_find_by_field('CreditCard', 10, 0, :ContactId, params[:ContactId], [:Id, :NameOnCard, :CardType, :Last4, :ExpirationMonth, :ExpirationYear, :Status])
    # remove all deleted cards from @credit_card array
    @credit_card.delete_if {|i| i["Status"] == 2}
  end	

  def update
  	# put all user params into an instance variable hash
  	@user_update = params
  	# get the infusionsoft user id from the hash
  	user_update_id = params[:Id]
  	# remove key,value pairs from hash
  	@user_update.except!(:utf8, :Id, :NameOnCard, :CardType, :CardNumber, :ExpirationMonth, :ExpirationYear, :controller, :action)
  	result = Infusionsoft.contact_update(user_update_id, @user_update)
  	if result
  		flash[:notice] = "Contact Updated"
  	else
  		flash[:error] = "Contact Update Failed"
  	end
    redirect_to :back
  end

  def credit_card
  	@credit_card = params
  	# add ContactId to hash (renaming Id)
  	@credit_card.merge!(ContactId: @credit_card[:Id])
  	# remove kay,value pairs from hash
  	@credit_card.except!(:utf8, :Id, :controller, :action)

  	result = Infusionsoft.data_add('CreditCard', @credit_card)
  	if result
  		flash[:notice] = "CC Added"
  	else
  		flash[:error] = "CC Add Failed"
  	end
    redirect_to :back
  end

  def subscription
    # get active subscriptions from Infusiosoft
    subscriptions = Infusionsoft.data_query('CProgram', 50, 0, {:Status => "1"}, [:Id, :ProgramName, :DefaultPrice, :DefaultCycle, :DefaultFrequency] )
    # alphabetize subscriptions
    subscriptions.sort_by! {|hsh| hsh["ProgramName"]}
    # create array of subscriptions names and values for dropdown
    @dropdown = [["Subscription...", 0]]
    subscriptions.each do |i|
      @dropdown << [ i["ProgramName"], i["Id"].to_i]
    end
    # pre-populate subscription details form
    # if subscription chosen, use subscription values, else use blank values
    params[:cProgramId] == nil ? @subscription = 0 : @subscription = params[:cProgramId]
    params[:price] == nil ? @price = 0 : @price = params[:price].to_i
    # get subscriber info from Infusionsoft
    @subscriber = Infusionsoft.data_load('Contact', params[:ContactId], [:FirstName, :LastName])
    # check for credit cards associated to Id and render on edit page
    @credit_card = Infusionsoft.data_find_by_field('CreditCard', 10, 0, :ContactId, params[:ContactId], [:Id, :NameOnCard, :CardType, :Last4, :ExpirationMonth, :ExpirationYear, :Status])
    # remove all deleted cards from @credit_card array
    @credit_card.delete_if {|i| i["Status"] != 3}
    @credit_card_options = []
    @credit_card.each do |i|
      @credit_card_options << [i["CardType"] + " xxxx" + i["Last4"], i["Id"]]
    end
    # retrieve subscriptions for contact
    @active_subscription = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => params[:ContactId]}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
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
    @invoices = Infusionsoft.data_query_order_by('Invoice', 10, 0, {:ContactId => params[:ContactId]}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
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

  def update_subscription
    # get subscription details to populate into form
    @subscription_details = Infusionsoft.data_load('CProgram', params[:cProgramId], [:DefaultPrice, :DefaultFrequency, :DefaultCycle])
    @price = @subscription_details["DefaultPrice"]
    redirect_to infusion_pages_subscription_path(params.merge(price: @price))
  end

  def add_subscription
    # calculate days from now until bill date
    startBilling = params[:startBillDate]
    startDate = DateTime.parse(startBilling[:day]+"-"+startBilling[:month]+"-"+startBilling[:year])
    daysUntilCharge = (startDate - DateTime.now).to_i + 1
    result = nil
    # add subcription with default price and qty = 1
    result = Infusionsoft.invoice_add_recurring_order(params[:ContactId], true, params[:cProgramId], params[:merchantAccountId].to_i, params[:creditCardId].to_i, 0, daysUntilCharge)
    # DID NOT WORL: result = Infusionsoft.invoice_add_recurring_order_with_price(params[:ContactId], false, params[:cProgramId].to_s, params[:qty].to_i, params[:price].to_i , false, params[:merchantAccountId].to_i, params[:creditCardId].to_i, 0, daysUntilCharge)
    # DID NOT WORK: result = Infusionsoft.invoice_add_recurring_order_with_price('5843', false, 7, 1, 1 , false, 5, 1669, 0, 24)
    data = { :Qty => params[:qty], :BillingAmt => params[:price] }
    Infusionsoft.data_update('RecurringOrder', result, data)
    if result
      flash[:notice] = "Subscription Added"
      # update recurring order with qty and price from form input
    else
      flash[:error] = "Subscription Failed"
    end

    # Handle initial Deposit
    if params[:deposit].to_f > 0.0
      # create blank invoice
      invoice = Infusionsoft.invoice_create_blank_order(params[:ContactId], "Deposit", DateTime.now, 0, 0)
      # add deposit to order
      product_id = 275
      type = 3 # Service 
      Infusionsoft.invoice_add_order_item(invoice, product_id, type, params[:deposit].to_f, 1, "Deposit", "Deposit")
      cc_result = Infusionsoft.invoice_charge_invoice(invoice, "API Payment", params[:creditCardId].to_i, params[:merchantAccountId].to_i, false)
      flash[:warning] = "Deposit result: #{cc_result}"
    end
    redirect_to :back
  end

  def delete_user
    #
    # ADD A CONFIRM POP-UP!
    #

    result = Infusionsoft.data_delete('Contact', params[:Id])
    if result
      flash[:notice] = "User deleted"
    else
      flash[:error] = "User delete failed"
    end
    redirect_to :back
  end

  def end_subscription
    #
    # ADD A CONFIRM POP-UP!
    #

    today = DateTime.now
    result = Infusionsoft.data_update('RecurringOrder', params[:Id], {:EndDate => today})
    if result
      flash[:notice] = "Subscription ended"
    else
      flash[:error] = "Subscription end failed"
    end
    redirect_to :back
  end

  def camps
  end
end