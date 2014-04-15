module Shibbolite
  class ShibbolethController < ActionController::Base

    include Shibbolite::Helpers

    def access_denied
      @requested_url = session.delete(:requested_url)
    end

    def login
      session[:requested_url] ||= main_app.root_path
      load_session
      redirect_to logged_in? ? session.delete(:requested_url) : sp_login_url
    end

    def logout
      session.delete(Shibbolite.pid)
      redirect_to sp_logout_url
    end

    # required to prevent displaying default shibboleth logout message
    def logout_message ; end

    private

    # loads the session data created by shibboleth
    # ensures that the user's id is set in session
    # and updates the user's shibboleth attributes
    def load_session
      unless logged_in?
        session[Shibbolite.pid] = request.env[Shibbolite.pid.to_s]
        current_user.update(get_attributes) if registered_user?
      end
    end

    # reads shibboleth attributes from environment
    def get_attributes
      request.env.with_indifferent_access.slice(*Shibbolite.attributes)
    end

    def sp_login_url
      request.protocol + request.host +
          Shibbolite.handler_url + Shibbolite.session_initiator +
          '?' + URI.encode_www_form(target: login_url)
    end

    def sp_logout_url
      request.protocol + request.host +
          Shibbolite.handler_url + Shibbolite.logout_initiator +
          '?' + URI.encode_www_form(return: logout_message_url)
    end
  end
end
