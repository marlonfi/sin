# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :import, :class => 'Import' do
    status 'ESPERA'
    tipo_clase 'Enfermeras'
    tipo_txt 'CAS'
    formato_org 'ESSALUD'
    fecha_pago ''
    archivo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        			'/spec/factories/files/lista_essalud.csv')))
    descripcion 'Sin Descripcion'
  end
end
