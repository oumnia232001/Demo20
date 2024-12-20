# spec/controllers/posts_controller_spec.rb

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      post1 = Post.create!(title: 'Post 1', content: 'Content 1')
      post2 = Post.create!(title: 'Post 2', content: 'Content 2')

      get :index
      expect(assigns(:posts)).to match_array([post1, post2])
    end
  end

  describe 'GET #new' do
    it 'assigns a new post as @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new post in the database' do
        expect {
          post :create, params: { post: { title: 'Valid Title', content: 'Valid Content' } }
        }.to change(Post, :count).by(1)

        expect(response).to redirect_to Post.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new post' do
        expect {
          post :create, params: { post: { title: '', content: '' } }
        }.not_to change(Post, :count)

        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      post = Post.create!(title: 'Test Title', content: 'Test content')
      get :show, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      post = Post.create!(title: 'Test Title', content: 'Test content')
      get :edit, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the post in the database' do
        post = Post.create!(title: 'Test Title', content: 'Test content')
        patch :update, params: { id: post.id, post: { title: 'Updated Title' } }
        post.reload
        expect(post.title).to eq('Updated Title')
        expect(response).to redirect_to post
      end
    end

    context 'with invalid attributes' do
      it 'does not update the post' do
        post = Post.create!(title: 'Test Title', content: 'Test content')
        original_title = post.title
        patch :update, params: { id: post.id, post: { title: '', content: '' } }
        post.reload
        expect(post.title).to eq(original_title)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes the post from the database' do
      post = Post.create!(title: 'Test Title', content: 'Test content')
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to posts_path
    end
  end
end
