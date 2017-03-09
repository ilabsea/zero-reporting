# encoding: utf-8

##
# Backup Generated: zero_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t zero_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
db_config           = YAML.load_file('/var/www/cdc-zero-reporting-system/shared/config/database.yml')['production']
app_config          = YAML.load_file('/var/www/cdc-zero-reporting-system/shared/config/application.yml')['production']

Model.new(:zero_backup, 'Description for zero_backup') do

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = db_config['database']
    db.username           = db_config['username']
    db.password           = app_config['CDC_DATABASE_PASSWORD']
    db.host               = "localhost"
    db.port               = 3306
  end

  archive :zero_reporting do |archive|
    # Run the `tar` command using `sudo`
    # archive.use_sudo
    archive.add "/var/www/cdc-zero-reporting-system/shared/config"
    archive.add "/var/www/cdc-zero-reporting-system/shared/public"
  end


  ##
  # Amazon Simple Storage Service [Storage]
  #
  store_with S3 do |s3|
    # AWS Credentials
    s3.access_key_id     = "AKIAI62X5IYNHTBA3MOQ"
    s3.secret_access_key = "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"
    # Or, to use a IAM Profile:
    # s3.use_iam_profile = true

    s3.region            = "ap-southeast-1"
    s3.bucket            = "cdc-zero-reporting"
    #s3.path              = "path/to/backups"
    s3.keep              = 5
    # s3.keep              = Time.now - 2592000 # Remove all backups older than 1 month.
  end  
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #

  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = "resourcemap.wfp@gmail.com"
    mail.to                   = "thyda@instedd.org"
    mail.cc                   = "engthyda@gmail.com"
    mail.address              = "smtp.gmail.com"
    mail.port                 = 587
    mail.domain               = "localhost"
    mail.user_name            = "resourcemap.wfp@gmail.com"
    mail.password             = "wfp@emis"
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end
