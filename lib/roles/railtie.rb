require 'roles'
require 'rails'

module Rolies
  class Railtie < Rails::Railtie
    initializer 'roles.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, Roles
      end
    end
  end
end
