require 'spec_helper'

# a dummy controller used to test the Shibbolite::Filters concern

describe FiltersTestController do

  include_context 'auth_helpers'

  # presume the session has been loaded
  before { allow(subject).to receive(:load_session) }

  describe '#require_login' do

    context 'when logged in' do
      it 'allows the action to continue' do
        allow(subject).to receive(:logged_in?).and_return(true)
        get :_require_login
        expect(response).to render_template(:dummy)
      end
    end

    context 'when not logged in' do
      before { allow(subject).to receive(:logged_in?).and_return(false) }

      it 'redirects' do
        get :_require_login
        expect(response).to redirect_to('/shibbolite/login')
      end

      # see feature spec for complete test
      it 'responds to ajax requests' do
        xhr :get, :_require_login
        expect(response.body).to include('window.location')
      end
    end
  end

  describe '#require_registered' do

    context 'when user is registered' do
      it 'allows the action to continue' do
        allow(subject).to receive(:registered_user?).and_return(true)
        get :_require_registered
        expect(response).to render_template(:dummy)
      end
    end

    context 'when the user is not registered' do
      it 'redirects' do
        allow(subject).to receive(:registered_user?).and_return(false)
        get :_require_registered
        expect(response).to redirect_to('/shibbolite/login')
      end
    end
  end

  describe '#use_attributes_if_available' do

    context 'when the user authenticated but login is not required' do
      it 'redirects to login to load the session' do
        allow(subject).to receive(:logged_in?).and_return(false)
        request.env[Shibbolite.pid.to_s] = 'not nil'
        get :_use_attributes_if_available
        expect(response).to redirect_to('/shibbolite/login')
      end
    end

    context 'when the user did not authenticate' do
      it 'allows the action' do
        get :_use_attributes_if_available
        expect(response).to render_template(:dummy)
      end
    end
  end

  describe '#require_attribute' do

    it 'executes action when user has the attribute' do
      set_env_attribute(:department, '9th Circle')
      get :_require_attribute, attr: :department, value: '9th Circle'
      expect(response).to render_template(:dummy)
    end

    it 'redirects when user does not have the attribute' do
      get :_require_attribute, attr: :dragon, value: 'Smaug'
      expect(response).to redirect_to('/shibbolite/login')
    end

    it 'redirects when user has an incorrect value for the attribute' do
      set_env_attribute(:department, 'Complaints')
      get :_require_attribute, attr: :department, value: '9th Circle'
      expect(response).to redirect_to('/shibbolite/login')
    end
  end

  context 'filters that require a user object' do

    let!(:user_id)  { 17 }
    let!(:admin_id) { 1 }
    let(:guest) { double('guest', id: nil,      group: nil )}
    let(:user)  { double('user' , id: user_id,  group: 'user')}
    let(:admin) { double('admin', id: admin_id, group: 'admin' )}

    describe '#require_group' do

      context 'when the user has a group listed' do
        it 'allows the action to continue' do
          allow(subject).to receive(:current_user).and_return(user)
          get :_require_group, groups: ['user', 'admin']
          expect(response).to render_template(:dummy)
        end
      end

      context 'when the user is not a member' do
        it 'redirects' do
          allow(subject).to receive(:current_user).and_return(guest)
          get :_require_group, groups: ['user', 'admin']
          expect(response).to redirect_to('/shibbolite/login')
        end
      end
    end

    describe '#require_id' do

      context 'when the user has the id listed' do
        it 'allows the action to continue' do
          allow(subject).to receive(:current_user).and_return(admin)
          get :_require_id, id: admin_id
          expect(response).to render_template(:dummy)
        end
      end

      context 'when the user does not have the id' do
        it 'redirects' do
          allow(subject).to receive(:current_user).and_return(guest)
          get :_require_id, id: user_id
          expect(response).to redirect_to('/shibbolite/login')
        end
      end
    end

    describe '#require_group_or_id' do

      context 'happy paths' do

        it 'allows action with matching id' do
          allow(subject).to receive(:current_user).and_return(user)
          get :_require_group_or_id, groups: 'admin', id: user_id
          expect(response).to render_template(:dummy)
        end

        it 'allows action with matching group' do
          allow(subject).to receive(:current_user).and_return(user)
          get :_require_group_or_id, groups: 'user', id: admin_id
          expect(response).to render_template(:dummy)
        end

        it 'allows action with both id and group matching' do
          allow(subject).to receive(:current_user).and_return(admin)
          get :_require_group_or_id, groups: 'admin', id: admin_id
          expect(response).to render_template(:dummy)
        end
      end

      context 'with no matching criteria' do
        it 'redirects' do
          allow(subject).to receive(:current_user).and_return(guest)
          get :_require_group_or_id, groups: 'user', id: user_id
          expect(response).to redirect_to('/shibbolite/login')
        end
      end
    end

    describe '#require_group_or_attribute' do
      context 'happy paths' do

        it 'executes action when user has the attribute' do
          set_env_attribute(:department, '9th Circle')
          get :_require_group_or_attribute, groups: 'admin', attr: :department, value: '9th Circle'
          expect(response).to render_template(:dummy)
        end

        it 'allows action with matching group' do
          allow(subject).to receive(:current_user).and_return(admin)
          get :_require_group_or_id, groups: 'admin', attr: :department, value: '9th Circle'
          expect(response).to render_template(:dummy)
        end

        it 'allows action with both attribute and group matching' do
          set_env_attribute(:department, '9th Circle')
          allow(subject).to receive(:current_user).and_return(admin)
          get :_require_group_or_id, groups: 'admin', attr: :department, value: '9th Circle'
          expect(response).to render_template(:dummy)
        end
      end

      context 'with no matching criteria' do
        it 'redirects' do
          get :_require_attribute, attr: :wizard, value: 'Gandalf'
          expect(response).to redirect_to('/shibbolite/login')
        end
      end
    end
  end
end