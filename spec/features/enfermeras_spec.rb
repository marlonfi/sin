#encoding: utf-8
require "spec_helper"

feature "Import managment: enfermera_actualizacion_datos" do
	background do
		@user1 = create(:informatica, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')		
	end
	scenario "toggles modal for import", js: true do
		visit enfermeras_path
		expect(page).to_not have_content 'Actualizar Data de las Enfermeras'
		click_link 'Actualizar Datos Enf.'
		expect(page).to have_content 'Actualizar Data de las Enfermeras'
	end

	scenario "gives file and import", js: true do
		visit enfermeras_path
		click_link 'Actualizar Datos Enf.'
		attach_file('Archivo', File.join(Rails.root,
											 '/spec/factories/files/actualizacion_datos_enfermera.csv'))
		click_button('Procesar')
		expect(page).to have_content 'OK! El proceso de importacion durará unos minutos.'
	end
	scenario "gives a bad file format", js: true do
		visit enfermeras_path
		click_link 'Actualizar Datos Enf.'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/bad.ods'))
		click_button('Procesar')
		expect(page).to have_content 'El archivo es muy grande, o tiene un formato incorrecto.'
	end	
end

feature "Import managment: enfermera" do
	background do
		@user1 = create(:informatica, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')		
	end
	scenario "toggles modal for import", js: true do
		visit enfermeras_path
		expect(page).to_not have_content 'Importar enfermeras'
		click_link 'Importar'
		expect(page).to have_content 'Importar enfermeras'
	end

	scenario "gives file and import", js: true do
		visit enfermeras_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/lista_essalud.csv'))
		click_button('Procesar')
		expect(page).to have_content 'OK! El proceso de importacion durará unos minutos.'
	end
	scenario "gives a bad file format", js: true do
		visit enfermeras_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/bad.ods'))
		click_button('Procesar')
		expect(page).to have_content 'El archivo es muy grande, o tiene un formato incorrecto.'
	end	
end
