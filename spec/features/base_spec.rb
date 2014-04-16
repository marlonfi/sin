#encoding: utf-8
require "spec_helper"

feature 'Bases management' do
	background do
		@user1 = create(:organizacional, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
		@base = create(:base, codigo_base: 'Base1')
		visit bases_path
	end

	scenario "Creates a new base" do
		click_link 'Nueva base'
		expect{
			fill_in 'base[codigo_base]', with: 'Base2'
			click_button 'Guardar'
		}.to change(Base, :count).by(1)
		expect(page).to have_content 'Se registró correctamente la base'
		expect(page).to have_content 'Base2'
	end

	scenario "Do not creates a new base with an existing codig_base" do
		click_link 'Nueva base'
		expect{
			fill_in 'base[codigo_base]', with: 'Base1'
			click_button 'Guardar'			
		}.to_not change(Base, :count)
		expect(page).to have_content 'Hubo un problema. No se registró la base'
	end	
end

feature "Import managment Base" do
	background do
		@user1 = create(:informatica, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
	end
	scenario "toggles modal for import", js: true do
		visit bases_path
		expect(page).to_not have_content 'Importar bases'
		click_link 'Importar'
		expect(page).to have_content 'Importar bases'
	end

	scenario "gives file and import", js: true do
		visit bases_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/bases.csv'))
		click_button('Procesar')
		expect(page).to have_content 'OK! El proceso de importacion durará unos minutos.'
	end
end
