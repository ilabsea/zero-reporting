class ReportsController < ApplicationController
  def index
    @reports = Report.effective
                     .filter(params)
                     .includes(:phd, :od)
                     .order('id DESC')
                     .page(params[:page])
  end

  def play_audio
    report = Report.find params[:id]
    if !report.has_audio
      Service::Verboice.connect(Setting).call_log_audio(report)
      report.has_audio = true
      report.save
    end
    send_file report.audio_data_path,
              filename: "#{report.audio_key}.wav",
              type: 'audio/x-wav',
              disposition: :attachment
  end

  def toggle_status
    report = Report.find(params[:id])
    if report.toggle_status
      head :ok
    else
      render nothing: true, status: 400
    end
  end

  def destroy
    report = Report.find(params[:id])
    report.delete_status = true
    if report.save
      redirect_to reports_path, notice: 'Report has been deleted successfully'
    else
      redirect_to reports_path, alert: 'Failed to delete report'
    end
  end
end