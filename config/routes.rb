Shibbolite::Engine.routes.draw do
  get 'login',          to: 'shibboleth#login'
  get 'logout',         to: 'shibboleth#logout'
  get 'logout_message', to: 'shibboleth#logout_message'
  get 'access_denied',  to: 'shibboleth#access_denied'
end
