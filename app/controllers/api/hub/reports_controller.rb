module Api::Hub
  class ReportsController < Api::ApiController
    before_filter :authenticate_http_basic

    # GET api/hub/reports
    def index
      reports = [{id: 'FAAS3234', name: 'Weekly Disease Report'}]
      render json: reports, root: false
    end

    # api/hub/reports/:id
    def show
      render json: Variable.applied(Setting[:project])
    end
  end
end
