module Parser
  class ReportParser
    def self.parse options
      attrs = {
        user: User.find_by(phone_without_prefix: Tel.new(options[:address]).without_prefix),
        verboice_project_id: options[:project][:id],
        phone: options[:address],
        duration: options[:duration],
        called_at: options[:called_at],
        started_at: options[:started_at],
        call_log_id: options[:id],
        call_flow_id: options[:call_flow_id],
        recorded_audios: options[:call_log_recorded_audios],
        call_log_answers: options[:call_log_answers],
        reviewed: false
      }

      variables = Variable.where(verboice_project_id: options[:project][:id])

      report = Report.where(call_log_id: attrs[:call_log_id]).first_or_initialize
      report.attributes = attrs

      options[:call_log_recorded_audios].each do |recorded_audio|
        attrs[:audio_key] = recorded_audio[:key] if recorded_audio[:project_variable_id] == Setting[:project_variable].to_i

        variable = variables.select { |variable| variable.verboice_id == recorded_audio[:project_variable_id] }.first
        report.report_variable_audios.build(value: recorded_audio[:key], variable_id: variable.id) if variable && recorded_audio[:key].present?
      end

      options[:call_log_answers].each do |call_log_answer|
        variable = variables.select { |variable| variable.verboice_id == call_log_answer[:project_variable_id] }.first
        report.report_variable_values.build(value: call_log_answer[:value], variable_id: variable.id) if variable && call_log_answer[:value].present?
      end

      report
    end
  end
end
