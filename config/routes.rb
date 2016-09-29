Rails.application.routes.draw do
  namespace :api do
    mount API::Base, at: "/"
  end
end
