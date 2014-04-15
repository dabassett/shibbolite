require 'spec_helper'

module Shibbolite
  describe ShibbolethController do

    describe '#access_denied' do
      before do
        session[:requested_url] = '/Narnia'
        get :access_denied
      end

      it 'assigns the requested url' do
        expect(assigns(:requested_url)).to eq('/Narnia')
      end

      it 'renders' do
        expect(response).to render_template :access_denied
      end
    end

    describe '#login' do
      context 'session loaded successfully' do
        before do
          allow(subject).to receive(:logged_in?).and_return true
          session[:requested_url] = '/Hoth'
        end

        it 'redirects back to original action' do
          get :login
          expect(response).to redirect_to '/Hoth'
        end
      end

      context 'no shibboleth session' do
        it 'redirects to the SP for authentication' do
          get :login
          expect(response).to redirect_to subject.send(:sp_login_url)
        end
      end
    end

    describe '#logout' do
      it 'deletes the session user id' do
        session[Shibbolite.pid] = 'Han Solo'
        get :logout
        expect(session[Shibbolite.pid]).to be_nil
      end

      it 'redirects to the SP for logout' do
        get :logout
        expect(response).to redirect_to subject.send(:sp_logout_url)
      end
    end

    describe '#logout_message' do
      subject { get :logout_message }
      it { should render_template :logout_message }
    end

    context 'methods that require the environment hash' do

      let!(:environment) { FactoryGirl.build(:environment_hash).with_indifferent_access }
      let(:attributes)   { FactoryGirl.build(:shibboleth_attributes).with_indifferent_access }
      let!(:user)        { FactoryGirl.build_stubbed(:user) }

      before do
        allow(request).to receive(:env).and_return(environment)
        allow(Shibbolite.user_class).to receive(:find_user).and_return(user)
      end

      describe '#load_session' do

        before { allow(user).to receive(:update) }

        context 'when user authenticated with sso' do

          before { subject.send(:load_session) }

          it 'sets user\'s primary key (primary_user_id) in session' do
            expect(session[Shibbolite.pid]).to eq(environment[Shibbolite.pid])
          end

          it "updates the user's shibboleth attributes" do
            expect(user).to have_received(:update).with(attributes)
          end
        end

        context 'when user is not authenticated with sso' do

          before do
            environment[Shibbolite.pid] = nil
            subject.send(:load_session)
          end

          it 'sets no session id' do
            expect(session[Shibbolite.pid]).to be_nil
          end

          it 'does not update user attributes' do
            expect(user).not_to have_received(:update)
          end
        end
      end

      describe '#get_attributes' do

        it 'returns a hash of shibboleth attributes' do
          attrs = subject.send(:get_attributes)
          expect(attrs).to eq(attributes)
        end
      end
    end
  end
end