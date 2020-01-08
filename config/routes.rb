Rails.application.routes.draw do

  get '/' => "home#top"
  get '/home/judge' => "home#judge"

  mount API::Base => '/'

end
