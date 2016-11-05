
Rails.configuration.stripe = {
  :publishable_key => STRIPE_PUBLISHABLE_KEY,
  :secret_key      => STRIPE_SECRET_KEY
}
#Rails.configuration.stripe = {
#  :publishable_key => 'pk_test_rtY8DogK3CGi5lBmPTZVA7AZ',
#  :secret_key      => 'sk_test_0mwlAmQVrlBfQJ5sHlgmXQQy'
#}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
