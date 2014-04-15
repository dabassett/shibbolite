# a dummy controller for testing the Shibbolite::Helpers concern
# because real isolation testing was too much of a pain in the neck

class HelpersTestController < ApplicationController

  include Shibbolite::Helpers

  # helpers

  def _current_user
    current_user
    render :dummy
  end

  def _logged_in?
    @logged_in = logged_in?
    render :dummy
  end

  def _anonymous_user?
    @anonymous = anonymous_user?
    render :dummy
  end

  def _guest_user?
    @guest = guest_user?
    render :dummy
  end

  def _registered_user?
    @registered = registered_user?
    render :dummy
  end

  def _user_in_group?
    @result = user_in_group?(params[:group].to_sym)
    render :dummy
  end

  def _user_has_id?
    @result = user_has_id?(params[:id].to_i)
    render :dummy
  end
end