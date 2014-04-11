require 'spec_helper'

describe UsersController do
	context 'View own user perfil' do
		before(:each) do
  		@user = create(:user, dni: '43434433', password: 'holapumba', password_confirmation: 'holapumba')  		
    	sign_in @user
  	end
  	describe 'Get #mi_perfil' do
  		it "renders the :mi_perfil view" do
  			get :mi_perfil
  			expect(response).to render_template :mi_perfil
  		end
  	end
  	describe 'Get #mi_perfil' do
  		it "loads current user into @user" do
  			get :mi_perfil
  			expect(assigns(:user)).to eq(@user)
  		end
  	end
	end
	context 'Change own user password' do
		before(:each) do
  		@user = create(:user, dni: '43434433', password: 'holapumba', password_confirmation: 'holapumba')  		
    	sign_in @user
  	end
  	describe 'Get #edit_password' do
  		it "renders the :edit_password view" do
	      get :edit_password
	      expect(response).to render_template :edit_password
	    end
	    it "loads current user into @user" do
      	get :edit_password
      	expect(assigns(:user)).to eq(@user)
    	end 
  	end
  	describe 'Patch #update_password' do
  		it 'Not success with invalid current_password' do
  			patch :update_password, user:{current_password: 'sfsafsaaaa', 
  															password: 'holapumba', password_confirmation: 'holapumba'}
  			flash[:alert].should =~ /Hubo un problema. Recuerde que el password debe /i 
  		end
  		it 'Not success with invalids new password' do
  			patch :update_password, user:{current_password: 'holapumba', 
  															password: 'hola', password_confirmation: 'hola'}
  			expect(response).to render_template :edit_password
  		end
  		it 'Not success with diferent new password' do
  			patch :update_password, user:{current_password: 'holapumba', 
  															password: 'holapumba2', password_confirmation: 'holapumba3'}
  			expect(response).to render_template :edit_password
  		end
  		it 'sets the correct flash message on success' do
  			patch :update_password, user:{current_password: 'holapumba', 
  															password: 'holapumba2', password_confirmation: 'holapumba2'}
  			flash[:notice].should =~ /Se ha cambiado su password correctamente/i
  		end
  		it 'redirects to the dahsboard path on success' do
  			patch :update_password, user:{current_password: 'holapumba', 
  															password: 'holapumba2', password_confirmation: 'holapumba2'}
  			expect(response).to redirect_to dashboard_path 												
  		end
  	end
	end
  context 'Manage: not authorized user' do
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
	  	it 'tries to make a update request' do
	  		patch :update, id: @user , user: {dni: '21212121', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'false', organizacional: 'true'}
	      expect(response).to redirect_to root_path 
	  	end
	  	it 'tries to reset a passwrod' do
	  		post :reset_password, user_id: @user.id
	      expect(response).to redirect_to root_path 
	  	end		  	
	  end
  end
  context 'Manage: authorized user' do
  	before(:each) do
  		@user = create(:superadmin)
  		sign_in @user
  	end
  	describe 'Post #reset_password' do
  		context 'the same user' do
  			it 'sets error flash message' do
  				post :reset_password, user_id: @user.id
  				flash[:alert].should =~ /Hubo un problema. No puedes resetear tu propio usuario/i
  			end
  			it 'not chages the password' do
  				password = @user.password
  				post :reset_password, user_id: @user.id
  				@user.reload
  				expect(@user.password).to eq(password)
  			end 
  		end
  		context 'other users' do
  			before(:each) do
		  		@user2 = create(:user, dni:'22222222', password: 'holapumba', password_confirmation:'holapumba')
		  	end
  			it 'changes the user password' do
  				password = @user.password
  				post :reset_password, user_id: @user2.id
  				@user2.reload
  				expect(@user2.password).to_not eq(password)
  			end
  			it 'sets error flash message' do
  				post :reset_password, user_id: @user2.id
  				flash[:notice].should =~ /Se ha reseteado correctamente./i
  			end 			
  		end
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
	    it 'located the request @user' do
	    	get :edit, id: @user.id
	    	expect(assigns(:user)).to eq(@user)
	    end  
		end
		describe 'PATCH #update' do
	    before :each do
	      @usuario = create(:user, dni: '21212121', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: false, admin: false, organizacional: true)
	    end

	    context "valid attributes" do
	      it "located the requested @user" do
	        patch :update, id: @usuario , user: {dni: '21212121', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'false', organizacional: 'true'}
	        expect(assigns(:user)).to eq(@usuario)
	      end

	      it "changes @usuario attributes" do
	        patch :update, id: @usuario , user: {dni: '21212122', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	        @usuario.reload
	        expect(@usuario.dni).to eq("21212122")
	        expect(@usuario.admin).to eq(true)
	      end

	      it "redirects to the usarios#index" do
	        patch :update, id: @usuario , user: {dni: '21212122', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	        expect(response).to redirect_to users_path
	      end
	      it "sets the updated message" do
	        patch :update, id: @usuario , user: {dni: '21212122', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	        flash[:notice].should =~ /Se actualizó correctamente el usuario/i
	      end
	      it 'tries to update his own superuser account' do
	      	patch :update, id: @user , user: {dni: '21212122', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	      	@user.reload
	      	expect(@user.superadmin).to eq(true)
	      	expect(@user.admin).to eq(true)
	      	expect(@user.organizacional).to eq(true)								
	      end
	    end

	    context "with invalid attributes" do
	      it "does not change the enfermeras's attributes" do
	        patch :update, id: @usuario , user: {dni: '212121222', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	        @usuario.reload
	        expect(@usuario.dni).to_not eq("212121222")
	      end

	      it "re-renders the edit template" do
	        patch :update, id: @usuario , user: {dni: '212121222', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	        expect(response).to render_template :edit
	      end

	      it "sets the error message" do
	        patch :update, id: @usuario , user: {dni: '212121222', apellidos_nombres: 'hola', cargo: 'Jefe',
	      									superadmin: 'false', admin: 'true', organizacional: 'true'}
	        flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
	      end
	    end
	  end
  end
end

