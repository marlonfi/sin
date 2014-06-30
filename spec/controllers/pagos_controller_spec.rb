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

  describe 'GET #new' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @enfermera = create(:enfermera)
      end
      it "renders the :new view" do
        get :new, enfermera_id: @enfermera.id
        expect(response).to render_template :new
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @enfermera = create(:enfermera)
      end
      it "show the correct access negated message" do
        get :new, enfermera_id: @enfermera.id
        flash[:alert].should =~ /Acceso denegado./
      end           
    end        
  end

  describe "POST #create" do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @enfermera = create(:enfermera)
      end
      describe "with valid attributes" do
        it "saves the new pago in the database" do
          expect{
            post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola" 
            }.to change(@enfermera.pagos, :count).by(1)
        end

        it "redirects to enfermera_aportaciones_path" do
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola" 
          expect(response).to redirect_to enfermera_aportaciones_path(@enfermera.id)
        end

        it "show the creation flash message" do
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola" 
          flash[:notice].should =~ /Se registró correctamente el pago/i
        end
        it 'adds the correct attributes to the payment' do
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola"
          pago = @enfermera.pagos.last
          expect(pago.monto).to eq(232.32)
          expect(pago.mes_cotizacion).to eq(Date.parse('15-4-2014'))
          expect(pago.generado_por).to eq(@user.apellidos_nombres)
          expect(pago.archivo).to eq('VOUCHER')
          expect(pago.voucher).to eq('232323')
          expect(pago.base).to eq('B-D HIII Heredia')
          expect(pago.ente_libre).to eq(@enfermera.ente.cod_essalud)       
        end
        it 'adds the correct attributes to the payment' do
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>""},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola"
          pago = @enfermera.pagos.last          
          expect(pago.base).to eq('Pago libre')  
        end
        it 'deletes an existing pago faltante with the same mes_cotizacion' do
          @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'15-04-2014',
                          archivo:'VOUCHER', generado_por: 'Falta de pago', base:'basek', ente_libre:'libre')
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola"
          @enfermera.reload
          expect(@enfermera.pagos.count).to eq(1)      
        end
      end

      describe "with invalid attributes" do
        it "does not save the new pago in the database" do
          expect{
            post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"", "voucher"=>"232323", "comentario"=>"hola hola" 
            }.to_not change(@enfermera.pagos, :count)
        end
        it "re-renders the :new template" do
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"", "voucher"=>"232323", "comentario"=>"hola hola" 
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"", "voucher"=>"232323", "comentario"=>"hola hola" 
          flash[:alert].should =~ /Hubo un problema. No se registró. Revisar/i
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @enfermera = create(:enfermera)
      end
      it "show the correct access negated message" do
        post :create, enfermera_id: @enfermera.id,
                "date"=>{"year"=>"2014", "month"=>"4"},
                "base"=>{"codigo_base"=>"B-D HIII Heredia"},
                "monto"=>"232.32", "voucher"=>"232323", "comentario"=>"hola hola"
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'GET #edit' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @enfermera = create(:enfermera)
        allowed_date = DateTime.now.to_date - 13.days
        @pago = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'VOUCHER', generado_por: 'yo', base:'basek', ente_libre:'libre',
                          created_at: allowed_date)
        @pago_fuera = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'VOUCHER', generado_por: 'yo', base:'basek', ente_libre:'libre',
                          created_at:'12-12-1990')
        @empty_pago = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'VOUCHER', generado_por: 'Falta de pago', base:'basek', ente_libre:'libre',
                          created_at:'12-12-1990')
      end
      it "renders the :edit view con pago on time" do
        get :edit, enfermera_id: @enfermera.id, id: @pago.id
        expect(response).to render_template :edit
      end
      it 'does not render the template for empy payments' do
        get :edit, enfermera_id: @enfermera.id, id: @empty_pago.id
        expect(response).to redirect_to enfermera_aportaciones_path(@enfermera)
        flash[:alert].should =~ /Para reemplazar la falta de pago, registre el pago con el mismo mes de aportacion./
      end
      it 'does not render the template in a created_at out of range' do
        get :edit, enfermera_id: @enfermera.id, id: @pago_fuera.id
        expect(response).to redirect_to enfermera_aportaciones_path(@enfermera)
        flash[:alert].should =~ /UD. ya no puede editar este pago, fuera de fecha./
      end
    end

    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @enfermera = create(:enfermera)
        @pago = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'VOUCHER', generado_por: 'yo', base:'basek', ente_libre:'libre')
      end
      it "show the correct access negated message" do
        get :edit, enfermera_id: @enfermera.id, id: @pago.id
        flash[:alert].should =~ /Acceso denegado./
      end           
    end        
  end

  describe 'PATCH #update' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        allowed_date = DateTime.now.to_date - 13.days
        sign_in @user
        @enfermera = create(:enfermera)
        @pago = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'VOUCHER', generado_por: 'yo', base:'basek', ente_libre:'libre',
                          created_at: allowed_date)
        @pago_importado = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'Importdo', generado_por: 'yo', base:'basek', ente_libre:'libre',
                          created_at:allowed_date)
        @pago_faltante = @enfermera.pagos.create(monto:'12.12', mes_cotizacion:'12-12-1990',
                          archivo:'VOUCHER', generado_por: 'Falta de pago', base:'basek', ente_libre:'libre',
                          created_at:allowed_date)
      end
      it 'allows to edit all of payments created by voucher' do
        patch :update, enfermera_id: @enfermera.id, id: @pago.id, base: {codigo_base: 'hhh'},
              monto: '12.13', date: {month: '12', year: '2000'}, voucher: '0909', comentario:'hola'
        @pago.reload
        expect(@pago.base).to eq('hhh')
        expect(@pago.monto).to eq(12.13)
        expect(@pago.comentario).to eq('hola')
        expect(@pago.mes_cotizacion).to eq(Date.parse('15-12-2000'))
      end
      it 'allows to edit only base && comentario for payments generated by importation' do
        patch :update, enfermera_id: @enfermera.id, id: @pago_importado.id, base: {codigo_base: 'hhh'},
              monto: '23.13', date: {month: '12', year: '2000'}, voucher: '0909', comentario:'hola'
        @pago_importado.reload
        expect(@pago_importado.base).to eq('hhh')
        expect(@pago_importado.monto.to_f).to eq(12.12)
        expect(@pago_importado.comentario).to eq('hola')
        expect(@pago_importado.mes_cotizacion).to eq(Date.parse('12-12-1990'))      
      end
      it 'does not allow to update payment out of date && empty payments' do
        patch :update, enfermera_id: @enfermera.id, id: @pago_faltante.id, base: {codigo_base: 'hhh'},
              monto: '23.13', date: {month: '12', year: '2000'}, voucher: '0909', comentario:'hola'
        expect(response).to redirect_to enfermera_aportaciones_path(@enfermera)
        flash[:alert].should =~ /Prohibido./
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
      describe 'Import the file on the same date and tipo' do
        it ' not create a new imported file' do
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
          expect{
               post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
            }.to change(Import,:count).by(0)
        end
        it 'redirects to the pagos path' do
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
          expect(response).to redirect_to pagos_path
        end
        it 'shows the correct flash message' do
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
          post :importar, date:{ year: '2014', month: '2'}, tipo: 'CAS',
                  archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/cas-noviembre.TXT')))
          flash[:alert].should =~ /Ya se importó ese archivo, revisar el log de importaciones./i
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

