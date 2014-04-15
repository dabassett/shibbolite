class StaticController < ApplicationController

  include Shibbolite::Filters

  before_action :use_attributes_if_available, only: :home
  before_action(only: :user_resource)  { |c| c.require_group(:admin, :user) }
  before_action(only: :admin_resource) { |c| c.require_group(:admin) }

  def home
  end

  def user_resource
    @user_data = 'Available to all users'
    @admin_data = 'Available to admins' if user_in_group?(:admin)
  end

  def admin_resource
    @admin_data = 'Available to admins'
  end

end