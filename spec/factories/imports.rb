# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :import, :class => 'Import' do
    status 'ESPERA'
    tipo_clase 'Enfermeras'
    formato_org 'ESSALUD'
    archivo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                        			'/spec/factories/files/lista_essalud.csv')))
    descripcion 'Sin Descripcion'
  end
end
