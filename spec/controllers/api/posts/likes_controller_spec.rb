require 'rails_helper'

RSpec.describe API::Posts::LikesController do
  describe 'Access Control' do
    before :each do
      @author = create(:user)
      @post = create(:post, user: @author)
    end

    describe 'POST #create' do
      it 'requires a logged-in user' do
        post :create, params: { post_id: @post.id }
        expect(response.status).to eq(302)
      end

      context 'when user is logged in' do
        before :each do
          @user = create(:user)
          login @user
        end

        it 'allows user to like a post' do
          post :create, params: { post_id: @post.id }
          expect(@user.liked?(@post)).to be_truthy
        end

        it 'notifies the author' do
          expect { post :create, params: { post_id: @post.id } }.to change(@author.notifications, :count).by(1)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'requires a logged-in user' do
        delete :destroy, params: { post_id: @post.id }
        expect(response.status).to eq(302)
      end

      context 'when user is logged in' do
        before :each do
          @user = create(:user)
          login @user
          @user.add_like_to(@post)
        end

        it 'allows user to unlike a post' do
          delete :destroy, params: { post_id: @post.id }
          expect(@user.liked?(@post)).to be_falsy
        end
      end
    end
  end
end
