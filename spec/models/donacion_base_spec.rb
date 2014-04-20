require 'spec_helper'

describe DonacionBase do
	it "does not allow a donacion without base_id " do
   	expect(build(:donacion_basis, base_id: nil)).to be_invalid
  end
  it "does not allow a product_name without base_id " do
   	expect(build(:donacion_basis, product_name: nil)).to be_invalid
  end
  it "does not allow a donacion with a product_name lenght > 250" do
		expect(build(:donacion_basis, product_name: "a"*252)).to be_invalid
	end
	it "does not allow a donacion with a category lenght > 250" do
		expect(build(:donacion_basis, category: "a"*252)).to be_invalid
	end
	it "does not allow a donacion with a descripcion lenght > 1000" do
		expect(build(:donacion_basis, descripcion: "a"*1002)).to be_invalid
	end
	it "does not allow a donacion with a generado_por lenght > 250" do
		expect(build(:donacion_basis, generado_por: "a"*252)).to be_invalid
	end
	it "is valid release_date" do
    expect(build(:donacion_basis, release_date: '02/02/1990')).to be_valid
  end
  it "is invalid fecha_nacimiento" do
    expect(build(:donacion_basis, release_date: '02/02s/1990')).to_not be_valid
  end
end