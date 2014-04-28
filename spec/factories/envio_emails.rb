# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :envio_email do
    fecha_envio "2014-04-27"
    ultimo_mes_enviado "2014-04-27"
    emails_enviados 1
    emails_no_enviados 1
    generado_por "MyString"
    acumulado 1
    status 'PROCESANDO'
  end
end
