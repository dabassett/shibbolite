module Shibbolite
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc 'Creates the shibbolite_config.rb initializer and mounts the Shibbolite engine'

      def create_initializer
        copy_file 'shibbolite_config.rb', 'config/initializers/shibbolite_config.rb'
      end

      def mount_engine
        route "mount Shibbolite::Engine => '/shibbolite'"
      end
    end
  end
end
