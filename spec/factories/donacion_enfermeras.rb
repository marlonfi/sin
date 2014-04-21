# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donacion_enfermera do
  	association :enfermera
    monto "12.00"
    fecha_entrega "2014-04-20"
    motivo "MyString"
    generado_por "MyString"
    descripcion "MyText"
  end
end
