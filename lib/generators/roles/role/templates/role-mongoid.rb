class <%= role_cname.camelize %>
  include Mongoid::Document
  
  belongs_to :<%= user_cname.tableize %>
  belongs_to :resource, :polymorphic => true
  
  field :name, :type => String
  index({ :name => 1 }, { :unique => true })


  index({
    :user_id => 1,
    :name => 1,
    :resource_type => 1,
    :resource_id => 1
  },
  { :unique => true})
  
end
