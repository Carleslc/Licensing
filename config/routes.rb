Rails.application.routes.draw do

  get '/products/:name/licenses/:key', to: 'license#validate'
  get '/products/:name/licenses/:key/uses', to: 'license#uses'
  get '/products/:name/trial', to: 'license#trial'

end
