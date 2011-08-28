require 'aws/s3'

unless Rails.env.test?
  AWS::S3::Base.establish_connection!(
    :access_key_id => Settings.aws['key'],
    :secret_access_key => Settings.aws['secret']
  )
end