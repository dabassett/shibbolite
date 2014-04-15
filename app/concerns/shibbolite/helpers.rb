module Shibbolite
  module Helpers
    extend ActiveSupport::Concern

    included do
      helper_method :logged_in?, :current_user, :anonymous_user?, :guest_user?,
                    :registered_user?, :user_in_group?, :user_has_id?
    end

    # true when the primary_user_id has been saved in session
    def logged_in?
      session[Shibbolite.pid]
    end

    # sets current user from the session user id
    def current_user
      logged_in? ? @current_user ||= Shibbolite.user_class.find_user(session[Shibbolite.pid]) : nil
    end

    # true when user hasn't signed in to SSO
    def anonymous_user?
      not logged_in?
    end

    # true when the user signed in to the SSO
    # but they haven't been registered with the app
    def guest_user?
      current_user.nil? and logged_in?
    end

    # true when the user exists in the database
    def registered_user?
      current_user
    end

    def user_in_group?(group, user = nil)
      user ||= current_user
      return false unless user
      user.group == group.to_s
    end

    def user_has_id?(id, user = nil)
      user ||= current_user
      return false unless user
      user.id == id
    end
  end
end