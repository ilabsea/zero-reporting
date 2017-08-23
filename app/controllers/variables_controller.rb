class VariablesController < ApplicationController
  authorize_resource
  def create
    variable = Variable.new(filter_params)
    variable.verboice_project_id = Settings[:project]
    if variable.save
      flash[:notice] = 'Variable has been created'
      head :ok
    else
      render json: variable.errors.full_messages, status: :bad_request
    end
  end

  def update
    variable = Variable.find(params[:id])
    if variable.update_attributes(filter_params)
      flash[:notice] = 'Variable has been updated successfully'
      head :ok
    else
      render json: variable.errors.full_messages, status: :bad_request
    end
  end

  def destroy
    variable = Variable.find(params[:id])
    if variable.destroy
      redirect_to settings_path, notice: 'Variable has been deleted successfully'
    else
      redirect_to settings_path, alert: 'Failed to delete variable'
    end
  end


  def filter_params
    params.permit(:name, :verboice_name, :verboice_id, :background_color, :text_color,
                  :alert_method, :dhis2_data_element_uuid, :disabled, :threshold_value)
  end

end
