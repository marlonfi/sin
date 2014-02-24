require 'spec_helper'

describe PagosController do
  describe 'GET #index' do
    context 'without adittional parameters' do
      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end  

  describe 'GET #import' do
    it "renders the :import template" do
      xhr :get, :import
      expect(response).to render_template :import
    end
    it "with no ajax redirects to index path" do
      get :import
      expect(response).to redirect_to pagos_path
    end
  end

  describe 'POST importar' do
    context 'good import' do
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
    context 'bad import' do
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
end

