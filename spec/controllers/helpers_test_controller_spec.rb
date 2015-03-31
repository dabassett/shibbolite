require 'spec_helper'

# The HelpersTest controller is a dummy used to test
# the Shibbolite::Helpers concern
describe HelpersTestController do

  include_context 'auth_helpers'

  # helper methods
  #

  describe '#current_user' do

    context 'when session is loaded' do

      let(:user) { FactoryGirl.build_stubbed(:user) }

      before do
        session[Shibbolite.pid] = 'someone'
        allow(Shibbolite.user_class).to receive(:find_user).and_return(user)
      end

      it 'fetches the user from the db' do
        get :_current_user
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context 'when no session is loaded' do
      it 'returns nil' do
        get :_current_user
        expect(assigns(:current_user)).to be_nil
      end
    end
  end

  describe '#logged_in?' do

    context 'when session not loaded' do
      it 'is false' do
        session[Shibbolite.pid] = nil
        get :_logged_in?
        expect(assigns(:logged_in)).to be_falsey
      end
    end

    context 'when session is loaded' do
      it 'is true' do
        session[Shibbolite.pid] = 'SSO authenticated'
        get :_logged_in?
        expect(assigns(:logged_in)).to be_truthy
      end
    end
  end

  describe '#anonymous_user?' do

    context 'when session is not loaded' do
      it 'is true' do
        session[Shibbolite.pid] = nil
        get :_anonymous_user?
        expect(assigns(:anonymous)).to be_truthy
      end
    end

    context 'when a session is loaded' do
      it 'is false' do
        session[Shibbolite.pid] = 'SSO authenticated'
        get :_anonymous_user?
        expect(assigns(:anonymous)).to be_falsey
      end
    end
  end

  describe '#guest_user?' do

    context 'when a session is loaded and current_user is nil' do
      it 'is true' do
        session[Shibbolite.pid] = 'SSO authenticated'
        allow(subject).to receive(:current_user).and_return(nil)
        get :_guest_user?
        expect(assigns(:guest)).to be_truthy
      end
    end

    context 'with any other background' do
      it 'is false' do
        session[Shibbolite.pid] = nil
        allow(subject).to receive(:current_user).and_return(nil)
        get :_guest_user?
        expect(assigns(:guest)).to be_falsey
      end
    end
  end

  describe '#registered_user?' do

    context 'when the user exists in the database' do
      it 'is true' do
        allow(subject).to receive(:current_user).and_return('A valid user')
        get :_registered_user?
        expect(assigns(:registered)).to be_truthy
      end
    end

    context 'when the user does not exist in the database' do
      it 'is false' do
        allow(subject).to receive(:current_user).and_return(nil)
        get :_registered_user?
        expect(assigns(:registered)).to be_falsey
      end
    end
  end

  describe '#user_in_group?' do

    let(:user) { double(group: 'jedi') }

    before { allow(subject).to receive(:current_user).and_return(user) }

    it 'is true when user is in group' do
      get :_user_in_group?, group: 'jedi'
      expect(assigns(:result)).to be_truthy
    end

    it 'is false when user is not in group' do
      get :_user_in_group?, group: 'sith'
      expect(assigns(:result)).to be_falsey
    end
  end

  describe '#user_id_match?' do

    let(:user) { double(id: 17) }

    before { allow(subject).to receive(:current_user).and_return(user) }

    it 'is true when user has the id' do
      get :_user_has_id?, id: '17'
      expect(assigns(:result)).to be_truthy
    end

    it 'is false when user does not have the id' do
      get :_user_has_id?, id: '23'
      expect(assigns(:result)).to be_falsey
    end
  end

  describe '#user_has_attribute?' do

    before { set_env_attribute(:department, 'HR') }

    it 'is true when the user has the attribute and value' do
      get :_user_has_attribute?, attr: :department, value: 'HR'
      expect(assigns(:result)).to be_truthy
    end

    it 'is false when the user doesnt have the attribute and/or value' do
      get :_user_has_attribute?, attr: :department, value: 'QA'
      expect(assigns(:result)).to be_falsey
    end
  end
end