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
	
	context 'A user visit perfil' do
		background do
			@user1 = create(:user, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234',
											apellidos_nombres: 'jose jose')
			loguear('46399081', 'hola1234')
		end
		scenario 'visit perfl' do
			visit mi_perfil_path
			expect(page).to have_content 'MI PERFIL'
		end	
	end

	context 'A user changes his password' do
		background do
			@user1 = create(:user, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234',
											apellidos_nombres: 'jose jose')
			loguear('46399081', 'hola1234')
		end
		scenario 'with good data' do
			visit edit_password_path
			fill_in 'user[current_password]', with: 'hola12345'
			fill_in 'user[password]', with: 'hola12345'
			fill_in 'user[password_confirmation]', with: 'hola12345'
			click_button('Cambiar')
			expect(page).to have_content 'Hubo un problema. Recuerde que el password'
		end
		scenario 'with complete ok data' do
			visit edit_password_path
			fill_in 'user[current_password]', with: 'hola1234'
			fill_in 'user[password]', with: 'hola12345'
			fill_in 'user[password_confirmation]', with: 'hola12345'
			click_button('Cambiar')
			expect(page).to have_content 'Se ha cambiado su password correctamente'
			cerrar_sesion
			loguear('46399081','hola1234')
			expect(page).to have_content 'INGRESO AL SISTEMA'
			loguear('46399081','hola12345')
			expect(page).to have_content 'jose jose'
		end
	end
end
