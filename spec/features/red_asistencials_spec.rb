#encoding: utf-8
require "spec_helper"

feature 'Redes asistenciales management' do

	background do
		create(:red_asistencial, cod_essalud: 'RA Puno')
		visit red_asistencials_path
	end

	scenario "Creates a new red_asistencial" do
		click_link 'Nueva RA'
		expect{
			fill_in 'red_asistencial[cod_essalud]', with: 'RA Callao'
			click_button 'Guardar'
		}.to change(RedAsistencial, :count).by(1)
		expect(page).to have_content 'Se registró correctamente la red asistencial'
		expect(page).to have_content 'RA Callao'
	end

	scenario "Do not creates a new red_asistencial with an existing id_essalud" do
		click_link 'Nueva RA'
		expect{
			fill_in 'red_asistencial[cod_essalud]', with: 'RA Puno'
			click_button 'Guardar'			
		}.to_not change(RedAsistencial, :count)
		expect(current_path).to eq red_asistencials_path
		expect(page).to have_content 'Hubo un problema. No se registró la red asistencial.'
	end
end

feature "Import managment" do
	scenario "toggles modal for import", js: true do
		visit red_asistencials_path
		expect(page).to_not have_content 'Importar Redes Asistenciales'
		click_link 'Importar'
		expect(page).to have_content 'Importar Redes Asistenciales'
	end

	scenario "gives file and import", js: true do
		visit red_asistencials_path
		click_link 'Importar'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/relacion.csv'))
		click_button('Procesar')
		expect(page).to have_content 'OK! El proceso de importacion durará unos minutos.'
	end

end
