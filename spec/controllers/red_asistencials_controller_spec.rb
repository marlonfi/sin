require 'spec_helper'

describe RedAsistencialsController do
  before(:each) do
    @user = create(:user)
    sign_in @user 
  end
  describe 'GET #index' do
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

  describe 'GET #new' do
    it "renders the :new view" do
      get :new
      expect(response).to render_template :new
    end    
  end

  describe "POST #create" do
    context "with valid attributes" do
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

    context "with invalid attributes" do
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


  describe 'GET #edit' do
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

  describe 'PATCH #update' do
    before :each do
      @red = create(:red_asistencial, contacto_nombre: 'Lawrence')
    end

    context "valid attributes" do
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

    context "with invalid attributes" do
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


  describe 'DELETE destroy' do
    before :each do
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

  #Especial actions
  describe 'Get #entes' do
    before(:each) do
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
  describe 'GET #import' do
    it "renders the :import template" do
      xhr :get, :import
      expect(response).to render_template :import
    end
    it "with no ajax redirects to index path" do
      get :import
      expect(response).to redirect_to red_asistencials_path
    end

  end

  describe 'POST importar' do
    context 'good import' do
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
    context 'bad import' do
      it ' not create a new imported file' do
        expect{
            post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                 '/spec/factories/files/bad.ods')))
          }.to change(Import,:count).by(0)
      end
      it "redirects to dashboard" do
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
end
