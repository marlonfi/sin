require 'spec_helper'

describe PagosController do
  describe 'GET #index' do
    before(:each) do
      @user = create(:user)
      sign_in @user
    end
    context 'without adittional parameters' do
      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #retrasos' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      it "renders the retrasos template" do
        get :retrasos
        expect(response).to render_template :retrasos
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it "renders the :retrasos template" do
        get :retrasos
        expect(response).to render_template :retrasos
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "renders the :import template" do
        get :retrasos
        expect(response).to render_template :retrasos
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "sets the correct not authorized alert message" do
        get :retrasos
        flash[:alert].should =~ /Acceso denegado./
      end
    end      
  end

  describe 'GET #listar' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      it "redirects on a not xhr request" do
        get :listar
        expect(response).to redirect_to pagos_path
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it "redirects on a not xhr request" do
        get :listar
        expect(response).to redirect_to pagos_path
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "redirects on a not xhr request" do
        get :listar
        expect(response).to redirect_to pagos_path
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "sets the correct not authorized alert message" do
        get :listar
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end  

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
        expect(response).to redirect_to pagos_path
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
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      describe 'good import' do
        it 'create a new imported file' do
          expect{
              post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                    archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                            '/spec/factories/files/cas-noviembre.TXT')))
            }.to change(Import,:count).by(1)
        end
        it "redirects to imports_path" do
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
               archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                            '/spec/factories/files/cas-noviembre.TXT')))
          expect(response).to redirect_to imports_path
        end
        it "creates with imported file with good attributes" do
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
               archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                            '/spec/factories/files/cas-noviembre.TXT')))
          expect(Import.last.tipo_txt).to eq('CAS')
          expect(Import.last.fecha_pago).to eq(Date.parse('15-02-2014'))
          end
          it "sets the notice message" do
            post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
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
        it "redirects to pagos#index" do
          post :importar, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
          expect(response).to redirect_to pagos_path
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
      it "sets the correct not authorized alert message" do
        post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end
end

