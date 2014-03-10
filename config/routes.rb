Spree::Core::Engine.routes.draw do
  # Add your extension routes here
   get '/bitcredits/getBalance', :to => "bit_credits#get_balance"
end
