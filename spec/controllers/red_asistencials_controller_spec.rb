require 'spec_helper'

describe RedAsistencialsController do
  
  describe 'GET #index' do
    before(:each) do
      @user = create(:user)
      sign_in @user
    end
    context 'without adittional parameters' do
      it "returns ordered by cod_essalud" do
        red_tumbes = create(:red_asistencial, cod_essalud: 'RA Tumbes')
        red_junin = create(:red_asistencial, cod_essalud: 'RA Junin')
        red_almenara = create(:red_asistencial, cod_essalud: 'RA Almenara')
        get :index
        expect(assigns(:red_asistencials)).to eq([red_almenara,red_junin,red_tumbes])
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  ###################################
  #authorization for Organizacional user
  ###################################
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
    context 'with not authorized user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "show the correct not authorized message" do
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
        it "saves the new red_asistencial in the database" do
          expect{
            post :create, red_asistencial: attributes_for(:red_asistencial)
          }.to change(RedAsistencial, :count).by(1)
        end

        it "redirects to redasistencials#index" do
          post :create, red_asistencial: attributes_for(:red_asistencial)
          expect(response).to redirect_to red_asistencials_path
        end

        it "show the creation flash message" do
          post :create, red_asistencial: attributes_for(:red_asistencial)
          flash[:notice].should =~ /Se registró correctamente la red asistencial/i
        end
      end
      describe "with invalid attributes" do
        it "does not save the new red_asistencial in the database" do
          expect{
            post :create, red_asistencial: attributes_for(:invalid_red_asistencial)
          }.to_not change(RedAsistencial, :count)
        end
        it "re-renders the :new template" do
          post :create, red_asistencial: attributes_for(:invalid_red_asistencial)
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, red_asistencial: attributes_for(:invalid_red_asistencial)
          flash[:alert].should =~ /Hubo un problema. No se registró la red asistencial./i
        end
      end
    end
    context 'with not-authorized user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "show the correct not authorized message" do
        post :create, red_asistencial: attributes_for(:red_asistencial)
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
      it "assigns the requested red_asistencial to @red_asistencial" do
        red = create(:red_asistencial)
        get :edit, id: red
        expect(assigns(:red_asistencial)).to eq red
      end
      it "renders the :edit template" do
        red = create(:red_asistencial)
        get :edit, id: red
        expect(response).to render_template :edit
      end
    end
    context 'with not-authorized user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "show the correct not authorized message" do
        red = create(:red_asistencial)
        get :edit, id: red
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'PATCH #update' do
    context 'with authorized organizacional user' do
     
      before :each do
        @user = create(:organizacional)
        sign_in @user
        @red = create(:red_asistencial, contacto_nombre: 'Lawrence')
      end
      describe "valid attributes" do
        it "located the requested @red_asistencial" do
          patch :update, id: @red , red_asistencial: attributes_for(:red_asistencial)
          expect(assigns(:red_asistencial)).to eq(@red)
        end

        it "changes @red's attributes" do
          patch :update, id: @red, red_asistencial: attributes_for(:red_asistencial,
                                                    cod_essalud: 'RA Puno',  
                                                    contacto_nombre: "Marlon")
          @red.reload
          expect(@red.cod_essalud).to eq("RA Puno")
          expect(@red.contacto_nombre).to eq("Marlon")
        end

        it "redirects to the list of redes_asitenciales contact" do
          patch :update, id: @red, red_asistencial: attributes_for(:red_asistencial)
          expect(response).to redirect_to red_asistencials_path
        end
        it "sets the updated message" do
          patch :update, id: @red, red_asistencial: attributes_for(:red_asistencial)
          flash[:notice].should =~ /Se actualizó correctamente la red asistencial/i
        end
      end
      describe "with invalid attributes" do
        it "does not change the red_asistencial's attributes" do
          patch :update, id: @red, red_asistencial: attributes_for(:red_asistencial,
                                                    cod_essalud: nil, contacto_nombre: 'Marlon')
          @red.reload
          expect(@red.contacto_nombre).to_not eq("Marlon")
        end

        it "re-renders the edit template" do
          patch :update, id: @red, red_asistencial: attributes_for(:invalid_red_asistencial)
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          patch :update, id: @red, red_asistencial: attributes_for(:invalid_red_asistencial)
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end
      end
    end

    context 'with not-authorized user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
        @red = create(:red_asistencial, contacto_nombre: 'Lawrence')
      end
      it "show the correct not authorized message" do
        patch :update, id: @red , red_asistencial: attributes_for(:red_asistencial)
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @red = create(:red_asistencial)
      end      
      it "deletes the RA" do
        expect{
          delete :destroy, id: @red
        }.to change(RedAsistencial,:count).by(-1)
      end
      
      it "redirects to ra#index" do
        delete :destroy, id: @red
        expect(response).to redirect_to red_asistencials_path
      end
    end
    context 'with not-authorized user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
        @red = create(:red_asistencial, contacto_nombre: 'Lawrence')
      end
      it "show the correct not authorized message" do
        delete :destroy, id: @red
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  #########################################################
  #auhtorization for Admin || Organizacional || Reader user
  #########################################################
  describe 'Get #entes' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @red = create(:red_asistencial)
        @ente1 = @red.entes.create(cod_essalud: 'CM Pauca')
        @ente2 = @red.entes.create(cod_essalud: 'CM PIO')
      end 
      it "returns ordered by cod_essalud" do
        get :entes, red_asistencial_id: @red
        expect(assigns(:entes)).to eq([@ente1,@ente2])
      end

      it "renders the :entes view" do
        get :entes, red_asistencial_id: @red
        expect(response).to render_template 'ra_entes'
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @red = create(:red_asistencial)
        @ente1 = @red.entes.create(cod_essalud: 'CM Pauca')
        @ente2 = @red.entes.create(cod_essalud: 'CM PIO')
      end 
      it "returns ordered by cod_essalud" do
        get :entes, red_asistencial_id: @red
        expect(assigns(:entes)).to eq([@ente1,@ente2])
      end

      it "renders the :entes view" do
        get :entes, red_asistencial_id: @red
        expect(response).to render_template 'ra_entes'
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
        @red = create(:red_asistencial)
        @ente1 = @red.entes.create(cod_essalud: 'CM Pauca')
        @ente2 = @red.entes.create(cod_essalud: 'CM PIO')
      end 
      it "returns ordered by cod_essalud" do
        get :entes, red_asistencial_id: @red
        expect(assigns(:entes)).to eq([@ente1,@ente2])
      end

      it "renders the :entes view" do
        get :entes, red_asistencial_id: @red
        expect(response).to render_template 'ra_entes'
      end
    end
    context 'with not-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @red = create(:red_asistencial)
      end 
      it "returns ordered by cod_essalud" do
        get :entes, red_asistencial_id: @red
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end
  
  ###################################
  #auhtorization for Informatica user
  ###################################
  describe 'GET #import' do
    context 'with authorized informatica user' do
      before (:each) do
        @user = create(:informatica)
        sign_in  @user
      end
      it "renders the :import template" do
        xhr :get, :import
        expect(response).to render_template :import
      end
      it "with no ajax redirects to index path" do
        get :import
        expect(response).to redirect_to red_asistencials_path
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "sets the correct not authorized alert message" do
        xhr :get, :import
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end


  describe 'POST importar' do
    context 'with authorized informatica user' do
      before (:each) do
        @user = create(:informatica)
        sign_in  @user
      end  
      describe 'good import with authorized user' do
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
        it "redirects to red_aistencial" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
          expect(response).to redirect_to red_asistencials_path
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
                        '/spec/factories/files/lista_essalud.csv')))
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end
end