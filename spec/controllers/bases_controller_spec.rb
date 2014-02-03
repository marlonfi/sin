require 'spec_helper'

describe BasesController do
  describe 'GET #index' do
    context 'without adittional parameters' do
      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
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

    context "with invalid attributes" do
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

  describe 'GET #edit' do
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

  describe 'PATCH #update' do
    before :each do
      @base = create(:base, codigo_base: 'Base1', nombre_base: 'Lawrence')
    end

    context "valid attributes" do
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

    context "with invalid attributes" do
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

  describe 'DELETE destroy' do
    before :each do
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

  describe 'GET #import' do
    it "renders the :import template" do
      xhr :get, :import
      expect(response).to render_template :import
    end
  end

  describe 'POST importar' do
    context 'good import' do
      it 'create a new imported file' do
        expect{
            post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                 '/spec/factories/files/bases2.csv')))
          }.to change(Import,:count).by(1)
      end
      it "redirects to dashboard" do
        post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        '/spec/factories/files/bases2.csv')))
        expect(response).to redirect_to dashboard_path
      end
      it "sets the notice message" do
        post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        '/spec/factories/files/bases2.csv')))
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

end

