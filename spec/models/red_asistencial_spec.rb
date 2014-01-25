require 'spec_helper'

describe RedAsistencial do
  it "is valid with cod_essalud" do
  	expect(create(:red_asistencial)).to be_valid
  end
  it "is invalid without cod_essalud" do
  	expect(build(:red_asistencial, cod_essalud: nil)).to have(1).errors_on(:cod_essalud)
  end
  it "does not allow a red_asisencial with the same cod_essalud" do
  	create(:red_asistencial, cod_essalud: "RA Junin")
		expect(build(:red_asistencial, cod_essalud: "RA Junin")).to be_invalid
		expect(build(:red_asistencial, cod_essalud: "RA Junin")).to have(1).errors_on(:cod_essalud)
	end
  it "does not allow a red_asistencial with more of 250 characters" do
    expect(build(:red_asistencial, cod_essalud: "a"*252)).to have(1).errors_on(:cod_essalud)
  end
  it "does not allow a contacto_nombre with more of 250 characters" do
    expect(build(:red_asistencial, contacto_nombre: "a"*252)).to have(1).errors_on(:contacto_nombre)
  end
  it "does not allow a contacto_telefono with more of 250 characters" do
    expect(build(:red_asistencial, contacto_telefono: "a"*252)).to have(1).errors_on(:contacto_telefono)
  end
	it "imports the red_asistencials"
end
