class RolesCreate<%= role_cname.pluralize.camelize %> < ActiveRecord::Migration
  def change
    create_table(:<%= role_cname.tableize %>) do |t|
      t.string :name
      t.references :resource, :polymorphic => true
      t.references :<%= user_cname.underscore.singularize %>

      t.timestamps
    end

    add_index(:<%= role_cname.tableize %>, :name)
    add_index(:<%= role_cname.tableize %>, [ :name, :resource_type, :resource_id ])
    add_index(:<%= role_cname.tableize %>, [ :<%= user_cname.underscore.singularize %>_id, :name ])
  end
end
