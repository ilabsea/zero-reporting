class SmsRecipientsController < ApplicationController

  def index
    @recipients = SmsRecipient.where(verboice_project_id: Setting[:project]).page(params[:page])
  end

  def new
    @recipient = SmsRecipient.new
  end

  def create
    @recipient = SmsRecipient.new(filter_params)
    @recipient.verboice_project_id = Setting[:project]
    if @recipient.save
      redirect_to  sms_recipients_path, notice: 'Recipient has been created successfully'
    else
      flash.now[:alert] = 'Failed to save recipient'
      render :new
    end
  end

  def edit
    @recipient = SmsRecipient.find(params[:id])
  end

  def update
    @recipient = SmsRecipient.find(params[:id])
    if @recipient.update_attributes(filter_params)
      redirect_to sms_recipients_path, notice: 'Recipient has been updated successfully'
    else
      flash.now[:alert] = 'Failed to update user'
      render :edit
    end
  end

  def destroy
    @recipient = SmsRecipient.find(params[:id])
    if @recipient.destroy
      redirect_to sms_recipients_path, notice: 'Recipient has been deleted'
    else
      redirect_to sms_recipients_path, alert: 'Failed to remove recipient'
    end
  end

  private
  def filter_params
    params.require(:sms_recipient).permit(:name, :phone)
  end


end
