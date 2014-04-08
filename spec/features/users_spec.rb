#encoding: utf-8
require "spec_helper"

feature 'Creando usuarios' do
	context 'A authorized user' do
		background do
			@user1 = create(:superadmin, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
			loguear('46399081', 'hola1234')
		end
		scenario "Creates a new user and can enter with his dni and his password a dni" do
			visit new_user_path
			fill_in 'user[dni]', with: '40404040'
			fill_in 'user[apellidos_nombres]', with: 'usuario loco'
			fill_in 'user[cargo]', with: 'superusuario'
			click_button('Guardar')
			expect(page).to have_content 'Se registró correctamente el usuario.'
			cerrar_sesion
			loguear('40404040','40404040')
			expect(page).to have_content 'usuario loco'
		end
	end
	context 'A not authorized user'	do
		background do
			@user1 = create(:user, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
			loguear('46399081', 'hola1234')
		end
		scenario 'tries to create a new user' do
			visit new_user_path
			expect(page).to have_content 'Acceso denegado.'
		end
	end
end
