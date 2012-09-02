class <%= role_cname.camelize %> < ActiveRecord::Base
  belongs_to :<%= user_cname.tableize.singularize %>
  belongs_to :resource, :polymorphic => true
  
  validates_uniqueness_of :name, :scope => [:<%= user_cname.underscore.singularize %>_id, :resource_type, :resource_id]
end
