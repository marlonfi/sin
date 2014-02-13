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
feature "Change Enfermeras Ente" do
	background do
		@archivo = Import.create(tipo_clase: "Red Asistencial",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
    RedAsistencial.import(@archivo)
    Ente.import(@archivo)
    Enfermera.import_essalud(@archivo)
    @ente_sabogal = Ente.find_by_cod_essalud('HII G.Lanatta')
    @ente_junin = Ente.find_by_cod_essalud('Def.del Asegu-RA Junin')
    @enfermera = Enfermera.find_by_cod_planilla('1403989')
	end
	scenario "change the Entes::Enfermeras" do
		visit edit_enfermera_path(@enfermera)
		expect{
			select 'Def.del Asegu-RA Junin', :from => 'enfermera_ente_id'
			click_button 'Guardar'			
		}.to change(@ente_sabogal.enfermeras, :count).by(-1)
		expect(@ente_sabogal.enfermeras).to_not include(@enfermera)
		expect(@ente_junin.enfermeras).to include(@enfermera) 		
	end
end