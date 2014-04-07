require 'spec_helper'

describe User do
	it 'does allow to create two users with empty emails' do
		create(:user, dni: '22345672')
    expect(build(:user, dni: '22345673')).to be_valid
	end
	it "does not allow a user with a same DNI" do
    create(:user, dni: '22345672')
    expect(build(:user, dni: '22345672')).to be_invalid
  end
  it "is invalid without DNI" do
  	expect(build(:user, dni: nil)).to be_invalid
  end
  it "is invalid without cargo" do
  	expect(build(:user, cargo: nil)).to be_invalid
  end
  it "is invalid without apellidos y nombres" do
  	expect(build(:user, apellidos_nombres: nil)).to be_invalid
  end
  it 'has a correct DNI lenght' do
  	expect(build(:user, dni: '4639908')).to be_invalid
  	expect(build(:user, dni: '463990822')).to be_invalid
  end
  it 'has a maximum lenght for cargo: 250' do
  	expect(build(:user, cargo: 'a'*255)).to be_invalid
  end
  it 'has a maximum lenght for apellidos_nombres: 250' do
  	expect(build(:user, apellidos_nombres: 'a'*255)).to be_invalid
  end
end
