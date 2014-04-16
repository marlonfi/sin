#encoding: utf-8
require "spec_helper"

feature 'Bitacoras management' do
	background do
		@user1 = create(:organizacional, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')		
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

feature "Notifications bell of bitacoras" do
	scenario "not shows fo informatica user" do
		@user1 = create(:informatica, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
		expect(page).to_not have_content 'notificaciones pendientes'		
	end
	scenario "shows fo organizacional user" do
		@user1 = create(:organizacional, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
		expect(page).to have_content 'notificaciones pendientes'		
	end
	scenario "shows fo admin user" do
		@user1 = create(:admin, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
		expect(page).to have_content 'notificaciones pendientes'		
	end
	scenario "shows fo reader user" do
		@user1 = create(:reader, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
		expect(page).to have_content 'notificaciones pendientes'		
	end
end