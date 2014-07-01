require 'spec_helper'

describe EnfermerasController do
  
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
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
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
          it "does update the other params" do
            post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true, b_fedcut:true, b_famesalud:false, dni: '46399081',
                                      sexo: 'MASCULINO', factor_sanguineo: 'O+', fecha_nacimiento: '02/02/1990',
                                      fecha_ingreso_essalud: '02/02/1990', fecha_inscripcion_sinesss: '02/02/1990',
                                      domicilio_completo: 'Jr atalaya', telefono: '222268',
                                      especialidad: 'NEO', maestria:'SI', doctorado: 'NO'}
     
            assigns(:enfermera).sexo.should eq('MASCULINO')
            assigns(:enfermera).factor_sanguineo.should eq('O+')
            assigns(:enfermera).domicilio_completo.should eq('Jr atalaya')
            assigns(:enfermera).dni.should eq('46399081')
            assigns(:enfermera).telefono.should eq('222268')
            assigns(:enfermera).especialidad.should eq('NEO')
            assigns(:enfermera).maestria.should eq('SI')
            assigns(:enfermera).doctorado.should eq('NO')
          end
        end
      end

      describe "with invalid attributes" do
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
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
      end
      it "show the correct access negated message" do
        post :create, enfermera: {ente_id: @ente.id, nombres: 'Iokero', cod_planilla:'1234456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true}
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
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        enfermera = create(:enfermera)
        get :edit, id: enfermera
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end


  describe 'PATCH #update' do
    context 'with authorized organizacional user' do
      before :each do
        @user = create(:organizacional)
        sign_in @user
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
            													b_sinesss:false, especialidad: 'NEO', doctorado: 'SI'}
          @enfermera.reload
          expect(@enfermera.cod_planilla).to eq("1234567")
          expect(@enfermera.regimen).to eq("NOMBRADO")
          expect(@enfermera.especialidad).to eq("NEO")
          expect(@enfermera.doctorado).to eq("SI")
          expect(@enfermera.maestria).to eq(nil)
          expect(@enfermera.b_sinesss).to be_true
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
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "show the correct access negated message" do
        patch :update, id: @enfermera , enfermera: attributes_for(:enfermera)
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end

  describe 'POST #afiliacion_desafiliacion' do
    context 'with authorized organizacional user' do
      before :each do
        @user = create(:organizacional)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end

      context "valid attributes" do
        it "changes afiliacion to sindicato" do
          post :afiliacion_desafiliacion, enfermera_id: @enfermera.id, descripcion: 'desafiliando ando'
          @enfermera.reload
          expect(@enfermera.b_sinesss).to_not be_true
          post :afiliacion_desafiliacion, enfermera_id: @enfermera.id, descripcion: 'desafiliando ando'
          @enfermera.reload
          expect(@enfermera.b_sinesss).to be_true
        end
        it 'creates a bitacora for afiliacion' do
          post :afiliacion_desafiliacion, enfermera_id: @enfermera.id, descripcion: 'desafiliando ando'
          expect(@enfermera.bitacoras.count).to eq(1)
          bitacora_afiliacion = @enfermera.bitacoras.last
          expect(bitacora_afiliacion.status).to eq('SOLUCIONADO')
          expect(bitacora_afiliacion.tipo).to eq('DESAFILIACION')
          expect(bitacora_afiliacion.descripcion).to eq('desafiliando ando')
        end
        it 'creates a bitacora for desafiliacion' do
          @enfermera.update_attributes(b_sinesss: false)
          @enfermera.reload
          post :afiliacion_desafiliacion, enfermera_id: @enfermera.id, descripcion: 'afiliando ando'
          expect(@enfermera.bitacoras.count).to eq(1)
          bitacora_afiliacion = @enfermera.bitacoras.last
          expect(bitacora_afiliacion.status).to eq('SOLUCIONADO')
          expect(bitacora_afiliacion.tipo).to eq('AFILIACION')
          expect(bitacora_afiliacion.descripcion).to eq('afiliando ando')
        end       
      end     
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "show the correct access negated message" do
        post :afiliacion_desafiliacion, enfermera_id: @enfermera.id, descripcion: 'desafiliando ando'
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end

  #########################################################
  #authorization for Organizacional || Reader || Admin user
  #########################################################
  describe 'GET #aportaciones' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "renders the :new view" do
        get :aportaciones, enfermera_id: @enfermera.id
        expect(response).to render_template :aportaciones
      end       
      it "returns ordered by fecha_pago desc" do
        pago1 = create(:pago, mes_cotizacion:  '15-06-2014', enfermera_id: @enfermera.id)
        pago2 = create(:pago, mes_cotizacion:  '15-07-2014', enfermera_id: @enfermera.id)
        get :aportaciones, enfermera_id: @enfermera.id
        expect(assigns(:aportaciones)).to eq([pago2,pago1])
      end  
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "renders the :new view" do
        get :aportaciones, enfermera_id: @enfermera.id
        expect(response).to render_template :aportaciones
      end       
      it "returns ordered by fecha_pago desc" do
        pago1 = create(:pago, mes_cotizacion:  '15-06-2014', enfermera_id: @enfermera.id)
        pago2 = create(:pago, mes_cotizacion:  '15-07-2014', enfermera_id: @enfermera.id)
        get :aportaciones, enfermera_id: @enfermera.id
        expect(assigns(:aportaciones)).to eq([pago2,pago1])
      end  
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "renders the :new view" do
        get :aportaciones, enfermera_id: @enfermera.id
        expect(response).to render_template :aportaciones
      end       
      it "returns ordered by fecha_pago desc" do
        pago1 = create(:pago, mes_cotizacion:  '15-06-2014', enfermera_id: @enfermera.id)
        pago2 = create(:pago, mes_cotizacion:  '15-07-2014', enfermera_id: @enfermera.id)
        get :aportaciones, enfermera_id: @enfermera.id
        expect(assigns(:aportaciones)).to eq([pago2,pago1])
      end  
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "show the correct access negated message" do
        get :aportaciones, enfermera_id: @enfermera.id
        flash[:alert].should =~ /Acceso denegado./
      end        
    end 
  end

  describe 'GET #bitacoras' do
     context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "renders the :new view" do
        get :bitacoras, enfermera_id: @enfermera.id
        expect(response).to render_template :bitacoras
      end
      it "returns ordered by created_at desc" do
        bit1 = create(:bitacora, enfermera_id: @enfermera.id)
        bit2 = create(:bitacora, enfermera_id: @enfermera.id)
        get :bitacoras, enfermera_id: @enfermera.id
        expect(assigns(:bitacoras)).to eq([bit2,bit1])
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "renders the :new view" do
        get :bitacoras, enfermera_id: @enfermera.id
        expect(response).to render_template :bitacoras
      end
      it "returns ordered by created_at desc" do
        bit1 = create(:bitacora, enfermera_id: @enfermera.id)
        bit2 = create(:bitacora, enfermera_id: @enfermera.id)
        get :bitacoras, enfermera_id: @enfermera.id
        expect(assigns(:bitacoras)).to eq([bit2,bit1])
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "renders the :new view" do
        get :bitacoras, enfermera_id: @enfermera.id
        expect(response).to render_template :bitacoras
      end
      it "returns ordered by created_at desc" do
        bit1 = create(:bitacora, enfermera_id: @enfermera.id)
        bit2 = create(:bitacora, enfermera_id: @enfermera.id)
        get :bitacoras, enfermera_id: @enfermera.id
        expect(assigns(:bitacoras)).to eq([bit2,bit1])
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @red = RedAsistencial.create(cod_essalud: 'cod1')
        @ente = @red.entes.create(cod_essalud: 'huancayo')
        @enfermera = @ente.enfermeras.create(nombres: 'Iokero', cod_planilla:'1231456',
                                      apellido_paterno: 'dsd', apellido_materno: 'sdsd', regimen:"CAS",
                                      b_sinesss:true)
      end
      it "show the correct access negated message" do
        get :bitacoras, enfermera_id: @enfermera.id
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end


  ###################################
  #authorization for Informatica user
  ###################################
  ## methods for importation
	describe 'GET #import_essalud' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      it "renders the :import template" do
        xhr :get, :import_essalud
        expect(response).to render_template :import_essalud
      end
      it "with no ajax redirects to index path" do
        get :import_essalud
        expect(response).to redirect_to enfermeras_path
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        get :import_essalud
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
      describe 'bad import' do
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
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        post :importar_essalud, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/lista_essalud.csv')))
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end

  ## methods for importation
  describe 'GET #import_data_actualizada' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      it "renders the :import_data_actualizada" do
        xhr :get, :import_data_actualizada
        expect(response).to render_template :import_data_actualizada
      end
      it "with no ajax redirects to index path" do
        get :import_data_actualizada
        expect(response).to redirect_to enfermeras_path
      end
    end
    context 'with un-authorized informatica user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
      end
      it "show the correct access negated message" do
        get :import_data_actualizada
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end

  describe 'POST importar_data_actualizada' do
    context 'with authorized informatica user' do
      before(:each) do
        @user = create(:informatica)
        sign_in @user
      end
      context 'good import_data_actualizada' do
        it 'create a new imported file' do
          expect{
              post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/actualizacion_datos_enfermera.csv')))
            }.to change(Import,:count).by(1)
        end
        it "redirects to dashboard" do
          post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/actualizacion_datos_enfermera.csv')))
          expect(response).to redirect_to imports_path
        end
        it "sets the notice message" do
          post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/actualizacion_datos_enfermera.csv')))
          flash[:notice].should =~ /El proceso de importacion durará unos minutos./i
        end
      end
      context 'bad import' do
        it ' not create a new imported file' do
          expect{
              post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
            }.to change(Import,:count).by(0)
        end
        it "redirects to dashboard" do
          post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                   '/spec/factories/files/bad.ods')))
          expect(response).to redirect_to enfermeras_path
        end
        it "sets the alert message" do
          post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
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
        post :importar_data_actualizada, archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                          '/spec/factories/files/actualizacion_datos_enfermera.csv')))
        flash[:alert].should =~ /Acceso denegado./
      end           
    end
  end
end

