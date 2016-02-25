Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "enteryourkeyhere"
Braintree::Configuration.public_key = "enteryourkeyhere"
Braintree::Configuration.private_key = "enteryourkeyhere"

class MyApp < Sinatra::Base
  get '/' do
    erb :index
  end
  get '/client_token' do
    if request.xhr?
      content_type :json
      client_token = Braintree::ClientToken.generate
      { :client_token => client_token }.to_json
    end
  end
  post "/checkout" do
    nonce = params[:payment_method_nonce]

    result = Braintree::Transaction.sale(
      :amount => "10.00",
      :payment_method_nonce => nonce
    )
    if result.success?
      "<h1>Success! Transaction ID: #{result.transaction.id}</h1>"
    else
      "<h1>Error: #{result.message}</h1>"
    end
  end
end