module Roles
  module Role
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def with_role(role_name, resource = nil)
        if resource.nil?
          self.role_class.where(:name => role_name).where(:resource_type => nil).where(:resource_id => nil)
        elsif resource.is_a Class
          self.role_class.where(:name => role_name).where(:resource_type => resource.to_s).where(:resource_id => nil)
        else
          self.role_class.where(:name => role_name).where(:resource => resource)
        end
      end
    end

    def add_role(role_name, resource = nil)
      if resource.nil?
        self.roles.where(:resource_type => nil).where(:resource_id => nil).find_or_create_by_name(:name => role_name)
      elsif resource.is_a? Class
        self.roles.where(:resource_type => resource.to_s).where(:resource_id => nil).find_or_create_by_name(:name => role_name)
      else
        self.roles.where(:resource => resource).find_or_create_by_name(:name => role_name)
      end
    end
    alias_method :grant, :add_role

    def has_role?(role_name, resource = nil)
      if new_record?
        self.roles.detect { |r| r.name == role_name.to_s && (r.resource == resource || resource.nil?) }.present?
      else
        if resource.nil?
          self.roles.where(:name => role_name).where(:resource_type => nil).where(:resource_id => nil).size > 0
        elsif resource.is_a? Class
          self.roles.where(:name => role_name).where(:resource_type => resource.to_s).where(:resource_id => nil).size > 0
        else
          self.roles.where(:name => role_name).where(:resource => resource).size > 0
        end
      end
    end

    def remove_role(role_name, resource = nil)
      if resource.nil?
        self.roles.where(:name => role_name).where(:resource_type => nil).where(:resource_id => nil).destroy
      elsif resource.is_a Class
        self.roles.where(:name => role_name).where(:resource_type => resource.to_s).where(:resource_id => nil).destroy
      else
        self.roles.where(:name => role_name).where(:resource => resource).destroy
      end
    end
    
    alias_method :revoke, :remove_role

    def role_names(resource = nil)
      if resource.nil?
        self.roles.where(:resource_type => nil).where(:resource_id => nil).select(:name).map { |r| r.name }
      elsif resource.class == Class
        self.roles.where(:resource_type => resource.name).where(:resource_id => nil).select(:name).map { |r| r.name }
      else
        self.roles.where(:resource => resource).select(:name).map { |r| r.name }
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
