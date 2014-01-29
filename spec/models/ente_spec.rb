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

	it "imports the entes" do
    archivo = Import.create(tipo_clase: "Red Asistencial",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/factories/files/entes.csv'))))
    RedAsistencial.import(archivo)
    expect{
        Ente.import(archivo)
      }.to change(Ente, :count).by(29)
  end 

end
