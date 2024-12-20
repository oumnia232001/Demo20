# spec/controllers/comments_controller_spec.rb
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:post) { Post.create!(title: 'Test Post', content: 'Test Content') }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new comment' do
        expect {
          post :create, params: { post_id: post.id, comment: { name: 'Jane Doe', comment: 'New Comment' } }
        }.to change(Comment, :count).by(1)

        expect(response).to redirect_to(post_path(post))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment' do
        expect {
          post :create, params: { post_id: post.id, comment: { name: '', comment: '' } }
        }.not_to change(Comment, :count)

        expect(response).to redirect_to(post_path(post))
      end
    end
  end
end
