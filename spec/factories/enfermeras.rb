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
    sexo 'MASCULINO'
    factor_sanguineo 'iontknow'
    fecha_nacimiento  '02/02/1990'
    domicilio_completo 'ola ola'
    telefono '222223'
    fecha_inscripcion_sinesss '02/02/1990'
    fecha_ingreso_essalud '02/02/1990'
    regimen "CAS"
    dni '46399081'
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
