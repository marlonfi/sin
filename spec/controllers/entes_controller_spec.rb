require 'spec_helper'

describe EntesController do

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

  describe "POST #create" do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      describe "with valid attributes" do
        before(:each) do
          @red = RedAsistencial.create(cod_essalud: 'cod1')
        end

        it "saves the new red_asistencial in the database" do
          expect{
            post :create, ente: {red_asistencial_id: @red.id, cod_essalud: 'Hi Huacnayo'}
          }.to change(Ente, :count).by(1)
        end

        it "redirects to redasistencials#show" do
          post :create, ente: {red_asistencial_id: @red.id, cod_essalud: 'Hi Huacnayo'}
          expect(response).to redirect_to Ente.last
        end

        it "show the creation flash message" do
          post :create, ente: {red_asistencial_id: @red.id, cod_essalud: 'Hi Huacnayo'}
          flash[:notice].should =~ /Se registró correctamente el ente/i
        end

      end

      describe "with invalid attributes" do
        it "does not save the new red_asistencial in the database" do
          expect{
            post :create, ente: {red_asistencial_id: nil, cod_essalud: nil}
          }.to_not change(Ente, :count)
        end
        it "re-renders the :new template" do
          post :create, ente: {red_asistencial_id: nil, cod_essalud: nil}
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, ente: {red_asistencial_id: nil, cod_essalud: nil}
          flash[:alert].should =~ /Hubo un problema. No se registró el ente./i
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
      end
      it "show the correct access negated message" do
        post :create, ente: {red_asistencial_id: @red.id, cod_essalud: 'Hi Huacnayo'}
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
      it "assigns the requested ente to @ente" do
        ente = create(:ente)
        get :edit, id: ente
        expect(assigns(:ente)).to eq ente
      end

      it "renders the :edit template" do
        ente = create(:ente)
        get :edit, id: ente
        expect(response).to render_template :edit
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        ente = create(:ente)
        get :edit, id: ente
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'PATCH #update' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @ente = create(:ente, contacto_nombre: 'Lawrence')
      end
      
      describe "valid attributes" do
        it "located the requested @ente" do
          patch :update, id: @ente , ente: attributes_for(:ente)
          expect(assigns(:ente)).to eq(@ente)
        end

        it "changes @ente's attributes" do
          patch :update, id: @ente, ente: attributes_for(:ente,
                                                    cod_essalud: 'HIV Puno',  
                                                    contacto_nombre: "Marlons")
          @ente.reload
          expect(@ente.cod_essalud).to eq("HIV Puno")
          expect(@ente.contacto_nombre).to eq("Marlons")
        end

        it "redirects to the ente#show" do
          patch :update, id: @ente, ente: attributes_for(:ente)
          expect(response).to redirect_to @ente
        end
        it "sets the updated message" do
          patch :update, id: @ente, ente: attributes_for(:ente)
          flash[:notice].should =~ /Se actualizó correctamente el ente/i
        end
      end

      describe "with invalid attributes" do
        it "does not change the red_asistencial's attributes" do
          patch :update, id: @ente, ente: attributes_for(:ente,
                                                    cod_essalud: nil, contacto_nombre: 'Marlon')
          @ente.reload
          expect(@ente.contacto_nombre).to_not eq("Marlon")
        end

        it "re-renders the edit template" do
          patch :update, id: @ente, ente: attributes_for(:invalid_ente)
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          patch :update, id: @ente, ente: attributes_for(:invalid_ente)
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @ente = create(:ente, contacto_nombre: 'Lawrence')
      end
      it "show the correct access negated message" do
        patch :update, id: @ente, ente: attributes_for(:ente)
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @ente = create(:ente)
      end
    
      it "deletes the contact" do
        expect{
          delete :destroy, id: @ente
        }.to change(Ente,:count).by(-1)
      end
      
      it "redirects to contacts#index" do
        delete :destroy, id: @ente
        expect(response).to redirect_to entes_path
      end

      it "show a success message" do
        delete :destroy, id: @ente
        flash[:notice].should =~ /Se eliminó correctamente el ente./i
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @ente = create(:ente)
      end
      it "show the correct access negated message" do
        delete :destroy, id: @ente
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  ###########################################################
  #authorization for Organizacional || Admin || Reader user
  ###########################################################
  describe 'GET #enfermeras' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      describe 'simple request' do
        it "renders the ente_enfermeras view" do
          ente = create(:ente)
          get :enfermeras, ente_id: ente
          expect(response).to render_template :ente_enfermeras
        end
        it "assigns the requested ente to @ente" do
          ente = create(:ente)
          get :enfermeras, ente_id: ente
          expect(assigns(:ente)).to eq ente
        end
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      describe 'simple request' do
        it "renders the ente_enfermeras view" do
          ente = create(:ente)
          get :enfermeras, ente_id: ente
          expect(response).to render_template :ente_enfermeras
        end
        it "assigns the requested ente to @ente" do
          ente = create(:ente)
          get :enfermeras, ente_id: ente
          expect(assigns(:ente)).to eq ente
        end
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      describe 'simple request' do
        it "renders the ente_enfermeras view" do
          ente = create(:ente)
          get :enfermeras, ente_id: ente
          expect(response).to render_template :ente_enfermeras
        end
        it "assigns the requested ente to @ente" do
          ente = create(:ente)
          get :enfermeras, ente_id: ente
          expect(assigns(:ente)).to eq ente
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "show the correct access negated message" do
        ente = create(:ente)
        get :enfermeras, ente_id: ente
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  ###################################
  #authorization for Informatica user
  ###################################
     
  ## methods for importation
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
        expect(response).to redirect_to entes_path
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
                   '/spec/factories/files/lista_essalud.csv')))
            }.to change(Import,:count).by(1)
        end
        it "redirects to dashboard" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/lista_essalud.csv')))
          expect(response).to redirect_to imports_path
        end
        it "sets the notice message" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/lista_essalud.csv')))
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
        it "redirects to dashboard" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
          expect(response).to redirect_to entes_path
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
                          '/spec/factories/files/bad.ods')))
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end  
end
