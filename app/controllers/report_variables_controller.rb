class ReportVariablesController < ApplicationController
  def play_audio
    report_variable = ReportVariableAudio.find(params[:id])

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

  def toggle_status
    report_variable = ReportVariableAudio.find(params[:id])
    if report_variable.toggle_status
      head :ok
    else
      render nothing: true, status: 400
    end
  end
end