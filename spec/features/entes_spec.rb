#encoding: utf-8
require "spec_helper"

feature 'Entes management' do
	background do
		@red = create(:red_asistencial, cod_essalud: 'RA Puno')
		@red.entes.create(cod_essalud: 'Hospi')
		@user1 = create(:organizacional, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
		visit entes_path
	end

	scenario "Creates a new ente" do
		click_link 'Nuevo ente'
		expect{
			fill_in 'ente[cod_essalud]', with: 'Hospi2'
			select 'RA Puno', :from => 'ente[red_asistencial_id]'
			click_button 'Guardar'
		}.to change(Ente, :count).by(1)
		expect(page).to have_content 'Se registró correctamente el ente'
		expect(page).to have_content 'Hospi2'
	end

	scenario "Do not creates a new red_asistencial with an existing id_essalud" do
		click_link 'Nuevo ente'
		expect{
			fill_in 'ente[cod_essalud]', with: 'Hospi'
			select 'RA Puno', :from => 'ente[red_asistencial_id]'
			click_button 'Guardar'			
		}.to_not change(Ente, :count)
		expect(page).to have_content 'Hubo un problema. No se registró el ente'
	end
	scenario "Do Not reates a new red_asistencial without selection a RA" do
		click_link 'Nuevo ente'
		expect{
			fill_in 'ente[cod_essalud]', with: 'Hospissss'
			click_button 'Guardar'			
		}.to_not change(Ente, :count)
		expect(page).to have_content 'Hubo un problema. No se registró el ente'
	end
end

feature "Import managment Ente" do
	background do
		@user1 = create(:informatica, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
	end
	scenario "toggles modal for import", js: true do
		visit entes_path
		expect(page).to_not have_content 'Importar Entes'
		click_link 'btnImportEnte'
		expect(page).to have_content 'Entes'
	end

	scenario "gives file and import", js: true do
		visit entes_path
		click_link 'btnImportEnte'
		attach_file('Archivo', File.join(Rails.root, '/spec/factories/files/lista_essalud.csv'))
		click_button('Procesar')
		expect(page).to have_content 'OK! El proceso de importacion durará unos minutos.'
	end
end

feature "Change Ente RA" do
	background do
		@archivo = Import.create(tipo_clase: "Red Asistencial",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
    RedAsistencial.import(@archivo)
    Ente.import(@archivo)
    @ra_junin = RedAsistencial.find_by_cod_essalud('RA Junin')
    @ra_sabogal = RedAsistencial.find_by_cod_essalud('RA Sabogal')
    @ente_sabogal = Ente.find_by_cod_essalud('HII G.Lanatta')
    @ente_junin = Ente.find_by_cod_essalud('Def.del Asegu-RA Junin')
    @user1 = create(:organizacional, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
	end
	scenario "change the RA::Entes" do
		visit edit_ente_path(@ente_sabogal)
		expect{
			select 'RA Junin', :from => 'ente_red_asistencial_id'
			click_button 'Guardar'			
		}.to change(@ra_junin.entes, :count).by(1)
		expect(@ra_junin.entes).to include(@ente_sabogal)
		expect(@ra_sabogal.entes).to_not include(@ente_sabogal) 		
	end
end


feature "Change Base of Ente" do
	background do
		@archivo = Import.create(tipo_clase: "Ente",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
    @bases = Import.create(tipo_clase: "Ente",
                            archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                            '/spec/factories/files/bases.csv'))))
    @juntas = Import.create(tipo_clase: "Ente",
                            archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                            '/spec/factories/files/juntas.csv'))))
    RedAsistencial.import(@archivo)
    Ente.import(@archivo)
    Base.import_bases(@bases) 
  	@base1 = Base.find_by_codigo_base('B-D HIV Huancayo')
    @base2 = Base.find_by_codigo_base('B-HIV Sabogal')
    @ente1 = Ente.find_by_cod_essalud('Def.del Asegu-RA Junin')
    @user1 = create(:organizacional, dni: '46399081', password: 'hola1234', password_confirmation: 'hola1234')
	  loguear('46399081', 'hola1234')
	end
	scenario "change the Ente::Base" do
		expect(@base1.entes).to include(@ente1)
		visit edit_ente_path(@ente1)
		expect{
			select 'B-HIV Sabogal', :from => 'ente_base_id'
			click_button 'Guardar'			
		}.to change(@base2.entes, :count).by(1)
		expect(@base2.entes).to include(@ente1)
		expect(@base1.entes).to_not include(@ente1) 		
	end
end