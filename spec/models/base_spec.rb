require 'spec_helper'

describe Base do
  it "is valid with codigo_base" do
  	expect(create(:base)).to be_valid
  end
  it "is invalid without cod" do
  	expect(build(:base, codigo_base: nil)).to have(1).errors_on(:codigo_base)
  end

  it "does not allow a base with the same codigo_base" do
  	create(:base, codigo_base: "Base Junin")
		expect(build(:base, codigo_base: "Base Junin")).to be_invalid
    expect(build(:base, codigo_base: "base junin")).to have(1).errors_on(:codigo_base)
  end

  it "does not allow a codigo_base with more of 250 characters" do
    expect(build(:base, codigo_base: "a"*252)).to have(1).errors_on(:codigo_base)
  end
  it "does not allow a codigo_base with more of 250 characters" do
    expect(build(:base, nombre_base: "a"*252)).to have(1).errors_on(:nombre_base)
  end
  
  context 'importation of bases' do
    before(:each) do
      @archivo = Import.create(tipo_clase: "Ente",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
      @bases = Import.create(tipo_clase: "Ente",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/bases.csv'))))
      RedAsistencial.import(@archivo)
      Ente.import(@archivo)
      Enfermera.import_essalud(@archivo)
      Base.import_bases(@bases)
    end
    it "imports all entes" do
      expect(Base.all.count).to eq(118) 
    end
    context 'imports in the entes in the correct Bases' do
      before(:each) do
        @base1 = Base.find_by_codigo_base('B-H II A.Hurtado')
        @base2 = Base.find_by_codigo_base('B-D HIV Huancayo')
        @base3 = Base.find_by_codigo_base('B-HIV Sabogal')
        @base4 = Base.find_by_codigo_base('B-AFESSALUD-CRUEN')
        @base5 = Base.find_by_codigo_base('B-AFESSALUD-SEDE_CENTRAL')
      end
      it 'gives to the correct number of entes to base B-HIV Sabogal & B-H II A.Hurtado' do
        expect(@base2.entes.count).to eq(2)
        expect(@base1.entes.count).to eq(1)
        expect(@base3.entes.count).to eq(2) 
      end
      it 'gives the correct entes to B-D HIV Huancayo' do
        ente1 = Ente.find_by_cod_essalud('Def.del Asegu-RA Junin')
        ente2 = Ente.find_by_cod_essalud('Org.Ctrol.Ins-RA Junin')
        ente3 = Ente.find_by_cod_essalud('H II A.Hurtado')
        ente4 = Ente.find_by_cod_essalud('Ger.Red Asist.-RA Sabogal')
        expect(@base2.entes).to include(ente1)
        expect(@base2.entes).to include(ente2)
        expect(@base2.entes).to_not include(ente3)
        expect(@base3.entes).to include(ente4)
      end
      it 'gives the correct entes to B-AFESSALUD-SEDE_CENTRAL' do
        ente1 = Ente.find_by_cod_essalud('AFESSALUD-SEDE_CENTRAL')
        expect(@base5.entes).to include(ente1)
      end
      it 'has the correct number of miembros in a base' do
        expect(@base4.enfermeras.total_sinesss.count).to eq(0)
        expect(@base5.enfermeras.total_sinesss.count).to eq(2)
        expect(@base3.enfermeras.total_sinesss.count).to eq(2)
      end
      it 'has the correct enfermeras in a base' do
        enfermera_afessalud_sede = Enfermera.find_by_cod_planilla('3047538')
        enfermera_afessalud_cruen = Enfermera.find_by_cod_planilla('5601041')
        enfermera_sabogal = Enfermera.find_by_cod_planilla('1498788')
        enfermera_hyo = Enfermera.find_by_cod_planilla('4806071')
        expect(@base4.enfermeras.total_sinesss).to_not include(enfermera_afessalud_cruen)
        expect(@base5.enfermeras.total_sinesss).to include(enfermera_afessalud_sede)
        expect(@base3.enfermeras.total_sinesss).to include(enfermera_sabogal)
        expect(@base2.enfermeras.total_sinesss).to include( enfermera_hyo)
      end       
    end
  end
  context 'importation of juntas' do
    before(:each) do
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
    end
    it 'gives the correct junta to base' do
      Base.import_juntas(@juntas)
      base1 = Base.find_by_codigo_base('B-D HIV Huancayo')
      base2 = Base.find_by_codigo_base('B-HIV Sabogal')
      junta1 = Junta.find_by_secretaria_general('ROMERO ROMANI MARGOT LILY')
      junta2 = Junta.find_by_secretaria_general('VARGAS CAMARENA MARLENE ELIZABETH')
      expect(base1.juntas).to include(junta1)
      expect(base2.juntas).to include(junta2)
    end
  end
end
