require 'spec_helper'

describe DonacionEnfermerasController do
  describe 'GET #index' do
    describe 'authorized organizacional user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @enfermera = create(:enfermera)
      end
      it "renders the :index view" do
        get :index, enfermera_id: @enfermera.id
        expect(response).to render_template :index
      end
    end
    describe 'authorized admin user' do
      before (:each) do
        @user = create(:admin)
        sign_in  @user
        @enfermera = create(:enfermera)
      end
      it "renders the :index view" do
        get :index, enfermera_id: @enfermera.id
        expect(response).to render_template :index
      end
    end
    describe 'authorized reader user' do
      before (:each) do
        @user = create(:reader)
        sign_in  @user
        @enfermera = create(:enfermera)
      end
      it "renders the :index view" do
        get :index, enfermera_id: @enfermera.id
        expect(response).to render_template :index
      end
    end
    describe 'un-authorized user' do
      before (:each) do
        @user = create(:user)
        sign_in  @user
        @enfermera = create(:enfermera)
      end
      it "show the correct access negated message" do
        get :index, enfermera_id: @enfermera.id
        flash[:alert].should =~ /Acceso denegado./
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
        it "saves the new donacion in the database" do
          expect{
            post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '12.00', fecha_entrega:'12-12-1990'}}.to change(@enfermera.donaciones, :count).by(1)
        end

        it "redirects to enfermera_bitacoras_path" do
          post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '12.00', fecha_entrega:'12-12-1990'}
          expect(response).to redirect_to enfermera_donacion_enfermeras_path(@enfermera.id)
        end

        it "show the creation flash message" do
          post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '12.00', fecha_entrega:'12-12-1990'}
          flash[:notice].should =~ /Se registró correctamente/i
        end

      end

      describe "with invalid attributes" do
        it "does not save the new donacion in the database" do
          expect{
            post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '00.00', fecha_entrega:'12-12-1990'}
          }.to_not change(@enfermera.donaciones, :count)
        end
        it "re-renders the :new template" do
          post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '00.00', fecha_entrega:'12-12-1990'}
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '00.00', fecha_entrega:'12-12-1990'}
          flash[:alert].should =~ /Hubo un problema. No se registró/i
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
        post :create, enfermera_id: @enfermera.id, donacion_enfermera: {motivo: "Enfermedad", 
                          monto: '12.00', fecha_entrega:'12-12-1990'}
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
        @donacion = create(:donacion_enfermera, enfermera_id: @enfermera.id)
      end
      it "assigns the requested donacion to @donacion" do
        get :edit, enfermera_id: @enfermera.id, id: @donacion.id
        expect(assigns(:donacion)).to eq @donacion
      end

      it "renders the :edit template" do
        get :edit, enfermera_id: @enfermera.id, id: @donacion.id
        expect(response).to render_template :edit
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
         @enfermera = create(:enfermera)
        @donacion = create(:donacion_enfermera, enfermera_id: @enfermera.id)
      end
      it "show the correct access negated message" do
        get :edit, enfermera_id: @enfermera.id, id: @donacion.id
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end

  describe 'PATCH #update' do
    context 'with authorized admin user' do
      before :each do
        @user = create(:admin)
        sign_in @user
        @enfermera = create(:enfermera)
        @donacion = create(:donacion_enfermera, enfermera_id: @enfermera.id, monto: '12.00')
      end

      context "valid attributes" do
        it "located the requested @donacion" do
          patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'13.00', fecha_entrega:'12-12-1990'}
          expect(assigns(:donacion)).to eq(@donacion)
        end

        it "changes @enf's attributes" do
          patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'13.00', fecha_entrega:'12-12-1990'}
          @donacion.reload
          expect(@donacion.monto).to eq(13.00)
        end

        it "redirects to the enfermera#donaciones" do
          patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'13.00', fecha_entrega:'12-12-1990'}
          expect(response).to redirect_to enfermera_donacion_enfermeras_path(@enfermera.id)
        end
        it "sets the updated message" do
           patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'13.00', fecha_entrega:'12-12-1990'}
          flash[:notice].should =~ /Se actualizó correctamente./i
        end
      end

      context "with invalid attributes" do
        it "does not change the enfermeras's attributes" do
          patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'-13.00', fecha_entrega:'12-12-1990'}
          @donacion.reload
          expect(@donacion.monto).to eq(12.00)
        end

        it "re-renders the edit template" do
          patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'-13.00', fecha_entrega:'12-12-1990'}
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                 donacion_enfermera: {motivo: 'enfermeradad', monto:'-13.00', fecha_entrega:'12-12-1990'}
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end
      end
    end
    context 'with un-authorized user' do
      before (:each) do
        @user = create(:organizacional)
        sign_in  @user
        @enfermera = create(:enfermera)
        @donacion = create(:donacion_enfermera, enfermera_id: @enfermera.id, monto: '12.00')
      end
      it "show the correct access negated message" do
        patch :update, enfermera_id: @enfermera.id, id: @donacion.id,
                donacion_enfermera: {motivo: 'enfermeradad', monto:'13.00', fecha_entrega:'12-12-1990'}
        flash[:alert].should =~ /Acceso denegado./
      end           
    end 
  end
  describe 'DELETE destroy' do
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
        @enfermera = create(:enfermera)
        @donacion = create(:donacion_enfermera, enfermera_id: @enfermera.id, monto: '12.00')
      end      
      it "deletes the RA" do
        expect{
          delete :destroy, enfermera_id: @enfermera.id, id: @donacion.id
        }.to change(DonacionEnfermera,:count).by(-1)
      end
      
      it "redirects to index" do
        delete :destroy, enfermera_id: @enfermera.id, id: @donacion.id
        expect(response).to redirect_to enfermera_donacion_enfermeras_path(@enfermera.id)
      end
    end
    context 'with not-authorized user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @enfermera = create(:enfermera)
        @donacion = create(:donacion_enfermera, enfermera_id: @enfermera.id, monto: '12.00')
      end
      it "show the correct not authorized message" do
        delete :destroy, enfermera_id: @enfermera.id, id: @donacion.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end
end
