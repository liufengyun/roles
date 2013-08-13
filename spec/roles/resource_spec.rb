require "spec_helper"

describe Roles::Resource do
  before do
    User.rolify
    Forum.resourcify
    Group.resourcify
    reset_data
  end

  # Users
  let(:admin)   { User.first }
  let(:tourist) { User.last }

  describe "#users_with_role" do
    before do
      admin.add_role(:moderator, Forum.first)
      admin.add_role(:admin, Forum.first)
      admin.add_role(:admin, Forum)
      tourist.add_role(:moderator, Forum.first)
    end

    context "on a Forum instance" do
      subject { Forum.first }
      it { should respond_to :users_with_role }
      specify { subject.users_with_role.should == [admin, tourist] }
      specify { subject.users_with_role(:moderator).should == [admin, tourist] }
      specify { subject.users_with_role(:admin).should == [admin] }
      specify { subject.users_with_role(:teacher).should == [] }
    end

    context "on Forum class" do
      specify { Forum.should respond_to :users_with_role }
      specify { Forum.users_with_role.should == [admin] }
      specify { Forum.users_with_role(:moderator).should == [] }
      specify { Forum.users_with_role(:admin).should == [admin] }
    end

    context "on a Group instance" do
      subject { Group.last }

      context "when deleting a Group instance" do
        subject do 
          Group.create(:name => "to delete")
        end
        
        before do
          subject.roles.create :name => "group_role1", :user => admin
          subject.roles.create :name => "group_role2", :user => tourist
        end
        
        it "should remove the roles binded to this instance" do
          expect { subject.destroy }.to change { Role.count }.by(-2)
        end
      end
    end
  end

end
