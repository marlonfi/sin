# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  
  factory :red_asistencial do
    cod_essalud "RA Almenara"
    nombre ""
    contacto_nombre ""
    contacto_telefono ""
  
    factory :invalid_red_asistencial do
      cod_essalud "a"*255
    end
  end

end
