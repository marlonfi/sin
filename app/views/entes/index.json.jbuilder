json.array!(@entes) do |ente|
  json.extract! ente, :id, :red_asistencial_id, :base_id, :cod_essalud, :nombre, :contacto_nombre, :contacto_numero, :direccion, :latitud, :longitud
  json.url ente_url(ente, format: :json)
end
