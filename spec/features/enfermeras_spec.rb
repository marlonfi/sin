#encoding: utf-8
require "spec_helper"

feature 'Enfermeras management' do
end
feature "Import managment: enfermera" do
	scenario "toggles modal for import", js: true do
		visit enfermeras_path
		expect(page).to_not have_content 'Importar enfermeras'
		click_link 'Importar'
		expect(page).to have_content 'Importar enfermeras'
	end

	scenario "gives file and import", js: true do
		visit enfermeras_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/relacion.csv'))
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
