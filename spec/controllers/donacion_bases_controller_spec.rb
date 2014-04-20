require 'spec_helper'

describe DonacionBasesController do

  describe 'GET #index' do
    describe 'authorized organizacional user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @base = create(:base)
      end
      it "renders the :index view" do
        get :index, basis_id: @base.id
        expect(response).to render_template :index
      end
    end
    describe 'authorized admin user' do
      before (:each) do
        @user = create(:admin)
        sign_in  @user
        @base = create(:base)
      end
      it "renders the :index view" do
        get :index, basis_id: @base.id
        expect(response).to render_template :index
      end
    end
    describe 'authorized reader user' do
      before (:each) do
        @user = create(:reader)
        sign_in  @user
        @base = create(:base)
      end
      it "renders the :index view" do
        get :index, basis_id: @base.id
        expect(response).to render_template :index
      end
    end
    describe 'un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @base = create(:base)
      end
      it "show the correct access negated message" do
        get :index, basis_id: @base.id
        flash[:alert].should =~ /Acceso denegado./
      end      
    end
  end
  describe 'GET #new' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @base = create(:base)
      end
      it "renders the :new view" do
        get :new, basis_id: @base.id
        expect(response).to render_template :new
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @base = create(:base)
      end
      it "show the correct access negated message" do
        get :new, basis_id: @base.id
        flash[:alert].should =~ /Acceso denegado./
      end           
    end        
  end

  describe "POST #create" do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @base = create(:base)
      end
      describe "with valid attributes" do
        it "saves the new bitacora in the database" do
          expect{
            post :create, basis_id: @base.id, donacion_base: {product_name: "Escritorio", 
                          category: 'PENDIENTE'}}.to change(@base.donaciones, :count).by(1)
        end

        it "redirects to enfermera_bitacoras_path" do
          post :create, basis_id: @base.id, donacion_base: {product_name: "Escritorio", 
                          category: 'PENDIENTE'}
          expect(response).to redirect_to basis_donacion_bases_path(@base.id)
        end

        it "show the creation flash message" do
          post :create, basis_id: @base.id, donacion_base: {product_name: "Escritorio", 
                          category: 'PENDIENTE'}
          flash[:notice].should =~ /Se registró correctamente/i
        end

      end

      describe "with invalid attributes" do
        it "does not save the new bitacora in the database" do
          expect{
            post :create, basis_id: @base.id, donacion_base: {product_name: nil, 
                          category: 'PENDIENTE'}
          }.to_not change(@base.donaciones, :count)
        end
        it "re-renders the :new template" do
          post :create, basis_id: @base.id, donacion_base: {product_name: nil, 
                          category: 'PENDIENTE'}
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, basis_id: @base.id, donacion_base: {product_name: nil, 
                          category: 'PENDIENTE'}
          flash[:alert].should =~ /Hubo un problema. No se registró/i
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
      end
      it "show the correct access negated message" do
        post :create, basis_id: @base.id, donacion_base: {product_name: "Escritorio", 
                          category: 'PENDIENTE'}
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'GET #edit' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @base = create(:base)
        @donacion = create(:donacion_basis, base_id: @base.id)
      end
      it "assigns the requested donacion to @donacion" do
        get :edit, basis_id: @base.id, id: @donacion.id
        expect(assigns(:donacion)).to eq @donacion
      end

      it "renders the :edit template" do
        get :edit, basis_id: @base.id, id: @donacion.id
        expect(response).to render_template :edit
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @base = create(:base)
        @donacion = create(:donacion_basis, base_id: @base.id)
      end
      it "show the correct access negated message" do
        get :edit, basis_id: @base.id, id: @donacion.id
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end

  describe 'PATCH #update' do
    context 'with authorized admin user' do
      before :each do
        @user = create(:admin)
        sign_in @user
        @base = create(:base)
        @donacion = create(:donacion_basis, base_id: @base.id, product_name: 'hola')
      end

      context "valid attributes" do
        it "located the requested @donacion" do
          patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: 'pepe'}
          expect(assigns(:donacion)).to eq(@donacion)
        end

        it "changes @enf's attributes" do
          patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: 'pepe', category: 'comida'}
          @donacion.reload
          expect(@donacion.product_name).to eq("pepe")
          expect(@donacion.category).to eq("comida")
        end

        it "redirects to the enfermera#show" do
          patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: 'pepe', category: 'comida'}
          expect(response).to redirect_to basis_donacion_bases_path(@base.id)
        end
        it "sets the updated message" do
           patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: 'pepe', category: 'comida'}
          flash[:notice].should =~ /Se actualizó correctamente./i
        end
      end

      context "with invalid attributes" do
        it "does not change the enfermeras's attributes" do
          patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: nil, category: 'comida'}
          @donacion.reload
          expect(@donacion.product_name).to eq("hola")
        end

        it "re-renders the edit template" do
          patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: nil, category: 'comida'}
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: nil, category: 'comida'}
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @base = create(:base)
        @donacion = create(:donacion_basis, base_id: @base.id, product_name: 'hola')
      end
      it "show the correct access negated message" do
        patch :update, basis_id: @base.id, id: @donacion.id,
                 donacion_base: {product_name: 'pepe', category: 'comida'}
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end

  describe 'DELETE destroy' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @base = create(:base)
        @donacion = create(:donacion_basis, base_id: @base.id, product_name: 'hola')
      end      
      it "deletes the RA" do
        expect{
          delete :destroy, basis_id: @base.id, id: @donacion.id
        }.to change(DonacionBase,:count).by(-1)
      end
      
      it "redirects to index" do
        delete :destroy, basis_id: @base.id, id: @donacion.id
        expect(response).to redirect_to basis_donacion_bases_path(@base.id)
      end
    end
    context 'with not-authorized user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
        @donacion = create(:donacion_basis, base_id: @base.id, product_name: 'hola')
      end
      it "show the correct not authorized message" do
        delete :destroy, basis_id: @base.id, id: @donacion.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end
end
