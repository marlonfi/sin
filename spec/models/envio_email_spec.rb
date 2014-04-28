require 'spec_helper'

describe EnvioEmail do
	it "does not allow a envioemail without fecha_envio " do
   	expect(build(:envio_email, fecha_envio: nil)).to be_invalid
  end
  it "does not allow a envioemail without ultimo_mes_enviado " do
   	expect(build(:envio_email, ultimo_mes_enviado: nil)).to be_invalid
  end
  it "does not allow a envioemail without emails_enviados " do
   	expect(build(:envio_email, emails_enviados: nil)).to be_invalid
  end
  it "does not allow a envioemail without emails_no_enviados " do
   	expect(build(:envio_email, emails_no_enviados: nil)).to be_invalid
  end
  it "does not allow a envioemail without generado_por " do
   	expect(build(:envio_email, generado_por: nil)).to be_invalid
  end
  it "does not allow a generado_por with more of 250 characters" do
    expect(build(:envio_email, generado_por: "a"*252)).to be_invalid
  end
  it "is valid fecha_envio" do
    expect(build(:envio_email, fecha_envio: '02/02/1990')).to be_valid
  end
  it "is invalid fecha_envio" do
    expect(build(:envio_email, fecha_envio: '02/02s/1990')).to_not be_valid
  end
  it "is valid ultimo_mes_enviado" do
    expect(build(:envio_email, ultimo_mes_enviado: '02/02/1990')).to be_valid
  end
  it "is invalid ultimo_mes_enviado" do
    expect(build(:envio_email, ultimo_mes_enviado: '02/02s/1990')).to_not be_valid
  end
end
