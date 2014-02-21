#encoding: utf-8
require "spec_helper"

feature 'Bitacoras management' do
	background do
		@archivo = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
    RedAsistencial.import(@archivo)
    Ente.import(@archivo)
    Enfermera.import_essalud(@archivo)
    @enfermera = Enfermera.find_by_cod_planilla('3886608')
	end

	scenario "Creates a nueva bitacora" do
		visit enfermera_path(@enfermera)
		click_link 'Bitácora'
		click_link 'Nueva bitácora'
		expect{
			select 'AFILIACION', :from => 'bitacora[tipo]'
			select 'PENDIENTE', :from => 'bitacora[status]'
			click_button 'Guardar'
		}.to change(@enfermera.bitacoras, :count).by(1)
		click_link 'Nueva bitácora'
		expect{
			select 'OTROS', :from => 'bitacora[tipo]'
			select 'PENDIENTE', :from => 'bitacora[status]'
			click_button 'Guardar'
		}.to change(@enfermera.bitacoras, :count).by(1)
		expect(page).to have_content 'Afiliaciones sin resolver.'
		expect(page).to have_content 'Otros sin resolver'
	end
	scenario "Creates a nueva bitacora" do
		visit enfermera_path(@enfermera)
		click_link 'Bitácora'
		click_link 'Nueva bitácora'
		expect{
			select 'AFILIACION', :from => 'bitacora[tipo]'
			select 'SOLUCIONADO', :from => 'bitacora[status]'
			click_button 'Guardar'
		}.to change(@enfermera.bitacoras, :count).by(1)
		expect(page).to_not have_content 'Afiliaciones sin resolver.'
	end		
end