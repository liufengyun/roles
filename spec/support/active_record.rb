require 'active_record'

RSpec::Matchers::OperatorMatcher.register(ActiveRecord::Relation, '=~', RSpec::Matchers::BuiltIn::MatchArray)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.extend Roles

load File.dirname(__FILE__) + '/schema.rb'

# ActiveRecord models
class User < ActiveRecord::Base
end

class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic => true
end

class Forum < ActiveRecord::Base
  #resourcify done during specs setup to be able to use custom user classes
end

class Group < ActiveRecord::Base
  #resourcify done during specs setup to be able to use custom user classes
end

class Customer < ActiveRecord::Base
end

class Privilege < ActiveRecord::Base
  belongs_to :customer
  belongs_to :resource, :polymorphic => true
end
