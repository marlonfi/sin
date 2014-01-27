# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import do
    tipo_clase "MyString"
    fecha_pago "2014-01-27"
    responsable "MyString"
    archivo "MyString"
    descripcion "MyString"
    formato_org "MyString"
  end
end
