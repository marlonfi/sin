require 'spec_helper'

describe BitacorasController do
	describe 'GET #index' do
		describe 'authorized organizacional user' do
	    before (:each) do
	      @user = create(:organizacional)
	      sign_in  @user
	    end
	    context 'without adittional parameters' do
	      it "renders the :index view" do
	        get :index
	        expect(response).to render_template :index
	      end
	    end
	  end
	  describe 'authorized admin user' do
	    before (:each) do
	      @user = create(:admin)
	      sign_in  @user
	    end
	    context 'without adittional parameters' do
	      it "renders the :index view" do
	        get :index
	        expect(response).to render_template :index
	      end
	    end
	  end
	  describe 'authorized reader user' do
	    before (:each) do
	      @user = create(:reader)
	      sign_in  @user
	    end
	    context 'without adittional parameters' do
	      it "renders the :index view" do
	        get :index
	        expect(response).to render_template :index
	      end
	    end
	  end
	  describe 'un-authorized user' do
	    before (:each) do
	      @user = create(:user)
	      sign_in  @user
	    end
	    context 'without adittional parameters' do
	      it "show the correct access negated message" do
        	get :index
        	flash[:alert].should =~ /Acceso denegado./
      	end
	    end
	  end
  end

 
  describe "POST #create" do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @enfermera = create(:enfermera)
      end
      describe "with valid attributes" do
        it "saves the new bitacora in the database" do
          expect{
            post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: 'PENDIENTE'}}.to change(@enfermera.bitacoras, :count).by(1)
        end

        it "redirects to enfermera_bitacoras_path" do
          post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: 'PENDIENTE'}
          expect(response).to redirect_to enfermera_bitacoras_path(@enfermera.id)
        end

        it "show the creation flash message" do
          post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: 'PENDIENTE'}
          flash[:notice].should =~ /Se registró correctamente/i
        end

      end

      describe "with invalid attributes" do
        it "does not save the new bitacora in the database" do
          expect{
            post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: nil}
          }.to_not change(@enfermera.bitacoras, :count)
        end
        it "re-renders the :new template" do
          post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: nil}
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: nil}
          flash[:alert].should =~ /Hubo un problema. No se registró/i
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @enfermera = create(:enfermera)
      end
      it "show the correct access negated message" do
        post :create, enfermera_id: @enfermera.id, bitacora: {tipo: "AFILIACION", 
            							status: 'PENDIENTE'}
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe "POST #change_status" do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @enfermera = create(:enfermera)
        @bitacora = create(:bitacora, enfermera_id: @enfermera.id, status: 'PENDIENTE')
      end
      describe "with valid attributes" do
        it "changes the status of the bitacora" do
          post :change_status, enfermera_id: @enfermera.id, bitacora_id: @bitacora.id
          @bitacora.reload
          expect(@bitacora.status).to	eq('SOLUCIONADO')
      	end
      	it "changes the status of the bitacora" do
      		@bitacora = create(:bitacora, enfermera_id: @enfermera.id, status: 'SOLUCIONADO')
          post :change_status, enfermera_id: @enfermera.id, bitacora_id: @bitacora.id
          @bitacora.reload
          expect(@bitacora.status).to	eq('PENDIENTE')
      	end
      	it "redirects to enfermera_bitacoras_path" do
          post :change_status, enfermera_id: @enfermera.id, bitacora_id: @bitacora.id
          expect(response).to redirect_to enfermera_bitacoras_path(@enfermera.id)
        end

        it "show the creation flash message" do
          post :change_status, enfermera_id: @enfermera.id, bitacora_id: @bitacora.id
          flash[:notice].should =~ /Se cambió el status/i
        end
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @enfermera = create(:enfermera)
        @bitacora = create(:bitacora, enfermera_id: @enfermera.id, status: 'PENDIENTE')
      end
      it "show the correct access negated message" do
        post :change_status, enfermera_id: @enfermera.id, bitacora_id: @bitacora.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end
end
