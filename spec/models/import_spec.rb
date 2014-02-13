require 'spec_helper'

describe Import do
  it "is invalid without status" do
  	expect(build(:import, status: '')).to have(2).errors_on(:status)
  end
  it "is invalid without archivo" do
  	expect(build(:import, archivo: '')).to have(1).errors_on(:archivo)
  end
  it "is invalid without tipo_clase" do
  	expect(build(:import, tipo_clase: '')).to have(2).errors_on(:tipo_clase)
  end
  it "is invalid without formato_org " do
  	expect(build(:import, formato_org: '')).to have(2).errors_on(:formato_org)
  end
  it "is a valid status" do
		expect(build(:import, status: 'ESPERA')).to be_valid
		expect(build(:import, status: 'PROCESANDO')).to be_valid
		expect(build(:import, status: 'IMPORTADO')).to be_valid
		expect(build(:import, status: 'ERROR')).to be_valid
		expect(build(:import, status: 'EN COLA')).to_not be_valid
		expect(build(:import, status: 'WAT')).to_not be_valid
	end

	it "validates regimen in tipo_clase" do
		expect(build(:import, tipo_clase: 'Enfermeras')).to be_valid
		expect(build(:import, tipo_clase: 'Redes Asistenciales')).to be_valid
		expect(build(:import, tipo_clase: 'Entes')).to be_valid
		expect(build(:import, tipo_clase: 'Juntas')).to be_valid
		expect(build(:import, tipo_clase: 'Bases')).to be_valid
		expect(build(:import, tipo_clase: 'Pagos')).to be_valid
		expect(build(:import, tipo_clase: 'Payment')).to_not be_valid
	end
	it "validates regimen in formato_org" do
		expect(build(:import, formato_org: 'ESSALUD')).to be_valid
		expect(build(:import, formato_org: 'SINESSS')).to be_valid
		expect(build(:import, formato_org: 'ESSINESSS')).to_not be_valid
	end

end
