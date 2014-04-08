require 'spec_helper'

describe UsersController do
  context 'not authorized user' do
  	before(:each) do
  		@user = create(:user)
    	sign_in @user
  	end
  	describe 'GETs' do
	    it "tries to render the :index view" do
	      get :index
	      expect(response).to redirect_to root_path   
	    end
	    it 'tries to render the :new view' do
	    	get :new
	      expect(response).to redirect_to root_path
	    end
	    it 'tries to render the :edit view' do
	    	get :edit, id: @user.id
	      expect(response).to redirect_to root_path
	    end
	  end
	  describe 'Post methods' do
	  	it 'tries to make a post on create' do
	  		post :create, user: {dni: '45454545', cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	      expect(response).to redirect_to root_path    										
	  	end
	  end
  end
  context 'authorized user' do
  	before(:each) do
  		@user = create(:superadmin)
  		sign_in @user
  	end
  	describe 'GET #index' do
	    it "renders the :index view" do
	      get :index
	      expect(response).to render_template :index
	    end
	    it "loads all of the users into @users" do
      	user2 = create(:user, dni: '43434343', apellidos_nombres: 'Abad Abad Juan')
      	get :index
      	expect(assigns(:users)).to match_array([user2, @user])
    	end
	  end
	  describe 'GET #new' do
	  	it "renders the :new view" do
	      get :new
	      expect(response).to render_template :new
	    end  
		end
		describe 'POST #create' do
			context 'with valid attributes' do
				it "saves the new user in the database" do
	        expect{
	          post :create, user: {dni: '45454545', cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	        }.to change(User, :count).by(1)
	      end

	      it "redirects to users#index" do
	        post :create, user: {dni: '45454545', cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	        expect(response).to redirect_to users_path
	      end

	      it "show the creation flash message" do
	        post :create, user: {dni: '45454545', cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	        flash[:notice].should =~ /Se registró correctamente el usuario/i
	      end
			end
			context 'with invalid attributes' do
				it "does not save the new user in the database" do
	        expect{
	          post :create, user: {dni: '454545455', cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	        }.to_not change(User, :count)
	      end
	      it "re-renders the :new template" do
	        post :create, user: { cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	        expect(response).to render_template :new
	      end
	      it "show the fail flash message" do
	        post :create, user: { cargo: 'Secretario',
	          										apellidos_nombres: 'Wenceslao Paez'}
	        flash[:alert].should =~ /Hubo un problema. No se registró el usuario/i
	      end
			end
		end

		describe 'GET #edit' do
			it "renders the :edit view" do
	      get :edit, id: @user.id
	      expect(response).to render_template :edit
	    end  
		end
  end
end

