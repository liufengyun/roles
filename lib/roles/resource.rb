module Roles
  module Resource
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods 
      def users_with_role(role_name = nil)
        if role_name.nil?
          self.user_class.joins(:roles).where("roles.resource_type LIKE '%s'", self.to_s).where("roles.resource_id IS NULL")
        else
          self.user_class.joins(:roles).where("roles.resource_type LIKE '%s'", self.to_s).where("roles.resource_id IS NULL").where("roles.name LIKE '%s'", role_name.to_s)
        end
      end
    end

    def users_with_role(role_name = nil)
      if role_name.nil?
        self.class.user_class.joins(:roles).where("roles.resource_type LIKE '%s'", self.class.to_s).where("roles.resource_id = %s", self.id)
      else
        self.class.user_class.joins(:roles).where("roles.resource_type LIKE '%s'", self.class.to_s).where("roles.resource_id = %s", self.id).where("roles.name LIKE '%s'", role_name.to_s)
      end
    end
  end
end
