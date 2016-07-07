class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      @student = @transaction.student if @transaction.student_id
      @product = @transaction.product
      if @transaction.process == 0
        #check to see if student has enough credits
        if @student.credits >= @transaction.credits_redeemed
          # redeem credits from student's account
          @student.redeem_credit(@transaction.credits_redeemed)
          redirect_to @student, notice: 'Credits were successfully redeemed.'
        else
          #destroy transaction
          @transaction.destroy
          redirect_to @student, flash: { error: 'Student does not have enough credits.' }
        end
      elsif @transaction.process == 2 || @transaction.process == 3
        redirect_to new_transaction_path, notice: "#{@transaction.quantity} units of #{@transaction.product.name} #{@transaction.process == 2 ? "added to" : "removed from"} #{@transaction.location.name}'s inventory."
      else
        redirect_to root_url, notice: "Transaction was successfully completed."
      end
    else
      render :new
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: 'Transaction was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:process, :user_id, :student_id, :credits_redeemed, :product_id, :location_id, :quantity)
    end
end
