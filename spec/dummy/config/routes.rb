Rails.application.routes.draw do
  mount Shibbolite::Engine => '/shibbolite'
  root 'static#home'
  get 'static/home', as: 'public_page'
  get ':controller(/:action)'
end
