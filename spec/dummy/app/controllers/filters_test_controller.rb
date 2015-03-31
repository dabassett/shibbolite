# a dummy controller for testing the Shibbolite::Filters concern

class FiltersTestController < ApplicationController

  include Shibbolite::Filters

  before_action :require_login,               only: :_require_login
  before_action :require_registered,          only: :_require_registered
  before_action(only: :_require_group)        { |c| c.require_group params[:groups] }
  before_action(only: :_require_id)           { |c| c.require_id params[:id].to_i }
  before_action(only: :_require_group_or_id)  { |c| c.require_group_or_id params[:groups], params[:id].to_i }
  before_action :use_attributes_if_available, only: :_use_attributes_if_available
  before_action(only: :_require_attribute)          { |c| c.require_attribute params[:attr], params[:value] }
  before_action(only: :_require_group_or_attribute) { |c| c.require_group_or_attribute params[:groups], params[:attr], params[:value] }

  def _require_login
    render :dummy
  end

  def _require_registered
    render :dummy
  end

  def _require_group
    render :dummy
  end

  def _require_id
    render :dummy
  end

  def _require_group_or_id
    render :dummy
  end

  def _use_attributes_if_available
    render :dummy
  end

  def _require_attribute
    render :dummy
  end

  def _require_group_or_attribute
    render :dummy
  end
end
