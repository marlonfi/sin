# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ente do
    association :red_asistencial
    contacto_nombre  'Marlon'
    contacto_numero  '9847238211'
    cod_essalud "H II Sabogal"
    factory :invalid_ente do
      cod_essalud "a"*255
    end
  end
end
