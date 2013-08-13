module Roles
  module Role
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def with_role(role_name, resource = nil)
        if resource.nil?
          self.includes(role_table).where("#{role_table}.name LIKE '%s'", role_name.to_s).where("#{role_table}.resource_type IS NULL").where("#{role_table}.resource_id IS NULL")
        elsif resource.is_a? Class
          self.includes(role_table).where("#{role_table}.name LIKE '%s'", role_name.to_s).where("#{role_table}.resource_type LIKE '%s'", resource.to_s).where("#{role_table}.resource_id IS NULL")
        else
          self.includes(role_table).where("#{role_table}.name LIKE '%s'", role_name.to_s).where("#{role_table}.resource_type LIKE '%s'", resource.class.to_s).where("#{role_table}.resource_id = %s", resource.id)
        end
      end
    end

    def add_role(role_name, resource = nil)
      if resource.nil?
        self.send(self.class.role_table).where(:resource_type => nil).where(:resource_id => nil).find_or_create_by_name(:name => role_name.to_s)
      elsif resource.is_a? Class
        self.send(self.class.role_table).where(:resource_type => resource.to_s).where(:resource_id => nil).find_or_create_by_name(:name => role_name.to_s)
      else
        self.send(self.class.role_table).where(:resource_type => resource.class.to_s).where(:resource_id => resource.id).find_or_create_by_name(:name => role_name.to_s)
      end
    end
    alias_method :grant, :add_role

    def has_role?(role_name, resource = nil)
      if new_record?
        self.send(self.class.role_table).detect { |r| r.name == role_name.to_s && (r.resource == resource || resource.nil?) }.present?
      else
        if resource.nil?
          self.send(self.class.role_table).where(:name => role_name.to_s).where(:resource_type => nil).where(:resource_id => nil).size > 0
        elsif resource.is_a? Class
          self.send(self.class.role_table).where(:name => role_name.to_s).where(:resource_type => resource.to_s).where(:resource_id => nil).size > 0
        else
          self.send(self.class.role_table).where(:name => role_name.to_s).where(:resource_type => resource.class.to_s).where(:resource_id => resource.id).size > 0
        end
      end
    end

    def remove_role(role_name, resource = nil)
      if resource.nil?
        self.send(self.class.role_table).where(:name => role_name.to_s).where(:resource_type => nil).where(:resource_id => nil).destroy_all
      elsif resource.is_a? Class
        self.send(self.class.role_table).where(:name => role_name.to_s).where(:resource_type => resource.to_s).where(:resource_id => nil).destroy_all
      else
        self.send(self.class.role_table).where(:name => role_name.to_s).where(:resource_type => resource.class.to_s).where(:resource_id => resource.id).destroy_all
      end
    end
    
    alias_method :revoke, :remove_role

    def role_names(resource = nil)
      if resource.nil?
        self.send(self.class.role_table).where(:resource_type => nil).where(:resource_id => nil).select(:name).map { |r| r.name }
      elsif resource.is_a? Class
        self.send(self.class.role_table).where(:resource_type => resource.name).where(:resource_id => nil).select(:name).map { |r| r.name }
      else
        self.send(self.class.role_table).where(:resource_type => resource.class.to_s).where(:resource_id => resource.id).select(:name).map { |r| r.name }
      end
    end

    def resources_with_role(resource_class, role_name = nil)
      if role_name.nil?
        resource_class.includes(self.class.role_table).where("#{self.class.role_table}.#{self.class.user_cname.underscore.singularize}_id = %s", self.id).where("#{self.class.role_table}.resource_type LIKE '%s'", resource_class.to_s)
      else
        resource_class.includes(self.class.role_table).where("#{self.class.role_table}.#{self.class.user_cname.underscore.singularize}_id = %s", self.id).where("#{self.class.role_table}.resource_type LIKE '%s'", resource_class.to_s).where("#{self.class.role_table}.name LIKE '%s'", role_name.to_s)
      end
    end

    def method_missing(method, *args, &block)
      if method.to_s.match(/^is_(\w+)_of[?]$/) || method.to_s.match(/^is_(\w+)[?]$/)
        if self.class.role_class.where(:name => $1).count > 0
          resource = args.first
          return has_role?("#{$1}", resource)
        end
      end
      super
    end

  end
end
