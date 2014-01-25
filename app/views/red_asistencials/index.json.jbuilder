json.array!(@red_asistencials) do |red_asistencial|
  json.extract! red_asistencial, :id, :cod_essalud, :nombre, :contacto_nombre, :contacto_telefono
  json.url red_asistencial_url(red_asistencial, format: :json)
end
