require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  before do
    sign_in user # Simule l'utilisateur connecté
  end

  describe 'GET #index' do
  context 'when no query is provided' do
    it 'assigns all posts as @posts' do
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)

      get :index
      expect(assigns(:posts)).to match_array([post1, post2])
    end
  end

  context 'when a query is provided' do
    it 'filters posts based on the query' do
      matching_post = create(:post, user: user, title: 'Matching Post')
      non_matching_post = create(:post, user: user, title: 'Other Post')

      get :index, params: { query: 'Matching' }
      expect(assigns(:posts)).to eq([matching_post])
    end
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
      it 'creates a new post' do
        expect {
          process :create, method: :post, params: { post: { title: 'New Post', content: 'Post content' } }
        }.to change(Post, :count).by(1)
      end

      it 'assigns the created post to the current user' do
        process :create, method: :post, params: { post: { title: 'New Post', content: 'Post content' } }
        expect(Post.last.user).to eq(user)
      end

      it 'redirects to the created post' do
        process :create, method: :post, params: { post: { title: 'New Post', content: 'Post content' } }
        expect(response).to redirect_to(Post.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new post' do
        expect {
          process :create, method: :post, params: { post: { title: '', content: '' } }
        }.to_not change(Post, :count)
      end

      it 'renders the new template' do
        process :create, method: :post, params: { post: { title: '', content: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      get :show, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      get :edit, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the post in the database' do
        patch :update, params: { id: post.id, post: { title: 'Updated Title' } }
        post.reload
        expect(post.title).to eq('Updated Title')
        expect(response).to redirect_to(post)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the post' do
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
      post_to_delete = create(:post, user: user)

      expect {
        delete :destroy, params: { id: post_to_delete.id }
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
    end
  end
end
