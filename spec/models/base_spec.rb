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
  
	it "imports the bases" 
end
