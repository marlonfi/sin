# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :bitacora do
    association :enfermera
    tipo "AFILIACION"
    association :import
    status "PENDIENTE"
    ente_inicio "Ente1"
    ente_fin "Ente2"
  end
end
