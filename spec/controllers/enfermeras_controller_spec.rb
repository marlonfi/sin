require 'spec_helper'

describe EnfermerasController do
  describe 'GET #index' do
    context 'without adittional parameters' do
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
      before(:each) do
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true)
      end

      it "saves the new enfermera in the database" do
        expect{
          post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        }.to change(Enfermera, :count).by(1)
      end

      it "redirects to enfermera#show" do
        post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        expect(response).to redirect_to Enfermera.last
      end

      it "show the creation flash message" do
        post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        flash[:notice].should =~ /Se registró correctamente la enfermera/i
      end

      context "with allowed params" do   
        it "does update the forbidden params" do
          post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234456',
                                    apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                    b_sinesss:true, b_fedcut:true, b_famesalud:false, dni: '46399081',
                                    sexo: 'MASCULINO', factor_sanguineo: 'O+', fecha_nacimiento: '02/02/1990',
                                    fecha_ingreso_essalud: '02/02/1990', fecha_inscripcion_sinesss: '02/02/1990',
                                    domicilio_completo: 'Jr atalaya', telefono: '222268' }
   
          assigns(:enfermera).sexo.should eq('MASCULINO')
          assigns(:enfermera).factor_sanguineo.should eq('O+')
          assigns(:enfermera).domicilio_completo.should eq('Jr atalaya')
          assigns(:enfermera).dni.should eq('46399081')
          assigns(:enfermera).telefono.should eq('222268')
        end
      end
    end

    context "with invalid attributes" do
      it "does not save the new enfermera in the database" do
        expect{
          post :create, enfermera: {nombres: 'Iokero', cod_planilla:'123156',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        }.to_not change(Enfermera, :count)
      end
      it "does not save with same cod_planilla" do
      	@red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true)
        expect{
          post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1231456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        }.to_not change(Enfermera, :count)
      end
      it "re-renders the :new template" do
        post :create, enfermera: {ente_id: 1, nombres: 'Iokero', cod_planilla:'123145',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        expect(response).to render_template :new
      end
      it "show the fail flash message" do
        post :create, enfermera: {ente_id: 1, nombres: 'Iokero', cod_planilla:'123456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true}
        flash[:alert].should =~ /Hubo un problema. No se registró la enfermera/i
      end
    end
  end


  describe 'GET #edit' do
    it "assigns the requested enfermera to @enfermera" do
      enfermera = create(:enfermera)
      get :edit, id: enfermera
      expect(assigns(:enfermera)).to eq enfermera
    end

    it "renders the :edit template" do
      enfermera = create(:enfermera)
      get :edit, id: enfermera
      expect(response).to render_template :edit
    end
  end


  describe 'PATCH #update' do
    before :each do
      @red = RedAsistencial.create(cod_essalud: 'cod1')
      @ente = @red.entes.create(cod_essalud: 'huancayo')
      @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
          													b_sinesss:true)
    end

    context "valid attributes" do
      it "located the requested @enfermera" do
        patch :update, id: @enfermera , enfermera: attributes_for(:enfermera)
        expect(assigns(:enfermera)).to eq(@enfermera)
      end

      it "changes @enf's attributes" do
        patch :update, id: @enfermera, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234567',
          													apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"NOMBRADO",
          													b_sinesss:true}
        @enfermera.reload
        expect(@enfermera.cod_planilla).to eq("1234567")
        expect(@enfermera.regimen).to eq("NOMBRADO")
      end

      it "redirects to the enfermera#show" do
        patch :update, id: @enfermera, enfermera: attributes_for(:enfermera)
        expect(response).to redirect_to @enfermera
      end
      it "sets the updated message" do
        patch :update, id: @enfermera, enfermera: attributes_for(:enfermera)
        flash[:notice].should =~ /Se actualizó correctamente la enfermera/i
      end
    end

    context "with invalid attributes" do
      it "does not change the enfermeras's attributes" do
        patch :update, id: @enfermera, enfermera: {ente_id: @ente.id, nombres: 'IokeroMal', cod_planilla:'123567',
          													apellido_paterno: '', apellido_materno: '', regimen:"NOMBRADO",
          													b_sinesss:true}
        @enfermera.reload
        expect(@enfermera.nombres).to_not eq("IokeroMal")
      end

      it "re-renders the edit template" do
        patch :update, id: @enfermera, enfermera: attributes_for(:invalid_enfermera)
        expect(response).to render_template :edit
      end

      it "sets the error message" do
        patch :update, id: @enfermera, enfermera: attributes_for(:invalid_enfermera)
        flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
      end
    end
  end


  ## methods for importation
	describe 'GET #import_essalud' do
    it "renders the :import template" do
      xhr :get, :import_essalud
      expect(response).to render_template :import_essalud
    end
    it "with no ajax redirects to index path" do
      get :import_essalud
      expect(response).to redirect_to enfermeras_path
    end
  end

  describe 'POST importar' do
    context 'good import' do
      it 'create a new imported file' do
        expect{
            post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                 '/spec/factories/files/lista_essalud.csv')))
          }.to change(Import,:count).by(1)
      end
      it "redirects to dashboard" do
        post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        '/spec/factories/files/lista_essalud.csv')))
        expect(response).to redirect_to imports_path
      end
      it "sets the notice message" do
        post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        '/spec/factories/files/lista_essalud.csv')))
        flash[:notice].should =~ /El proceso de importacion durará unos minutos./i
      end
    end
    context 'bad import' do
      it ' not create a new imported file' do
        expect{
            post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                 '/spec/factories/files/bad.ods')))
          }.to change(Import,:count).by(0)
      end
      it "redirects to dashboard" do
        post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                 '/spec/factories/files/bad.ods')))
        expect(response).to redirect_to enfermeras_path
      end
      it "sets the alert message" do
        post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        '/spec/factories/files/bad.ods')))
        flash[:alert].should =~ /El archivo es muy grande, o tiene un formato incorrecto./i
      end
    end
  end

  
end

