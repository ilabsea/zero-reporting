module Backup
  class Data
    def self.perform
      backup_config_path = "#{Rails.root}/#{ENV['BACKUP_SCRIPT_PATH']}"
      system "backup perform -t #{ENV['BACKUP_MODEL_NAME']} -c #{backup_config_path}"
    end
  end
end
