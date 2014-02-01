# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :enfermera do
    association :ente
    cod_planilla "1234567"
    apellido_paterno "Iokeroo"
    apellido_materno "Iokero Apellidos"
    nombres "Iokero Nombre"
    full_name "Iokero Iokero Iokero"
    email "ola@ase.com"
    regimen "CAS"
    b_sinesss true
    b_fedcut false
    b_famesalud false
    b_excel false
    factory :invalid_enfermera do
      cod_planilla "a"*8
      apellido_paterno ''
      apellido_materno ''
      nombres ''
      
    end
  end
end
