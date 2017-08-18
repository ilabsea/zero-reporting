class ImportUsersController < ApplicationController

  def new

  end

  def create
    csv_string = File.read(params[:user].path, :encoding => 'utf-8')
    users = UserCSV.new(csv_string).import
    render :json => users, :root => false
  end

  def decode
    csv_string = File.read(params[:user].path, :encoding => 'utf-8')
    users = UserCSV.new(csv_string).decode
    render :json => users, :root => false
  end

  def template
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

end
