require 'spec_helper'

describe Ente do
  it "is valid with cod_essalud & red_asistencial " do
  	expect(create(:ente)).to be_valid
  end
  it "is invalid without cod_essalud" do
  	expect(build(:ente, cod_essalud: nil)).to have(1).errors_on(:cod_essalud)
  	expect(build(:ente, red_asistencial_id: nil)).to be_invalid
  end
  it "does not allow a Enter with the same cod_essalud" do
  	ra = create(:red_asistencial)
  	ente = ra.entes.create(cod_essalud: 'HVI Junin')
  	expect(ra.entes.build(cod_essalud: "HVI Junin")).to be_invalid
    expect(ra.entes.build( cod_essalud: "hVI junin")).to be_invalid
    expect(ra.entes.build( cod_essalud: "HVI Junin")).to have(1).errors_on(:cod_essalud)
	end

	it "does not allow a red_asistencial with more of 250 characters" do
    expect(build(:ente, cod_essalud: "a"*252)).to have(1).errors_on(:cod_essalud)
  end
  it "does not allow a contacto_nombre with more of 250 characters" do
    expect(build(:ente, contacto_nombre: "a"*252)).to have(1).errors_on(:contacto_nombre)
  end
  it "does not allow a contacto_telefono with more of 250 characters" do
    expect(build(:ente, contacto_numero: "a"*252)).to have(1).errors_on(:contacto_numero)
  end
  it "does not allow a direccion with more of 250 characters" do
    expect(build(:ente, direccion: "a"*252)).to have(1).errors_on(:direccion)
  end
  it "does not allow a nombre with more of 250 characters" do
    expect(build(:ente, nombre: "a"*252)).to have(1).errors_on(:nombre)
  end

  context 'importation of entes' do
    before(:each) do
      @archivo = Import.create(tipo_clase: "Ente",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
      RedAsistencial.import(@archivo)
      Ente.import(@archivo)
    end
    it "imports all entes" do
      expect(Ente.all.count).to eq(39) 
    end
    context 'imports in the correct RA' do
      before(:each) do
        @ra_junin = RedAsistencial.find_by_cod_essalud('RA Junin')
        @ra_sabogal = RedAsistencial.find_by_cod_essalud('RA Sabogal')
        @ra_otros = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
      end
      it 'gives to RA Junin 3 entes' do
        expect(@ra_junin.entes.count).to eq(3) 
      end
      it 'gives the correct entes to RA Junin' do
        ente1 = Ente.find_by_cod_essalud('H II A.Hurtado')
        ente2 = Ente.find_by_cod_essalud('Def.del Asegu-RA Junin')
        ente3 = Ente.find_by_cod_essalud('HII G.Lanatta')        
        expect(@ra_junin.entes).to include(ente1)
        expect(@ra_junin.entes).to include(ente2) 
        expect(@ra_junin.entes).to_not include(ente3)  
      end
      it 'gives to RA Sabogal 9 entes' do
        expect(@ra_sabogal.entes.count).to eq(9) 
      end
      it 'gives the correct entes to RA Sabogal' do
        ente1 = Ente.find_by_cod_essalud('HII G.Lanatta')        
        expect(@ra_sabogal.entes).to include(ente1)
      end
      it 'gives to ORG. DESCONCENTRADOS 12 entes' do
        expect(@ra_otros.entes.count).to eq(12) 
      end
      it 'gives the correct entes to RA Sabogal' do
        ente1 = Ente.find_by_cod_essalud('HII G.Lanatta')
        ente2 = Ente.find_by_cod_essalud('STAE')
        ente3 = Ente.find_by_cod_essalud('INCOR')
        ente4 = Ente.find_by_cod_essalud('AFESSALUD-CRUEN')
        ente5 = Ente.find_by_cod_essalud('AFESSALUD-SEDE_CENTRAL')        
        expect(@ra_otros.entes).to_not include(ente1)
        expect(@ra_otros.entes).to include(ente2)
        expect(@ra_otros.entes).to include(ente3) 
        expect(@ra_otros.entes).to include(ente4)
        expect(@ra_otros.entes).to include(ente5) 
      end
    end
  end	
end
