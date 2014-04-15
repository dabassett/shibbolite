require "shibbolite/engine"

module Shibbolite

  # shibboleth attributes available in the environment
  mattr_accessor :attributes

  # shibboleth primary key
  mattr_accessor :primary_user_id

  mattr_accessor :primary_user_id_display
  @@primary_user_id_display = 'Username'

  # groups available to assign to users
  mattr_accessor :groups
  @@groups = [:user, :admin]

  # the parent application's User model
  mattr_accessor :user_class
  @@user_class = 'User'

  def self.user_class
    @@user_class.constantize
  end

  mattr_accessor :user_table_name
  @@user_table_name = @@user_class.pluralize

  mattr_accessor :skip_validations
  @@skip_validations = false

  # NativeSP base location
  mattr_accessor :handler_url
  @@handler_url = '/Shibboleth.sso'

  # NativeSP handler location for starting sessions
  mattr_accessor :session_initiator
  @@session_initiator = '/Login'

  # NativeSP handler location for logging out
  mattr_accessor :logout_initiator
  @@logout_initiator = '/Logout'

  # shortened/alternate accessors

  def self.pid
    primary_user_id
  end

  def self.pid_display
    primary_user_id_display
  end

  # friendly config
  def self.config
    yield self
  end
end
