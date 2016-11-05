Midoconline::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.force_ssl = true
  
end


#Error Notifier
Midoconline::Application.config.middleware.use ExceptionNotification::Rack,
 # :ignore_exceptions => ['ActionView::TemplateError'] + ExceptionNotifier.ignored_exceptions,
:email => {
  :email_prefix => "Midoconline production Error Notifier ",
  :sender_address => %{"Error notifier" <info@midoconline.com>},
  :exception_recipients => %w{shivkmr94@gmail.com}
} 

QB_APPLICATION_ID = 35038
QB_AUTH_KEY = 'yVQnaBUHBuHHr9B'
QB_AUTH_SECRET = '4TWZa9b4vRSeudf'
QB_SERVER = 'api.quickblox.com'
QB_USER_OWNER_ID = 44675

#STRIPE_PUBLISHABLE_KEY = 'pk_test_rtY8DogK3CGi5lBmPTZVA7AZ'
#STRIPE_SECRET_KEY = 'sk_test_0mwlAmQVrlBfQJ5sHlgmXQQy'

STRIPE_PUBLISHABLE_KEY = 'pk_live_cM3pk51kT0hLVYa0SIBGB8BB'
STRIPE_SECRET_KEY = 'sk_live_LQlW1Ljf8PpqTPGeLtPveDvs'


EMAILER_IMAGE_URL = "http://52.74.206.181:8010/emailer_images/"
ADMIN_EMAIL = 'anil03gupta03@gmail.com, emerick.solar@blueholding.mx'
EMAIL_BCC = 'shivkmr94@gmail.com'
EMAIL_SENDER = 'info@midoconline.com'

APP_URL = "http://localhost:3000/"
S3_url = "http://s3.amazonaws.com/midoconline-staging"
S3_access_key = "AKIAJHP4PQO4UPRAHAUQ"
S3_secret_access_key = "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"
S3_bucket = 'midoconline-staging'
APP_ID = "757136114359271"
APP_SECRET = "aa13a94a4c32ef2be1cd839cbb541250"


#Error Notifier
#Midoconline::Application.config.middleware.use ExceptionNotification::Rack,
# # :ignore_exceptions => ['ActionView::TemplateError'] + ExceptionNotifier.ignored_exceptions,
# :email => {
#   :email_prefix => "Staging Kwala Test Error Notifier",
#   :sender_address => %{"Error notifier" <error@ascratech.com>},
#   :exception_recipients => %w{shiv@ascratech.com}
# }



S3_CREDENTIALS = {:access_key_id => S3_access_key,
                  :secret_access_key => S3_secret_access_key,
                  :s3_host_name => "s3.eu-central-1.amazonaws.com" }
PAPERCLIP_SETTINGS =  { :storage => :s3,
                        :s3_credentials => S3_CREDENTIALS,
                        :bucket => S3_bucket
                        }

#FB_APP_ID = "966835633332699"
#FB_APP_SECRET = "3638a17c0a8b37040537886fd2554a01"

#TW_APP_ID = "AJOPJMNSNHcI57ElOw6jSQ7F0"
#TW_APP_SECRET = "4KedEsSm3jx18YNPQEeJOaq0G8118uXfn3QKuPpOntNjeoDbXm"



                     
USER_IMAGE_PATH = {:path => "user/:style/:id-:filename",
                     :url => "#{S3_url}/user/:style/:id-:filename"}.merge(PAPERCLIP_SETTINGS)
                           
                     
NEWS_IMAGE_PATH = {:path => "news_post/:style/:id-:filename",
                     :url => "#{S3_url}/news_post/:style/:id-:filename"}.merge(PAPERCLIP_SETTINGS)
