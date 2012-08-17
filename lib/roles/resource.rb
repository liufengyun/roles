module Roles
  module Resource
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods 
    end

    def users_with_role(role_name = nil)
      if role_name.nil?
        self.class.user_class.join(:roles).where("roles.resource_type LIKE %s", self.class.to_s).where("roles.resource_id = %s", self.id)
      else
        self.class.user_class.join(:roles).where("roles.resource_type LIKE %s", self.class.to_s).where("roles.resource_id = %s", self.id).where("roles.name LIKE %s", role_name)
      end
    end
  end
end
