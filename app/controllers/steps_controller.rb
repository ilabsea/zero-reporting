class StepsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def manifest
    render file: File.join(Rails.root, 'config', 'step_manifest.xml')
  end

  def validate_hc_worker
    result = User.hc_worker?(params[:CallSid]) ? 1 : 0
    render text: "#{{result: result }.to_json}"
  end

end
