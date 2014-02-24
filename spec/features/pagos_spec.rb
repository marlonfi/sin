#encoding: utf-8
require "spec_helper"

feature "Pagos managment" do
	scenario "gives file and import", js: true do
		visit pagos_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root,
											 '/spec/factories/files/cas-noviembre.TXT'))
		click_button('Procesar')
		expect(page).to have_content 'OK! El proceso de importacion durará unos minutos.'
	end
	scenario "gives a bad file format", js: true do
		visit pagos_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/bad.ods'))
		click_button('Procesar')
		expect(page).to have_content 'El archivo es muy grande, o tiene un formato incorrecto.'
	end	
end
