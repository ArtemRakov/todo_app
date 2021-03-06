require 'rails_helper'

RSpec.describe ChecklistsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:checklist) { create(:checklist, user: user) }
  let(:checklist_template) { create(:checklist_template) }

  describe '#index' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get :index
        expect(response).to have_http_status '200'
      end

      it 'shows only users checklists' do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
        expect(user).to receive_message_chain(:checklists, :paginate)
        get :index
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'redirects to sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      context 'with valid attributes' do
        let(:checklist_form_params) do
          {
            title: 'test',
            visibility: 'everyone'
          }
        end
        it 'adds a checklist' do
          sign_in user
          expect do
            post :create, params: { checklist_form: checklist_form_params }
          end.to change(user.reload.checklists, :count).by(1)
        end

        it 'adds a checklist template' do
          sign_in user
          expect do
            post :create, params: { checklist_form: checklist_form_params }
          end.to change(user.reload.checklist_templates, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:checklist_form_params) do
          {
            title: '',
            visibility: ''
          }
        end

        it 'does not add a checklist' do
          sign_in user
          expect do
            post :create, params: { checklist_form: checklist_form_params }
          end.to_not change(user.reload.checklists, :count)
        end

        it 'does not add a checklist template' do
          sign_in user
          expect do
            post :create, params: { checklist_form: checklist_form_params }
          end.to_not change(user.reload.checklist_templates, :count)
        end
      end
    end
  end

  describe '#show' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get :show, params: { id: checklist.id }
        expect(response).to have_http_status '200'
      end
    end

    context 'as an unauthenticated user' do
      before do
        sign_in other_user
      end

      it 'redirects to root page' do
        get :show, params: { id: checklist.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#update' do
    context 'as an authenticated user' do
      it 'updates a checklist' do
        checklist_params = attributes_for(:checklist, title: 'New Checklist name')
        sign_in user
        patch :update, params: { id: checklist.id, checklist: checklist_params }
        expect(checklist.reload.title).to eq 'New Checklist name'
      end
    end

    context 'as an unauthenticated user' do
      before do
        sign_in other_user
      end

      it 'does not update checklist' do
        checklist_params = attributes_for(:checklist, title: 'New checklist name')
        patch :update, params: { id: checklist.id, checklist: checklist_params }
        expect(checklist.reload.title).to_not eq 'New checklist name'
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      it 'deletes a checklist' do
        sign_in user
        expect do
          delete :destroy, params: { id: checklist.id }
        end.to change(user.checklists, :count).by(-1)
      end
    end

    context 'as an unauthenticated user' do
      before do
        sign_in other_user
      end

      it 'does not delete checklist' do
        expect do
          delete :destroy, params: { id: checklist.id }
        end.to_not change(Checklist, :count)
      end
    end
  end
end
