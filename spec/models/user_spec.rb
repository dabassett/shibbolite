require 'spec_helper'

# testing main app User as a dummy
# for Shibbolite::User concern
describe User do

  describe 'validations' do

    context 'with nil group' do
      subject { FactoryGirl.build(:user, :group => nil) }
      it { should_not be_valid }
    end

    context 'with nil primary user id' do
      subject { FactoryGirl.build(:user, Shibbolite.pid => nil) }
      it { should_not be_valid }
    end

    context 'with group not listed in Shibbolite.groups' do
      subject { FactoryGirl.build(:user, :group => 'lemur') }
      it { should_not be_valid }
    end

    context 'username already in db' do
      before { FactoryGirl.create(:user) }
      subject { FactoryGirl.build(:user) }
      it { should_not be_valid }
    end

    context 'with group and unique primary_user_id' do
      it 'is valid' do
        expect(FactoryGirl.build(:user)).to be_valid
      end
    end
  end

  describe '.find_user' do

    let!(:user)    { FactoryGirl.create(:user) }
    let(:username) { user.read_attribute(Shibbolite.pid) }

    it 'gets a user with matching primary user id from the database' do
      expect(User.find_user(username)).to eq user
    end
  end
end
