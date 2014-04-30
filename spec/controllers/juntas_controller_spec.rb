require 'spec_helper'

describe JuntasController do
  describe 'GET #new' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
      end
      it "renders the :new view" do
        get :new, basis_id: @base.id
        expect(response).to render_template :new
      end
    end
     context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @base = create(:base)
      end
      it "show the correct access negated message" do
        get :new, basis_id: @base.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end         
  end

  describe "POST #create" do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
      end
      describe "with valid attributes" do
        it "saves the new junta directiva for the base in the database" do
          expect{
            post :create,basis_id: @base.id, junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          }.to change(@base.juntas, :count).by(1)
        end

        it "redirects to bases#show" do
          post :create,basis_id: @base.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          expect(response).to redirect_to basis_path(@base.id)
        end

        it "show the creation flash message" do
          post :create,basis_id: @base.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          flash[:notice].should =~ /Se registró correctamente la Junta Directiva/i
        end

      end

      describe "with invalid attributes" do
        it "does not save the new junta in the database" do
          expect{
            post :create, basis_id: @base.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          }.to_not change(@base.juntas, :count)
        end
        it "re-renders the :new template" do
          post :create, basis_id: @base.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          post :create, basis_id: @base.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          flash[:alert].should =~ /No se pudo regitrar la nueva Junta./i
        end       
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @base = create(:base)
      end
      it "show the correct access negated message" do
        post :create, basis_id: @base.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'GET #edit' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
        @junta = create(:juntum, base_id: @base.id)
      end
      it "assigns the requested base to @basis" do
        get :edit, basis_id: @base.id, junta_id: @junta.id
        expect(assigns(:basis)).to eq @base
        expect(assigns(:junta)).to eq @junta
      end

      it "renders the :edit template" do
        get :edit, basis_id: @base.id, junta_id: @junta.id
        expect(response).to render_template :edit
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @base = create(:base)
        @junta = create(:juntum, base_id: @base.id)
      end
      it "show the correct access negated message" do
        get :edit, basis_id: @base.id, junta_id: @junta.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'PATCH #update' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user        
        @base = create(:base)
        @junta = create(:juntum, base_id: @base.id, secretaria_general: 'hola')
      end
      describe "valid attributes" do
        it "located the requested @basis" do
          patch :update, basis_id: @base.id, junta_id: @junta.id, junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          expect(assigns(:basis)).to eq @base
          expect(assigns(:junta)).to eq @junta
        end

        it "changes @base's attributes" do
          patch :update, basis_id: @base.id, junta_id: @junta.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          @junta.reload
          expect(@junta.secretaria_general).to eq("sds")
        end

        it "redirects to show base" do
          patch :update, basis_id: @base.id, junta_id: @junta.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          expect(response).to redirect_to basis_path(@base.id)
        end
        it "sets the updated message" do
          patch :update, basis_id: @base.id, junta_id: @junta.id, junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTE',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          flash[:notice].should =~ /Se actualizó correctamente la Junta Directiva/i
        end
      end

      describe "with invalid attributes" do
        it "does not change the base's attributes" do
          patch :update, basis_id: @base.id, junta_id: @junta.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          @junta.reload
          expect(@junta.secretaria_general).to_not eq("sds")
          expect(@junta.secretaria_general).to eq("hola")
        end

        it "re-renders the edit template" do
          patch :update, basis_id: @base.id, junta_id: @junta.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          patch :update, basis_id: @base.id, junta_id: @junta.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end
      end
    end

    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user                
        @base = create(:base)
        @junta = create(:juntum, base_id: @base.id, secretaria_general: 'hola')
      end
      it "show the correct access negated message" do
        patch :update, basis_id: @base.id, junta_id: @junta.id,junta: { secretaria_general: 'sds',
                                 numero_celular: '3432',
                                 email: 'sdsds@dffd.com',
                                 status: 'VIGENTEs',
                                 inicio_gestion: '12-12-1990',
                                 fin_gestion: '12-12-1990',
                                 descripcion: 'dsdsdsa'}
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
        @base = create(:base)
        @junta = create(:juntum, base_id: @base.id)
      end
    
      it "deletes the base" do
        expect{
          delete :destroy, basis_id: @base.id, junta_id: @junta.id
        }.to change(@base.juntas,:count).by(-1)
      end
      
      it "redirects to base#index" do
        delete :destroy, basis_id: @base.id, junta_id: @junta.id
        expect(response).to redirect_to basis_path(@base.id)
      end
      it "show a success message" do
        delete :destroy, basis_id: @base.id, junta_id: @junta.id
        flash[:notice].should =~ /Se eliminó correctamente la Junta Directiva/i
      end
    end
    context 'with un-authorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
        @base = create(:base)
        @junta = create(:juntum, base_id: @base.id)
      end
      it "show the correct access negated message" do
        delete :destroy, basis_id: @base.id, junta_id: @junta.id
        flash[:alert].should =~ /Acceso denegado./
      end
    end
  end  
end