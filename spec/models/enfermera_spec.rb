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

  it 'creates a bitacora when a enfermera changes sinesss'
  it 'changes the full name before validate'




  context 'importation of enfermeras' do
    before(:each) do
      @archivo = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
      RedAsistencial.import(@archivo)
      Ente.import(@archivo)
      Enfermera.import_essalud(@archivo)
    end
    it "imports all enfermeras" do
      expect(Enfermera.all.count).to eq(53) 
    end

    context 'a enfermeras has the correct data' do
      before(:each) do
        @enfermera1 = Enfermera.find_by_cod_planilla('1598712')
        @enfermera2 = Enfermera.find_by_cod_planilla('3478335')
        @enfermera3 = Enfermera.find_by_cod_planilla('1449707')
      end
      it 'has the correct full name and names' do
        expect(@enfermera1.full_name).to eq('AGUIRRE ABRILL BEATRIZ MARCELA')
        expect(@enfermera2.full_name).to eq('ALCANTARA RODRIGUEZ SHIRLEY YOJANSEN')
        expect(@enfermera3.apellido_paterno).to eq('PARRA')
        expect(@enfermera3.apellido_materno).to eq('AGUILAR')
        expect(@enfermera3.nombres).to eq('DE SANDO AIDA LUZ')
      end
      it 'has the correct regimen' do
        expect(@enfermera1.regimen).to eq('NOMBRADO')
        expect(@enfermera2.regimen).to eq('CONTRATADO')
        expect(@enfermera3.regimen).to eq('NOMBRADO')
      end
      it 'has the correct sindicatos' do
        expect(@enfermera1.b_sinesss).to be_true
        expect(@enfermera1.b_excel).to be_true
        expect(@enfermera1.b_fedcut).to_not be_true
        expect(@enfermera2.b_sinesss).to_not be_true
        expect(@enfermera2.b_fedcut).to_not be_true
        expect(@enfermera3.b_sinesss).to be_true
        expect(@enfermera3.b_fedcut).to_not be_true
        expect(@enfermera3.b_famesalud).to be_true
        expect(@enfermera3.b_excel).to be_true
      end
    end

    context 'imports in the correct Ente' do
      before(:each) do
        @ente_1 = Ente.find_by_cod_essalud('AFESSALUD-CRUEN')
        @ente_2 = Ente.find_by_cod_essalud('AFESSALUD-SEDE_CENTRAL')
        @ente_3 = Ente.find_by_cod_essalud('CEPRIT')
        @ente_4 = Ente.find_by_cod_essalud('STAE')
        @ente_5 = Ente.find_by_cod_essalud('Def.del Asegu-RA Junin')
        @ente_6 = Ente.find_by_cod_essalud('H II A.Hurtado')
        @ente_7 = Ente.find_by_cod_essalud('H I Mongrut')
        @ente_8 = Ente.find_by_cod_essalud('CN Salud Rena')
      end
      it 'gives to CEPRIT 2 enfermeras' do
        expect(@ente_3.enfermeras.count).to eq(2) 
      end
      it 'gives the correct enfermeras to CEPRIT & STAE' do
        enfermera1 = Enfermera.find_by_cod_planilla('1598712')
        enfermera2 = Enfermera.find_by_cod_planilla('3478335')
        expect(@ente_3.enfermeras).to include(enfermera1)
        expect(@ente_3.enfermeras).to include(enfermera2)
        enfermera3 = Enfermera.find_by_cod_planilla('5001461')
        expect(@ente_4.enfermeras).to include(enfermera3)
      end
      it 'gives the correct enfermeras to AFESSALUD-CRUEN & AFESSALUD-SEDE_CENTRAL' do
        enfermerac1 = Enfermera.find_by_cod_planilla('5601041')
        enfermerac2 = Enfermera.find_by_cod_planilla('5623816')
        enfermeras1 = Enfermera.find_by_cod_planilla('3047538')
        enfermeras2 = Enfermera.find_by_cod_planilla('4335408')
        expect(@ente_1.enfermeras).to_not include(enfermeras1)
        expect(@ente_1.enfermeras).to include(enfermerac1)
        expect(@ente_1.enfermeras).to include(enfermerac2)
        expect(@ente_2.enfermeras).to include(enfermeras2)
        expect(@ente_2.enfermeras).to_not include(enfermerac2)
      end
      it 'gives the correct enfermeras to Def.del Asegu-RA Junin' do
        enfermera1 = Enfermera.find_by_cod_planilla('4806071')
        expect(@ente_5.enfermeras).to include(enfermera1)
      end
      it 'gives the correct enfermeras to H II A.Hurtado' do
        enfermera1 = Enfermera.find_by_cod_planilla('1449707')
        expect(@ente_6.enfermeras).to include(enfermera1)
      end
      it 'gives the correct enfermeras to H I Mongrut' do
        enfermera1 = Enfermera.find_by_cod_planilla('1611225')
        expect(@ente_7.enfermeras).to include(enfermera1)
      end
      it 'gives the correct enfermeras to CN Salud Rena' do
        enfermera1 = Enfermera.find_by_cod_planilla('2079949')
        expect(@ente_8.enfermeras).to include(enfermera1)
      end
    end
  end
end