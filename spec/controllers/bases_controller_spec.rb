require 'spec_helper'

describe BasesController do
  describe 'GET #index' do
    before (:each) do
      @user = create(:user)
      sign_in  @user
    end
    context 'without adittional parameters' do
      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
  describe 'GET #new' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      it "renders the :new view" do
        get :new
        expect(response).to render_template :new
      end
    end
     context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        get :new
        flash[:alert].should =~ /Acceso denegado./
      end
    end         
  end

  describe 'GET #show' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      it "renders the :show view" do
        base = create(:base)
        get :show, id: base.id
        expect(response).to render_template :show
      end 
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "renders the :show view" do
        base = create(:base)
        get :show, id: base.id
        expect(response).to render_template :show
      end 
    end 
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it "renders the :show view" do
        base = create(:base)
        get :show, id: base.id
        expect(response).to render_template :show
      end 
    end 
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        base = create(:base)
        get :show, id: base.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end      
  end

  describe 'GET #miembros' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end    
      it "renders the miembros view" do
        base = create(:base)
        get :miembros, basis_id: base
        expect(response).to render_template :miembros
      end
      it "assigns the requested base to @basis" do
        base = create(:base)
        get :miembros, basis_id: base
        expect(assigns(:basis)).to eq base
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end    
      it "renders the miembros view" do
        base = create(:base)
        get :miembros, basis_id: base
        expect(response).to render_template :miembros
      end
      it "assigns the requested base to @basis" do
        base = create(:base)
        get :miembros, basis_id: base
        expect(assigns(:basis)).to eq base
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end    
      it "renders the miembros view" do
        base = create(:base)
        get :miembros, basis_id: base
        expect(response).to render_template :miembros
      end
      it "assigns the requested base to @basis" do
        base = create(:base)
        get :miembros, basis_id: base
        expect(assigns(:basis)).to eq base
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        base = create(:base)
        get :miembros, basis_id: base
        flash[:alert].should =~ /Acceso denegado./
      end
    end     
  end


  describe "POST #create" do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      describe "with valid attributes" do
        it "saves the new base in the database" do
          expect{
            post :create, base: attributes_for(:base)
          }.to change(Base, :count).by(1)
        end

        it "redirects to bases#show" do
          post :create, base: attributes_for(:base)
          expect(response).to redirect_to Base.last
        end

        it "show the creation flash message" do
          post :create, base: attributes_for(:base)
          flash[:notice].should =~ /Se registró correctamente la base/i
        end

      end

      describe "with invalid attributes" do
        it "does not save the new red_asistencial in the database" do
          expect{
            post :create, base: {codigo_base: nil}
          }.to_not change(Base, :count)
        end
        it "re-renders the :new template" do
          post :create, base: {codigo_base: nil}
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, base: {codigo_base: nil}
          flash[:alert].should =~ /Hubo un problema. No se registró la base./i
        end
        it "does not save with same codigo_base" do
          @base = Base.create(codigo_base: 'cod1')
          expect{
            post :create, base: {codigo_base: 'cod1'}
          }.to_not change(Base, :count)
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        post :create, base: attributes_for(:base)
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'GET #edit' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      it "assigns the requested base to @basis" do
        base= create(:base)
        get :edit, id: base
        expect(assigns(:basis)).to eq base
      end

      it "renders the :edit template" do
        base = create(:base)
        get :edit, id: base
        expect(response).to render_template :edit
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        base = create(:base)
        get :edit, id: base
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'PATCH #update' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base, codigo_base: 'Base1', nombre_base: 'Lawrence')
      end
      describe "valid attributes" do
        it "located the requested @basis" do
          patch :update, id: @base , base: attributes_for(:base)
          expect(assigns(:basis)).to eq(@base)
        end

        it "changes @base's attributes" do
          patch :update, id: @base, base: attributes_for(:base,
                                                    codigo_base: 'Base2',  
                                                    nombre_base: "Marlon")
          @base.reload
          expect(@base.codigo_base).to eq("Base2")
          expect(@base.nombre_base).to eq("Marlon")
        end

        it "redirects to show base" do
          patch :update, id: @base, base: attributes_for(:base)
          expect(response).to redirect_to @base
        end
        it "sets the updated message" do
          patch :update, id: @base, base: attributes_for(:base)
          flash[:notice].should =~ /Se actualizó correctamente la base/i
        end
      end

      describe "with invalid attributes" do
        it "does not change the base's attributes" do
          patch :update, id: @base, base: attributes_for(:base,
                                                    codigo_base: '',  
                                                    nombre_base: "Marlon")
          @base.reload
          expect(@base.nombre_base).to_not eq("Marlon")
        end

        it "re-renders the edit template" do
          patch :update, id: @base, base: attributes_for(:base,
                                                    codigo_base: '',  
                                                    nombre_base: "Marlon")
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          patch :update, id: @base, base: attributes_for(:base,
                                                    codigo_base: '',  
                                                    nombre_base: "Marlon")
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end

        it "does not save with same codigo_base" do
          Base.create(codigo_base: 'cod1')
          patch :update, id: @base, base: attributes_for(:base,
                                                    codigo_base: 'cod1',  
                                                    nombre_base: "Marlon")
          @base.reload
          expect(@base.codigo_base).to_not eq("cod1")          
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @base = create(:base, codigo_base: 'Base1', nombre_base: 'Lawrence')
      end
      it "show the correct access negated message" do
        patch :update, id: @base, base: attributes_for(:base)
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
      end
    
      it "deletes the base" do
        expect{
          delete :destroy, id: @base
        }.to change(Base,:count).by(-1)
      end
      
      it "redirects to base#index" do
        delete :destroy, id: @base
        expect(response).to redirect_to bases_path
      end
      it "show a success message" do
        delete :destroy, id: @base
        flash[:notice].should =~ /Se eliminó correctamente la base./i
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @base = create(:base)
      end
      it "show the correct access negated message" do
        delete :destroy, id: @base
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end


  ###################################
  #authorization for Informatica user
  ###################################

  describe 'GET #import' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      it "renders the :import template" do
        xhr :get, :import
        expect(response).to render_template :import
      end
      it "with no ajax redirects to index path" do
        get :import
        expect(response).to redirect_to bases_path
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        get :import
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end

  describe 'GET #import_juntas' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      it "renders the :import_juntas template" do
        xhr :get, :import_juntas
        expect(response).to render_template :import_juntas
      end
      it "with no ajax redirects to index path" do
        get :import_juntas
        expect(response).to redirect_to bases_path
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        get :import_juntas
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end

  describe 'POST importar' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      describe 'good import' do
        it 'create a new imported file' do
          expect{
              post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bases.csv')))
            }.to change(Import,:count).by(1)
        end
        it "redirects to dashboard" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/bases.csv')))
          expect(response).to redirect_to imports_path
        end
        it "sets the notice message" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/bases.csv')))
          flash[:notice].should =~ /El proceso de importacion durará unos minutos./i
        end
      end
      describe 'bad import' do
        it ' not create a new imported file' do
          expect{
              post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
            }.to change(Import,:count).by(0)
        end
        it "redirects to bases#index" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
          expect(response).to redirect_to bases_path
        end
        it "sets the alert message" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/bad.ods')))
          flash[:alert].should =~ /El archivo es muy grande, o tiene un formato incorrecto./i
        end
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/bases.csv')))
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end

  describe 'POST importar_juntas' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      describe 'good import' do
        it 'create a new imported file' do
          expect{
              post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/juntas.csv')))
            }.to change(Import,:count).by(1)
        end
        it "redirects to dashboard" do
          post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/juntas.csv')))
          expect(response).to redirect_to imports_path
        end
        it "sets the notice message" do
          post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/juntas.csv')))
          flash[:notice].should =~ /El proceso de importacion durará unos minutos./i
        end
      end
      describe 'bad import' do
        it ' not create a new imported file' do
          expect{
              post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
            }.to change(Import,:count).by(0)
        end
        it "redirects to bases#index" do
          post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
          expect(response).to redirect_to bases_path
        end
        it "sets the alert message" do
          post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/bad.ods')))
          flash[:alert].should =~ /El archivo es muy grande, o tiene un formato incorrecto./i
        end
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        post :importar_juntas, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/juntas.csv')))
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end
end

