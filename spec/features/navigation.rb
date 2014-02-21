#encoding: utf-8
require "spec_helper"

feature "Navigation" do
	scenario "toggles display organizationals links", js: true do
		visit dashboard_path
		expect(page).to_not have_content 'Redes Asistenciales'
		expect(page).to_not have_content 'Enfermeras'
		click_link 'Organizacional'
		click_link 'Organizacional'
		expect(page).to_not have_content 'Redes Asistenciales'
		expect(page).to_not have_content 'Enfermeras'
	end

	scenario 'togles the notifications', js: true do
		@archivo = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
		@archivo2 = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/notificaciones.csv'))))
    RedAsistencial.import(@archivo)
    Ente.import(@archivo)
    Enfermera.import_essalud(@archivo)
    Enfermera.import_essalud(@archivo2)
    visit dashboard_path
    expect(page).to_not have_content 'Afiliaciones sin resolver.'
    expect(page).to_not have_content 'Desafiliaciones sin resolver.'
    expect(page).to_not have_content '8 notificaciones pendientes'
    click_link 'notificaciones'
    expect(page).to have_content 'Afiliaciones sin resolver.'
    expect(page).to have_content 'Desafiliaciones sin resolver.'
    expect(page).to have_content '8 notificaciones pendientes'
	end
end
