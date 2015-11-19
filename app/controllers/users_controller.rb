class UsersController < ApplicationController

  authorize_resource :except => [:change_profile]

  def index
    @place_id = params[:place_id]
    @users = User.by_place(@place_id).page(params[:page])
    render :by_place, layout: false if request.xhr?

  end

  def search
    @users = User.search(params[:phone]).page(params[:page])
    @place_id = @users.first.place_id if @users.length == 1
    render :index
  end

  def by_place
    @users = User.by_place(params[:place_id]).page(params[:page])
    render layout: false
  end

  def new
    @place = Place.find(params[:place_id])
    @user = User.new(place: @place)
  end

  def create
    @user = User.new(filter_params)
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if(@user.save)
      redirect_to  users_with_ref_path(@user.place_id), notice: 'User has been created successfully'
    else
      flash.now[:alert] = 'Failed to save user'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(filter_params)
      redirect_to users_with_ref_path(@user.place_id), notice: 'User has been updated successfully'
    else
      flash.now[:alert] = 'Failed to update user'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    place_id = @user.place_id

    if @user.destroy
      redirect_to users_with_ref_path(place_id), notice: 'User has been deleted'
    else
      redirect_to users_with_ref_path(place_id), alert: 'Failed to remove users'
    end
  end

  def reset
    @user = User.find(params[:id])
    @random_password =  RandomWord.child_word_from_file("#{Rails.root}/public/ref/words.txt")
    @user.password = @random_password

    if !@user.save
      redirect_to edit_user_path(@user), alert: "Failed to reset password for this user. Please try again"
    end
  end

  def change_profile
    @old_password = params[:user][:old_password]
    @password = params[:user][:password]
    @password_confirmation = params[:user][:password_confirmation]

    if current_user.change_password(@old_password, @password, @password_confirmation)
      flash.now.notice = 'Your password has been changed successfully'

      @old_password = ''
      @password = ''
      @password_confirmation = ''
    else
      flash.now.alert =  current_user.errors.full_messages.first
    end
    render :profile
  end

  def profile
  end

  def import
  end

  def download_template
    respond_to do |format|
      format.json  { render :json => result }
      format.csv {
        content = "login,full_name,email,phone_number,password,password_confirmation,location_code \n" + 
        "example,example user,example@sampledomain.org.kh,8551234432233,samplepassword,samplepassword,100 \n" +
        "example1,example user1,example1@sampledomain.org.kh,855123443332,samplepassword,samplepassword,100"
        render :text => content
      }
    end
  end

  def upload_users
    csv_string = File.read(params[:users].path, :encoding => 'utf-8')
    users = User.decode_and_validate_user_csv(csv_string)
    render :json => users, :root => false
  end

  def confirmed_upload_users
    csv_string = File.read(params[:users].path, :encoding => 'utf-8')
    users = User.decode_and_save_user_csv(csv_string)
    render :json => users, :root => false
  end

  private

  def users_with_ref_path(place_id)
    users_path(place_id: place_id)
  end

  def filter_params
    params.require(:user).permit(:username, :name, :email, :phone, :place_id  )
  end
end