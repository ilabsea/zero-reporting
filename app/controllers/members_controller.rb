class MembersController < ApplicationController
  def index
    @members = Member.page(params[:page]).per(20)
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(filter_params)
    if(@member.save)
      redirect_to  members_path, notice: 'Member has been created successfully'
    else
      flash.now[:alert] = 'Failed to save Member'
      render :new
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(filter_params)
      redirect_to members_path, notice: 'Member has been updated successfully'
    else
      flash.now[:alert] = 'Failed to update member'
      render :edit
    end
  end

  def destroy
    @member = Member.find(params[:id])
    if @member.destroy
      redirect_to members_path, notice: 'Member has been deleted'
    else
      redirect_to members_path, alert: 'Failed to remove member'
    end
  end


  private

  def filter_params
    params.require(:member).permit(:name, :phone, :od_id, :phd_id)
  end
end