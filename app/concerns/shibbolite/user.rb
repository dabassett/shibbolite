module Shibbolite
  module User
    extend ActiveSupport::Concern

    included do
      unless Shibbolite.skip_validations
        validates Shibbolite.primary_user_id, :group, presence: true
        validates Shibbolite.primary_user_id, uniqueness: true
        validates :group, inclusion: { in: Shibbolite.groups.map(&:to_s),
                  message: "%{value} is not included in Shibbolite.groups" }
      end
    end

    module ClassMethods
      # gets the user who matches the shibboleth primary key
      def find_user(pid)
        find_by(Shibbolite.primary_user_id => pid)
      end
    end
  end
end