require 'roles'
require 'rails'

module Rolies
  class Railtie < Rails::Railtie
    initializer 'roles.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, Roles
      end
      
      config.before_initialize do
        ::Mongoid::Document.module_eval do
          def self.included(base)
            base.extend Roles
          end
        end
      end if defined?(Mongoid)
    end
  end
end
