require 'roles/railtie' if defined?(Rails)
require 'roles/role'
require 'roles/resource'

module Roles
  attr_accessor :role_cname
  attr_accessor :user_cname

  def roles(options = {})
    include Role
    
    options.reverse_merge!({:role_cname => 'Role'})

    roles_options = { :class_name => options[:role_cname].camelize }
    roles_options.merge!(options.select{ |k,v| [:before_add, :after_add, :before_remove, :after_remove].include? k.to_sym })

    has_many :roles, roles_options

    self.role_cname = options[:role_cname]
  end

  def resourcify(options = {})
    include Resource
    
    options.reverse_merge!({ :role_cname => 'Role', :dependent => :destroy })
    resourcify_options = { :class_name => options[:role_cname].camelize, :as => :resource, :dependent => options[:dependent] }
    has_many :roles, resourcify_options
    
    self.role_cname = options[:role_cname]
    self.user_cname = options[:user_cname] || 'User'
  end
  
  def user_class
    self.user_cname.constantize
  end

  def role_class
    self.role_cname.constantize
  end
end
