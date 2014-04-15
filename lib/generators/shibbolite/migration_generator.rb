module Shibbolite
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates the migration to add shibboleth attributes to the main app's User class"

      def creat_migration
        generate "migration AddShibbolethAttributesTo#{Shibbolite.user_table_name} group:string" <<
                     Shibbolite.attributes.collect { |attr| " #{attr}:string" }.join
      end
    end
  end
end