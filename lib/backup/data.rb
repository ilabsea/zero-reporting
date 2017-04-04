module Backup
  class Data
    attr_accessor :aws

    def initialize(s3_object_key)
      @aws ||= YAML::load(File.open("#{Rails.root}/config/aws.yml"))
      @s3 ||= Aws::S3::Resource.new(
        region: @aws['AWS_REGION'],
        access_key_id: @aws['AWS_ACCESS_KEY_ID'],
        secret_access_key: @aws['AWS_SECRET_ACCESS_KEY']
      )
      @s3_object_key = s3_object_key
      @local_path =  "tmp/zero_backup"
    end

    def self.perform
      backup_config_path = "#{Rails.root}/#{ENV['BACKUP_SCRIPT_PATH']}"
      system "backup perform -t #{ENV['BACKUP_MODEL_NAME']} -c #{backup_config_path}"
    end

    def restore
      download_s3_object
      restore_config
      restore_db
    end

    private
    def download_s3_object
      key = "backups/zero_backup/#{@s3_object_key}/zero_backup.tar"
      bucket = @s3.bucket(@aws['AWS_BUCKET_NAME'])
      @s3.bucket(@aws['AWS_BUCKET_NAME']).object(key).get(response_target: "#{@local_path}.tar")
      extract_object
    end

    def restore_config
      config_file_path = "#{@local_path}/archives"
      shared_path = "/var/www/cdc-zero-reporting-system/shared/"
      system "tar -xvf #{config_file_path}/zero_reporting.tar -C #{config_file_path} && cp -r #{config_file_path+shared_path} #{shared_path}"
    end

    def restore_db
      db_file = "#{@local_path}/databases/MySQL.sql"
      open(db_file, 'r') do |f|
        mysql_client.query f.read if Rails.env.production?
        puts "finish executing #{db_file}"
      end
    end

    def mysql_client
      db_config = Rails.configuration.database_configuration[Rails.env]
      Mysql2::Client.new(host: db_config['host'], username: db_config['username'], password: db_config['password'], flags: Mysql2::Client::MULTI_STATEMENTS)
    end

    def extract_object
      system "tar -xvf #{@local_path}.tar -C tmp/"
    end
  end
end
