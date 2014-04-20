# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donacion_basis, :class => 'DonacionBase' do
  	association :base
    product_name "MyString"
    category "MyString"
    release_date "2014-04-19"
    descripcion "MyText"
    generado_por "MyString"
  end
end
