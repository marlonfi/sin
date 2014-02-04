# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :juntum, :class => 'Junta' do
    association :base
    secretaria_general "Iokero General"
    inicio_gestion "2014-02-03"
    fin_gestion "2014-02-03"
    numero_celular "MyString"
    email "MyString@fdfd.com"
    descripcion "MyText"
    status "VIGENTE"
  end
end
