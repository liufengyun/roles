ActiveRecord::Schema.define do
  self.verbose = false

  create_table(:roles) do |t|
    t.string :name
    t.references :resource, :polymorphic => true
    t.references :user

    t.timestamps
  end

  create_table(:users) do |t|
    t.string :login
  end

  create_table(:forums) do |t|
    t.string :name
  end

  create_table(:groups) do |t|
    t.string :name
  end

  create_table(:privileges) do |t|
    t.string :name
    t.references :resource, :polymorphic => true
    t.references :customer
  end

  create_table(:customers) do |t|
    t.string :login
  end
end
