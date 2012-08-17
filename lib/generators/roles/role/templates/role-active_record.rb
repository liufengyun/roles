class <%= role_cname.camelize %> < ActiveRecord::Base
  belongs_to :<%= user_cname.tableize %>
  belongs_to :resource, :polymorphic => true
  
end
