require 'rails/generators/migration'

module Roles
  module Generators
    class RoleGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)
      argument :role_cname, :type => :string, :default => "Role"
      argument :user_cname, :type => :string, :default => "User"
      argument :orm_adapter, :type => :string, :default => "active_record"

      desc "Generates a model with the given NAME and a migration file."

      def generate_role
        template "role-#{orm_adapter}.rb", "app/models/#{role_cname.underscore}.rb"
        inject_into_file(model_path, :after => inject_roles_method) do
          "  roles" + (role_cname == "Role" ? "" : " :role_cname => '#{role_cname.camelize}'") + "\n"
        end
      end

      def copy_role_file
        migration_template "migration.rb", "db/migrate/roles_create_#{role_cname.tableize}" if orm_adapter == "active_record"
      end

      def model_path
        File.join("app", "models", "#{user_cname.underscore}.rb")
      end
      
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      
      def show_readme
        readme "README-#{orm_adapter}" if behavior == :invoke
      end
      
      def inject_roles_method
        if orm_adapter == "active_record"
          /class #{user_cname.camelize}\n|class #{user_cname.camelize} .*\n/
        else
          /include Mongoid::Document\n|include Mongoid::Document .*\n/
        end
      end
    end
  end
end
