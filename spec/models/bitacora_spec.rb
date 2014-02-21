require 'spec_helper'

describe Bitacora do
	it "is invalid without enfermera_id" do
  	expect(build(:bitacora, enfermera_id: '')).to have(1).errors_on(:enfermera_id)
  end
  it "is invalid without tipo" do
  	expect(build(:bitacora, tipo: '')).to be_invalid
  end
  it "is invalid without status" do
  	expect(build(:bitacora, status: '')).to be_invalid
  end
	it "does not allow a ente_inicio with more of 250 characters" do
    expect(build(:bitacora, ente_inicio: "a"*252)).to have(1).errors_on(:ente_inicio)
  end
  it "does not allow a ente_fin with more of 250 characters" do
    expect(build(:bitacora, ente_fin: "a"*252)).to have(1).errors_on(:ente_fin)
  end
  it "does not allow a descripcion with more of 250 characters" do
    expect(build(:bitacora, descripcion: "a"*252)).to have(1).errors_on(:descripcion)
  end  
  it "validates status valid" do
    expect(build(:bitacora, status: 'PENDIENTE')).to be_valid
  end
  it "validates status valid" do
    expect(build(:bitacora, status: 'SOLUCIONADO')).to be_valid
  end
  it "validates invalid status"  do
    expect(build(:bitacora, status: 'SOLUTE')).to_not be_valid
  end
  it "validates tipo valid" do
    expect(build(:bitacora, tipo: 'AFILIACION')).to be_valid
  end
  it "validates tipo valid" do
    expect(build(:bitacora, tipo: 'DESAFILIACION')).to be_valid
  end
  it "validates tipo valid" do
    expect(build(:bitacora, tipo: 'TRASLADO')).to be_valid
  end
  it "validates tipo valid" do
    expect(build(:bitacora, tipo: 'OTROS')).to be_valid
  end
  it "validates invalid tipo"  do
    expect(build(:bitacora, tipo: 'NONE')).to_not be_valid
  end
end
