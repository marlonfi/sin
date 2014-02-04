require 'spec_helper'

describe Enfermera do
  it "does not allow a enfermera with a same cod_planilla " do
    create(:enfermera, cod_planilla: '2234567')
    expect(build(:enfermera, cod_planilla: '2234567', ente_id: 1)).to have(1).errors_on(:cod_planilla)
  end
  it "is valid with cod_planilla & apellidos y nombres y b_sinesss " do
  	expect(create(:enfermera)).to be_valid
  end
  it "is invalid without  apellidos paterno" do
  	expect(build(:enfermera, apellido_paterno: '')).to have(1).errors_on(:apellido_paterno)
  end
  it "is invalid without apellido materno" do
  	expect(build(:enfermera, apellido_materno: '')).to have(1).errors_on(:apellido_materno)
  end
  it "is invalid without nombres" do
  	expect(build(:enfermera, nombres: '')).to have(1).errors_on(:nombres)
  end
  it "is invalid without b_sinesss " do
  	expect(build(:enfermera, b_sinesss: nil)).to have(1).errors_on(:b_sinesss)
  end
  it "is invalid without ente" do
  	expect(build(:enfermera, ente_id: nil)).to be_invalid
  end
	it "does not allow a enfermera with a cod_planilla lenght < 7" do
		expect(build(:enfermera, cod_planilla: "a"*6)).to have(1).errors_on(:cod_planilla)
	end
	it "does not allow a enfermera with a cod_planilla lenght > 7" do
		expect(build(:enfermera, cod_planilla: "a"*8)).to have(1).errors_on(:cod_planilla)
	end
	it "does not allow a enfermera with a cod_planilla lenght nil" do
		expect(build(:enfermera, cod_planilla: nil)).to have(1).errors_on(:cod_planilla)
	end
  	it "validates format of email" do
		expect(build(:enfermera, email: 'asdsads.com')).to have(1).errors_on(:email)
	end
	it "validates lenght of email" do
		expect(build(:enfermera, email: 'a'*255+'@dsadsaa.com')).to have(1).errors_on(:email)
	end
	it "does not allow a nombre with more of 250 characters" do
    expect(build(:enfermera, nombres: "a"*252)).to have(1).errors_on(:nombres)
  end
  it "does not allow a apellido materno with more of 250 characters" do
    expect(build(:enfermera, apellido_materno: "a"*252)).to have(1).errors_on(:apellido_materno)
  end
  it "does not allow a apellido paterno with more of 250 characters" do
    expect(build(:enfermera, apellido_paterno: "a"*252)).to have(1).errors_on(:apellido_paterno)
  end
  it "validates lenght fo dni" do
	end
	it "validates regimen in cas" do
		expect(build(:enfermera, regimen: 'CAS')).to be_valid
	end
	it "validates regimen in contratado" do
		expect(build(:enfermera, regimen: 'CONTRATADO')).to be_valid
	end
	it "validates regimen in nombrado" do
		expect(build(:enfermera, regimen: 'NOMBRADO')).to be_valid
	end
	it "validates regimen in not cas contratado or nombreado" do
		expect(build(:enfermera, regimen: nil)).to have(1).errors_on(:regimen)
	end
	it "validates regimen in not cas contratado or nombreado" do
		expect(build(:enfermera, regimen: 'IOKERO')).to have(1).errors_on(:regimen)
	end

	it "imports enfermeras" do
    archivo = Import.create(tipo_clase: "Red Asistencial",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/factories/files/pruebas_enfermeras.csv'))))
    RedAsistencial.import(archivo)
    Ente.import(archivo)
    expect{
        Enfermera.import_essalud(archivo)
      }.to change(Enfermera, :count).by(51)
  end
   it 'creates a bitacora when a enfermera changes sinesss'
   it 'changes the full name before validate' 					
end
