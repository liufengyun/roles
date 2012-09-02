require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/roles/role/role_generator'

describe Roles::Generators::RoleGenerator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)
  teardown :cleanup_destination_root
  
  before {
    prepare_destination
  }
  
  def cleanup_destination_root
    FileUtils.rm_rf destination_root
  end

  describe 'no arguments' do
    before(:all) { arguments [] }

    before { 
      capture(:stdout) {
        generator.create_file "app/models/user.rb" do
          "class User < ActiveRecord::Base\nend"
        end
      }
      run_generator 
    }
    
    describe 'app/models/role.rb' do
      subject { file('app/models/role.rb') }
      it { should exist }
      it { should contain "class Role < ActiveRecord::Base" }
      it { should contain "belongs_to :user" }
      it { should contain "belongs_to :resource, :polymorphic => true" }
      it { should contain "validates_uniqueness_of :name, :scope => [:user_id, :resource_type, :resource_id]" }
    end
    
    describe 'app/models/user.rb' do
      subject { file('app/models/user.rb') }
      it { should contain /class User < ActiveRecord::Base\n  rolify\n/ }
    end
    
    describe 'migration file' do
      subject { migration_file('db/migrate/roles_create_roles.rb') }
      
      it { should be_a_migration }
      it { should contain "create_table(:roles) do" }
    end
  end

  describe 'specifying user and role names' do
    before(:all) { arguments %w(AdminRole AdminUser) }
    
    before { 
      capture(:stdout) {
        generator.create_file "app/models/admin_user.rb" do
          "class AdminUser < ActiveRecord::Base\nend"
        end
      }
      run_generator
    }
    
    describe 'app/models/rank.rb' do
      subject { file('app/models/admin_role.rb') }
      
      it { should exist }
      it { should contain "class AdminRole < ActiveRecord::Base" }
      it { should contain "belongs_to :admin_user" }
      it { should contain "belongs_to :resource, :polymorphic => true" }
      it { should contain "validates_uniqueness_of :name, :scope => [:admin_user_id, :resource_type, :resource_id]" }
    end
    
    describe 'app/models/admin_user.rb' do
      subject { file('app/models/admin_user.rb') }
      
      it { should contain /class AdminUser < ActiveRecord::Base\n  rolify :role_cname => 'AdminRole'\n/ }
    end
    
    describe 'migration file' do
      subject { migration_file('db/migrate/roles_create_admin_roles.rb') }
      
      it { should be_a_migration }
      it { should contain "create_table(:admin_roles)" }
    end
  end
end
