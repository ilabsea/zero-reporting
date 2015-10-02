class ReportVariablesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:play_audio]
  skip_before_action :required_admin_role!, only: [:play_audio]

  def play_audio
    report_variable = ReportVariableAudio.find_by(token: params[:id])

    if !report_variable.has_audio
      Service::Verboice.connect(Setting).call_log_audio(report_variable)
      report_variable.has_audio = true
      report_variable.save
    end
    send_file report_variable.audio_data_path,
              filename: "#{report_variable.value}.wav",
              type: 'audio/x-wav',
              disposition: :attachment
  end
end