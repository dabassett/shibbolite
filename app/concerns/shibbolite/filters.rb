# controller filters for access control
module Shibbolite
  module Filters
    extend ActiveSupport::Concern

    include Shibbolite::Helpers

    def require_login
      redirect_to login_or_access_denied unless logged_in?
    end

    def require_registered
      redirect_to login_or_access_denied unless registered_user?
    end

    def require_group(*groups)
      in_group = false
      groups.flatten.each { |group| in_group ||= user_in_group?(group) }
      redirect_to login_or_access_denied unless in_group
    end

    def require_id(id)
      redirect_to login_or_access_denied unless user_has_id?(id)
    end

    def require_group_or_id(*groups, id)
      unless user_has_id?(id)
        require_group(groups)
      end
    end

    def use_attributes_if_available
      if request.env[Shibbolite.pid.to_s] and not logged_in?
        redirect_to login_or_access_denied
      end
    end

    # a handy redirect target
    def login_or_access_denied
      session[:requested_url] = request.fullpath
      logged_in? ? shibbolite.access_denied_url : shibbolite.login_url
    end
  end
end