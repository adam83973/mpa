class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_employee, except: [:new, :create]
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @messages = Message.all
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def new
    @message = Message.new
    respond_with(@message)
  end

  def edit
  end

  def create
    @message = Message.new(messages_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to root_url, notice: 'Message sent. We will respond via email if a response is required.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @message.update_attributes(messages_params)
    respond_with(@message)
  end

  def update_status
    message = Message.find(params[:id])
    status = params[:status].to_i

    if message.update_attributes( status: status, updated_by: current_user.id)
      redirect_to root_url, notice: "Message status marked as <strong>#{Message::STATUSES[status]}</strong>. Please note parent's account.".html_safe
    end
  end

  def destroy
    @message.destroy
    respond_with(@message)
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def messages_params
      params.require(:message).permit(:content, :important, :read, :recipient_id,
                                      :subject, :user_id, :general, :location_id,
                                      :status, :updated_by)
    end
end
