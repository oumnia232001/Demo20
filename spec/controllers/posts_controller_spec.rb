require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  before do
    sign_in user  # Assurez-vous que l'utilisateur est connecté
  end

  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)

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

  describe 'POST #create' do  #This block defines the overall test 
    context 'with valid attributes' do
      it 'saves the new post in the database' do #Test Scenario
        expect {
          post posts_path, params: { post: { title: 'Valid Title', content: 'Valid Content', user_id: user.id } }
        }.to change(Post, :count).by(1)

        expect(response).to redirect_to Post.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new post' do
        expect {
          post posts_path, params: { post: { title: '', content: '', user_id: user.id } }
        }.not_to change(Post, :count)

        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      get post_path(post)
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      get edit_post_path(post)
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the post in the database' do
        patch post_path(post), params: { post: { title: 'Updated Title' } }
        post.reload
        expect(post.title).to eq('Updated Title')
        expect(response).to redirect_to(post)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the post' do
        original_title = post.title
        patch post_path(post), params: { post: { title: '', content: '' } }
        post.reload
        expect(post.title).to eq(original_title)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes the post from the database' do
      expect {
        delete post_path(post)
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
    end
  end
end
