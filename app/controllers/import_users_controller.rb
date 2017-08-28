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
        render :text => UserCSV.sample
      }
    end
  end

end
