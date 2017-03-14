db_config           = YAML.load_file('/var/www/cdc-zero-reporting-system/shared/config/database.yml')['production']
app_config          = YAML.load_file('/var/www/cdc-zero-reporting-system/shared/config/application.yml')['production']
aws_config          = YAML.load_file('/var/www/cdc-zero-reporting-system/shared/config/aws.yml')
smtp_config          = YAML.load_file('/var/www/cdc-zero-reporting-system/shared/config/smtp.yml')

Model.new(:zero_backup, "Description for zero_backup") do

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
    archive.add app_config['CONFIG_PATH_TO_BACKUP']
    archive.add app_config['ASSET_PATH_TO_BACKUP']
  end


  ##
  # Amazon Simple Storage Service [Storage]
  #
  store_with S3 do |s3|
    # AWS Credentials
    s3.access_key_id     = aws_config['AWS_ACCESS_KEY_ID']
    s3.secret_access_key = aws_config['AWS_SECRET_ACCESS_KEY']
    # Or, to use a IAM Profile:
    # s3.use_iam_profile = true

    s3.region            = aws_config['AWS_REGION']
    s3.bucket            = aws_config['AWS_BUCKET_NAME']
    s3.keep              = 5
  end
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #

  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = smtp_config['SMTP_USER_NAME']
    mail.to                   = app_config['BACKUP_NOTIFY_EMAIL']
    mail.address              = smtp_config['SMTP_ADDRESS']
    mail.port                 = 587
    mail.domain               = "localhost"
    mail.user_name            = smtp_config['SMTP_USER_NAME']
    mail.password             = smtp_config['SMTP_PASSWORD']
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end
