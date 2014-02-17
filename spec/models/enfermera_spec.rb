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
  it "does not allow a factor_sanguineo with more of 250 characters" do
    expect(build(:enfermera, factor_sanguineo: "a"*252)).to have(1).errors_on(:factor_sanguineo)
  end
  it "does not allow a domicilio_completo with more of 250 characters" do
    expect(build(:enfermera, domicilio_completo: "a"*252)).to have(1).errors_on(:domicilio_completo)
  end
  it "does not allow a dni without lenght of 8" do
    expect(build(:enfermera, dni: "a"*9)).to have(1).errors_on(:dni)
  end
  it "does not allow a empty dni" do
    expect(build(:enfermera, dni: "")).to be_valid
  end
  it "does not allow a telefono with more of 250 characters" do
    expect(build(:enfermera, telefono: "a"*252)).to have(1).errors_on(:telefono)
  end
  it "validates sexo valid" do
    expect(build(:enfermera, sexo: 'MASCULINO')).to be_valid
  end
  it "validates sexo valid" do
    expect(build(:enfermera, sexo: 'FEMENINO')).to be_valid
  end
  it "validates invalid sexo"  do
    expect(build(:enfermera, sexo: 'M')).to_not be_valid
  end
  it "is valid fecha_nacimiento" do
    expect(build(:enfermera, fecha_nacimiento: '02/02/1990')).to be_valid
  end
  it "is valid fecha_inscripcion_sinesss" do
    expect(build(:enfermera, fecha_inscripcion_sinesss: '02/02/1993')).to be_valid
  end
  it "is valid fecha_ingreso_essalud" do
    expect(build(:enfermera, fecha_ingreso_essalud: '02/02/1994')).to be_valid
  end
  it "is invalid fecha_nacimiento" do
    expect(build(:enfermera, fecha_nacimiento: '02/02s/1990')).to_not be_valid
  end
  it "is invalid fecha_ingreso_essalud" do
    expect(build(:enfermera, fecha_ingreso_essalud: 'sadsa')).to_not be_valid
  end
  it "is invalid fecha_inscripcion_sinesss" do
    expect(build(:enfermera, fecha_inscripcion_sinesss: '02/0d2/1993')).to_not be_valid
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

   context 'acualizacion of enfermeras' do
    before(:each) do
      @archivo = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
      @archivo2 = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/actualizacion_datos_enfermera.csv'))))
      RedAsistencial.import(@archivo)
      Ente.import(@archivo)
      Enfermera.import_essalud(@archivo)
      Enfermera.import_data_actualizada(@archivo2)
    end
    context 'a enfermeras has the correct data' do
      before(:each) do
        @enfermera1 = Enfermera.find_by_cod_planilla('2439438')
        @enfermera2 = Enfermera.find_by_cod_planilla('4342750')
        @enfermera3 = Enfermera.find_by_cod_planilla('1519397')
        @enfermera4 = Enfermera.find_by_cod_planilla('1498788')
        @enfermera5 = Enfermera.find_by_cod_planilla('1603512')
      end
      it 'has the correct ap_paterno' do
        expect(@enfermera1.apellido_paterno).to eq('CARDENAS MONAGO OLINDA')
        expect(@enfermera2.apellido_paterno).to eq('CACERES')
        expect(@enfermera5.apellido_paterno).to eq('CARRILLO')
      end
      it 'has the correct ap_materno' do
        expect(@enfermera1.apellido_materno).to eq('MONAGO')
        expect(@enfermera2.apellido_materno).to eq('DEL CARPIO')
        expect(@enfermera5.apellido_materno).to eq('ALFARO DE JIMENEZ')
      end
      it 'has the correct nombres' do
        expect(@enfermera3.nombres).to eq('MARITZA SOLEDAD')
      end
      it 'has the full_name' do
        expect(@enfermera5.full_name).to eq('CARRILLO ALFARO DE JIMENEZ CELIA HILDA')
      end
      it 'has the correct email' do
        expect(@enfermera1.email).to eq('cardenas@gmail.com')
        expect(@enfermera2.email).to eq('caceres@gmail.com')
        expect(@enfermera3.email).to eq('motta@gmail.com')
        expect(@enfermera4.email).to eq(nil)
        expect(@enfermera5.email).to eq('carrillo@gmail.com')
      end
      it 'has the correct dni' do        
        expect(@enfermera1.dni).to eq('23232323')
        expect(@enfermera2.dni).to eq('23232324')
        expect(@enfermera3.dni).to eq(nil)
        expect(@enfermera4.dni).to eq(nil)
        expect(@enfermera5.dni).to eq('23232327')
      end
      it 'has the correct sexo' do        
        expect(@enfermera1.sexo).to eq('MASCULINO')
        expect(@enfermera2.sexo).to eq('FEMENINO')
        expect(@enfermera3.sexo).to eq('MASCULINO')
        expect(@enfermera5.sexo).to eq('FEMENINO')
      end
      it 'has the correct factor_sanguineo' do                
        expect(@enfermera1.factor_sanguineo).to eq('O')
        expect(@enfermera2.factor_sanguineo).to eq(nil)
      end
      it 'has the correct domicilio_completo' do                        
        expect(@enfermera1.domicilio_completo).to eq(nil)
        expect(@enfermera2.domicilio_completo).to eq('JR.ATALAYA 1122')
        expect(@enfermera3.domicilio_completo).to eq('JR.ATALAYA 1123')
        expect(@enfermera4.domicilio_completo).to eq(nil)
        expect(@enfermera5.domicilio_completo).to eq('JR.ATALAYA 1125')
      end
      it 'has the correct telefono' do
        expect(@enfermera1.telefono).to eq('222268')
        expect(@enfermera2.telefono).to eq('222269')
      end
      it 'has the correct regimen' do                
        expect(@enfermera1.regimen).to eq('CAS')
        expect(@enfermera2.regimen).to eq('CONTRATADO')
      end  
    end  
  end
end