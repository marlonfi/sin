# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pago do
    association :enfermera
    monto  '25.06'
    mes_cotizacion  '15-06-2014'
    base 'B-H II Sabogal'
    generado_por 'Archivo'
    ente_libre 'libre'
  end
end
