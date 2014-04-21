require 'spec_helper'

describe DonacionEnfermera do
	it "does not allow a donacion without enfermera_id " do
   	expect(build(:donacion_enfermera, enfermera_id: nil)).to be_invalid
  end
  it "does not allow a donacion without monto" do
   	expect(build(:donacion_enfermera, monto: nil)).to be_invalid
  end
  it "does not allow a donacion without fecha_entrega" do
   	expect(build(:donacion_enfermera, fecha_entrega: nil)).to be_invalid
  end
  it "does not allow a donacion without motivo" do
   	expect(build(:donacion_enfermera, motivo: nil)).to be_invalid
  end
   it "does not allow a donacion without generado_por" do
   	expect(build(:donacion_enfermera, generado_por: nil)).to be_invalid
  end
  it "does not allow a donacion with a motivo lenght > 250" do
		expect(build(:donacion_enfermera, motivo: "a"*252)).to be_invalid
	end
	it "does not allow a donacion with a descripcion lenght > 1002" do
		expect(build(:donacion_enfermera, descripcion: "a"*1002)).to be_invalid
	end
	it "does not allow a donacion with a generado_por lenght > 250" do
		expect(build(:donacion_enfermera, generado_por: "a"*252)).to be_invalid
	end	
	it "is valid fecha_entrega" do
    expect(build(:donacion_enfermera, fecha_entrega: '02/02/1990')).to be_valid
  end
  it "is invalid fecha_entrega" do
    expect(build(:donacion_enfermera, fecha_entrega: '02/02s/1990')).to_not be_valid
  end

  it "is has a correct monto" do
    expect(build(:donacion_enfermera, monto: '1000.00')).to be_valid
  end
  it "is has a correct monto" do
    expect(build(:donacion_enfermera, monto: '1000')).to be_valid
  end
  it "is has a correct monto" do
    expect(build(:donacion_enfermera, monto: '18.23222222')).to be_valid
  end
  it "is has a correct monto" do
    expect(build(:donacion_enfermera, monto: '18.23')).to be_valid
  end
  it "is does not accep a bad format" do
    expect(build(:donacion_enfermera, monto: '-1000.00')).to_not be_valid
  end
  it "is does not accep a bad format" do
    expect(build(:donacion_enfermera, monto: '10s00.00')).to_not be_valid
  end
  it "is does not accep a bad format" do
    expect(build(:donacion_enfermera, monto: 'ds')).to_not be_valid
  end
  it "is does not accep a bad format" do
    expect(build(:donacion_enfermera, monto: '-12.23')).to_not be_valid
  end
end
