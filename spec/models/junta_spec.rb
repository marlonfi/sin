require 'spec_helper'

describe Junta do
  it "is valid with base_id & secretaria & inici & fin de gestion" do
  	expect(create(:juntum)).to be_valid
  end
  it "is valid with inici & fin de gestion format" do
  	expect(create(:juntum, inicio_gestion: '02/02/1990')).to be_valid
  end
  it "is invalid without  secre general" do
  	expect(build(:juntum, secretaria_general: '')).to have(1).errors_on(:secretaria_general)
  end
  it "is invalid without base_id" do
  	expect(build(:juntum, base_id: '')).to have(1).errors_on(:base_id)
  end
  it "is invalid without fin_gestion" do
  	expect(build(:juntum, fin_gestion: '')).to have(2).errors_on(:fin_gestion)
  end
  it "is invalid without inicio_gestion " do
  	expect(build(:juntum, inicio_gestion: '')).to have(2).errors_on(:inicio_gestion)
  end
  it "validates format of email" do
		expect(build(:juntum, email: 'asdsads.com')).to have(1).errors_on(:email)
	end
	it "validates lenght of email" do
		expect(build(:juntum, email: 'a'*255+'@dsadsaa.com')).to have(1).errors_on(:email)
	end
	it "does not allow a secretaria_general with more of 250 characters" do
    expect(build(:juntum, secretaria_general: "a"*252)).to have(1).errors_on(:secretaria_general)
  end
  it "does not allow a numero_celular with more of 250 characters" do
    expect(build(:juntum, numero_celular: "a"*252)).to have(1).errors_on(:numero_celular)
  end
  it "does not allow a :descripcion with more of 1020 characters" do
    expect(build(:juntum, descripcion: "a"*1024)).to have(1).errors_on(:descripcion)
  end
  it "does not allow a fecha inicio with bad format" do
    expect(build(:juntum, inicio_gestion: "a fd")).to have(2).errors_on(:inicio_gestion)
  end
  it "does not allow a :fecha fin with bad format" do
    expect(build(:juntum, fin_gestion: "addd df")).to have(2).errors_on(:fin_gestion)
  end
  it "validates status in VIGENTE" do
    expect(build(:juntum, status: 'VIGENTE')).to be_valid
  end
  it "validates status in FINALIZADO" do
    expect(build(:juntum, status: 'FINALIZADO')).to be_valid
  end
  it "validates bad status" do
    expect(build(:juntum, status: 'FINALO')).to be_invalid
  end
  it 'import juntas'
end

