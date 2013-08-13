require 'roles/railtie' if defined?(Rails)
require 'roles/role'
require 'roles/resource'

module Roles
  attr_accessor :role_cname
  attr_accessor :user_cname

  def rolify(options = {})
    include Role
    
    options.reverse_merge!({:role_cname => 'Role'})
    options.reverse_merge!({:user_cname => 'User'})

    roles_options = { :class_name => options[:role_cname].camelize, :dependent => :destroy }
    roles_options.merge!(options.select{ |k,v| [:before_add, :after_add, :before_remove, :after_remove].include? k.to_sym })

    self.role_cname = options[:role_cname]
    self.user_cname = options[:user_cname]

    has_many self.role_table.to_sym, roles_options
  end

  def resourcify(options = {})
    include Resource
    
    options.reverse_merge!({ :role_cname => 'Role', :dependent => :destroy, :user_cname => 'User' })
    resourcify_options = { :class_name => options[:role_cname].camelize, :as => :resource, :dependent => options[:dependent] }
    
    self.role_cname = options[:role_cname]
    self.user_cname = options[:user_cname]

    has_many self.role_table.to_sym, resourcify_options
  end

  def user_table
    @user_table ||= self.user_table.tableize
  end

  def role_table
    @role_table ||= self.role_cname.tableize
  end
  
  def user_class
    @user_class ||= self.user_cname.constantize
  end

  def role_class
    @role_class ||= self.role_cname.constantize
  end
end
