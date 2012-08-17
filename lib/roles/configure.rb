module Roles
  module Configure
    @@orm = "active_record"
     
    def configure
      yield self if block_given?
    end

    def orm
      @@orm
    end

    def orm=(orm)
      @@orm = orm
    end

    def use_mongoid
      self.orm = "mongoid"
    end
    
    def use_defaults
      configure do |config|
        config.orm = "active_record"
      end
    end
  end
end
