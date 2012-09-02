require "spec_helper"

describe Roles::Role do
  before do
    User.rolify :role_cname => "Role"
    Forum.resourcify :role_cname => "Role"
    Group.resourcify :role_cname => "Role"
    reset_data

    @admin = User.first
    @tourist = User.last
  end

  describe "#with_role" do
    before do
      @admin.add_role(:admin)
      @admin.add_role(:moderator, Forum.first)
      @admin.add_role(:godfather, Forum)
      @tourist.add_role(:moderator, Forum.first)
    end

    specify { User.should respond_to :with_role }
    specify { User.with_role(:admin).should == [@admin] }
    specify { User.with_role(:moderator, Forum.first).should == [@admin, @tourist] }
    specify { User.with_role(:moderator, Forum).should == [] }
    specify { User.with_role(:godfather, Forum).should == [@admin] }
  end

  describe ".add_role" do
    it "should be able to add global role" do
      @admin.add_role :moderator
      @admin.has_role?(:moderator).should be_true
    end

    it "should be able to add role on Forum class" do
      @admin.add_role :moderator, Forum
      @admin.has_role?(:moderator, Forum).should be_true
    end

    it "should be able to add role on a Forum instance" do
      @admin.add_role :moderator, Forum.first
      @admin.has_role?(:moderator, Forum.first).should be_true
    end

    it "should not add duplicate roles" do
      @admin.add_role :moderator
      @admin.add_role :moderator
      @admin.role_names.should == ["moderator"]

      @admin.add_role :moderator, Forum
      @admin.add_role :moderator, Forum
      @admin.role_names(Forum).should == ["moderator"]

      @admin.add_role :moderator, Forum.first
      @admin.add_role :moderator, Forum.first
      @admin.role_names(Forum.first).should == ["moderator"]
    end
  
    it "should be use grant instead of add_role" do
      @tourist.grant :admin
      @tourist.has_role?(:admin).should be_true
    end
  end

  describe ".remove_role" do
    it "should be able to remove global role" do
      @admin.add_role :moderator
      @admin.has_role?(:moderator).should be_true
      @admin.remove_role :moderator
      @admin.has_role?(:moderator).should be_false
    end

    it "should be able to remove role on Forum class" do
      @admin.add_role :moderator, Forum
      @admin.has_role?(:moderator, Forum).should be_true
      @admin.remove_role :moderator, Forum
      @admin.has_role?(:moderator, Forum).should be_false
    end

    it "should be able to remove role on a Forum instance" do
      @admin.add_role :moderator, Forum.first
      @admin.has_role?(:moderator, Forum.first).should be_true
      @admin.remove_role :moderator, Forum.first
      @admin.has_role?(:moderator, Forum.first).should be_false
    end

    it "should be use revoke instead of remove_role" do
      @tourist.grant :admin
      @tourist.has_role?(:admin).should be_true
      @tourist.revoke :admin
      @tourist.has_role?(:admin).should be_false
    end
  end

  describe ".has_role?" do
    it "should be able to has_role? global role" do
      @admin.add_role :moderator
      @admin.add_role :teacher
      @admin.has_role?(:moderator).should be_true
      @admin.has_role?(:teacher).should be_true
    end

    it "should be able to has_role? on Forum class" do
      @admin.add_role :moderator, Forum
      @admin.add_role :teacher, Forum
      @admin.has_role?(:moderator, Forum).should be_true
      @admin.has_role?(:teacher, Forum).should be_true
    end

    it "should be able to has_role? on a Forum instance" do
      @admin.add_role :moderator, Forum.first
      @admin.add_role :teacher, Forum.first
      @admin.has_role?(:moderator, Forum.first).should be_true
      @admin.has_role?(:teacher, Forum.first).should be_true
    end

    it "should be use is_xxx instead of has_role?" do
      @tourist.grant :admin
      @tourist.has_role?(:admin).should be_true
      @tourist.is_admin?.should be_true
    end
  end

  describe ".role_names" do
    it "should be able to list global role names" do
      @admin.add_role :moderator
      @admin.add_role :teacher
      @admin.role_names.should == ["moderator", "teacher"]
    end

    it "should be able to list role names on Forum class" do
      @admin.add_role :moderator, Forum
      @admin.add_role :teacher, Forum
      @admin.role_names(Forum).should == ["moderator", "teacher"]
    end

    it "should be able to list role names on a Forum instance" do
      @admin.add_role :moderator, Forum.first
      @admin.add_role :teacher, Forum.first
      @admin.role_names(Forum.first).should == ["moderator", "teacher"]
    end
  end

  describe ".resources_with_role" do
    before do
      @admin.add_role(:moderator, Forum.first)
      @admin.add_role(:moderator, Forum.last)
      @admin.add_role(:teacher, Forum.last)
      @tourist.add_role(:moderator, Forum.first)
    end

    it "should be able to find all resources of which user has any role" do
      @admin.resources_with_role(Forum).should == [Forum.first, Forum.last]
    end

    it "should be able to find all resources of which user has specific role" do
      @admin.resources_with_role(Forum, :moderator).should == [Forum.first, Forum.last]
      @admin.resources_with_role(Forum, :teacher).should == [Forum.last]
    end
  end

  describe "roles get destroyed when user destroyed" do
    before do
      @admin.roles.create :name => "teacher"
      @admin.roles.create :name => "moderator", :resource_type => "Forum"
      @admin.roles.create :name => "admin", :resource => Forum.first
    end
    
    it "should remove the roles binded to this instance" do
      expect { @admin.destroy }.to change { Role.count }.by(-3)
    end
  end
end
