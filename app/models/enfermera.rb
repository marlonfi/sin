class Enfermera < ActiveRecord::Base
	belongs_to :ente
  before_validation :generar_full_name
  before_save :generar_full_name
	validates :cod_planilla, length: { is: 7 }
	validates_presence_of :ente_id, :apellido_paterno, :apellido_materno,
												:nombres, :full_name
  validates_inclusion_of :b_sinesss, :in => [true, false]                      
  validates_uniqueness_of :cod_planilla
  validates :email, length: { maximum: 250 }
  validate  :email_regex

  validates :nombres, length: { maximum: 250 }
  validates :apellido_paterno, length: { maximum: 250 }
  validates :apellido_materno, length: { maximum: 250 }
  validates :factor_sanguineo, length: { maximum: 250 }
  validates :domicilio_completo, length: { maximum: 250 }
  validates :telefono, length: { maximum: 250 }

  validates_length_of :dni, :is => 8, :allow_blank => true

  validates_date :fecha_nacimiento, :fecha_inscripcion_sinesss, :fecha_ingreso_essalud,
                 :allow_blank => true

  validates_inclusion_of :regimen, :in => ['CONTRATADO', 'CAS', 'NOMBRADO']
  validates_inclusion_of :sexo, :in => ['MASCULINO', 'FEMENINO'], :allow_blank => true
 	#para enfermeras  
  scope :sin_sindicato, -> { where(b_sinesss: false, b_fedcut:false, b_famesalud:false) }
  scope :total_sinesss, -> { where(b_sinesss: true) }
  scope :solo_sinesss, -> { total_sinesss.where(b_fedcut: false, b_famesalud:false)}
  scope :solo_fedcut, -> { where(b_sinesss: false, b_fedcut:true, b_famesalud:false)}
  scope :solo_famesalud, -> { where(b_sinesss: false, b_fedcut:false, b_famesalud:true)}
  scope :triple_afiliacion, -> { total_sinesss.where(b_fedcut: true, b_famesalud:true)}
  scope :sinesss_and_fedcut, -> { total_sinesss.where(b_fedcut:true, b_famesalud:false) }
  scope :sinesss_and_famesalud, -> { total_sinesss.where(b_famesalud:true, b_fedcut:false) }
  #para ente_enfermeras
  scope :afiliados_sinesss_por_ente, ->(ente_id) { where("ente_id = ? AND b_sinesss = ?", ente_id, true) }
  scope :no_afiliados_sinesss_por_ente, ->(ente_id) { where("ente_id = ? AND b_sinesss = ?", ente_id, false) }
  #contar_por_ente
  scope :por_ente, ->(ente_id) { where("ente_id = ?", ente_id) }

  #actualizar datos con excel
  def self.import_data_actualizada(import)
    begin
      import.update_attributes(status: 'PROCESANDO')
      path = import.archivo.path
      CSV.foreach(path, headers: true) do |row|
        data_enfermera = parse_actualizacion(row)
        enfermera = Enfermera.find_by_cod_planilla(data_enfermera[:cod_planilla])
        if enfermera
          hola = enfermera.update_attributes(data_enfermera)
        end    
      end
      import.update_attributes(status: 'IMPORTADO')
    rescue
      import.update_attributes(status: 'ERROR')
    end
  end

  #importar matriz de essalud
  def self.import_essalud(import)
    begin
      import.update_attributes(status: 'PROCESANDO')
      path = import.archivo.path
      CSV.foreach(path, headers: true) do |row|
        data_enfermera, data_trabajo = parse_row(row)
        ente = Ente.get_ente(data_trabajo, data_enfermera[:regimen])
        crear_enfermera(ente, data_enfermera) if ente      
      end
      import.update_attributes(status: 'IMPORTADO')
    rescue
      import.update_attributes(status: 'ERROR')
    end
  end

  def self.crear_enfermera(ente, data_enfermera)
    enfermera = Enfermera.find_by_cod_planilla(data_enfermera[:cod_planilla])
    if enfermera
      if enfermera.b_sinesss != data_enfermera[:b_sinesss]
        generar_bitacora(enfermera, data_enfermera[:b_sinesss])
      end
      enfermera.update_attributes(regimen: data_enfermera[:regimen], b_sinesss: data_enfermera[:b_sinesss],
                                 b_fedcut: data_enfermera[:b_fedcut], b_famesalud: data_enfermera[:b_famesalud],
                                 b_excel: data_enfermera[:b_excel])
    else
      ente.enfermeras.create!(data_enfermera)
    end
  end

  def self.generar_bitacora(enfermera, condicion_actual)
    #codigo para generar la bitacora de cambio en el campo sinesss
  end

  def self.parse_actualizacion(row)
    data_enfermera = {}
    data_enfermera[:cod_planilla] = row['COD_PLANILLA'] if row['COD_PLANILLA']
    data_enfermera[:apellido_paterno] = row['APELLIDO_PATERNO'] if row['APELLIDO_PATERNO']
    data_enfermera[:apellido_materno] = row['APELLIDO_MATERNO'] if row['APELLIDO_MATERNO']
    data_enfermera[:nombres] = row['NOMBRES'] if row['NOMBRES']
    data_enfermera[:email] = row['EMAIL'] if row['EMAIL']
    data_enfermera[:dni] = row['DNI'] if row['DNI']
    data_enfermera[:sexo] = row['SEXO'] if row['SEXO']
    data_enfermera[:telefono] = row['TELEFONO'] if row['TELEFONO']
    data_enfermera[:fecha_nacimiento] = row['FECHA_NACIMIENTO'] if row['FECHA_NACIMIENTO']
    data_enfermera[:factor_sanguineo] = row['FACTOR_SANGUINEO'] if row['FACTOR_SANGUINEO']
    data_enfermera[:domicilio_completo] = row['DOMICILIO_COMPLETO'] if row['DOMICILIO_COMPLETO']
    data_enfermera[:fecha_inscripcion_sinesss] = row['FECHA_INSCRIPCION_SINESSS'] if row['FECHA_INSCRIPCION_SINESSS']
    data_enfermera[:regimen] = row['REGIMEN'] if row['REGIMEN']
    return data_enfermera
  end

  def self.parse_row(row)
    data_enfermera = {}
    data_trabajo = {}
    #para enfermera
    data_enfermera[:full_name] = row['APELLIDOS Y NOMBRES']
    data_enfermera[:fecha_ingreso_essalud] = row['FECHA INGR.']
    ap_nombres = data_enfermera[:full_name].split
    data_enfermera[:apellido_paterno] = ap_nombres[0]
    data_enfermera[:apellido_materno] = ap_nombres[1]
    data_enfermera[:nombres] = ap_nombres[2..-1].join(' ')
    data_enfermera[:cod_planilla] = row['CODIGO']
    data_enfermera[:regimen] = check_regimen(row['CONDICION'])
    data_enfermera[:b_sinesss] = (row['SINESSS'] == 'X')
    data_enfermera[:b_fedcut] = (row['FED-CUT'] == 'X')
    data_enfermera[:b_famesalud] = (row['FAMENSSALUD'] == 'X')
    data_enfermera[:b_excel] = true
    #para trabajo
    data_trabajo[:programa] = row['PROGRAMA']
    data_trabajo[:sub_programa] = row['SUB PROGRA']
    data_trabajo[:actividad] = row['ACTIVIDAD']
    data_trabajo[:sub_actividad1] = row['SUB ACTIV1']
    return data_enfermera,data_trabajo
  end 

 	private

  def self.check_regimen(regimen)
    if regimen[0..2] == 'CAS'
      'CAS'
    elsif regimen[0..2] == 'CON'
      'CONTRATADO'
    elsif regimen[0..2] == 'NOM'
      'NOMBRADO'
    end
  end

 	def email_regex
    if email.present? and not email.match(/\A[^@]+@[^@]+\z/)
      errors.add :email, "formato incorrecto"
    end
  end

  def generar_full_name
    self.full_name = self.apellido_paterno + ' ' + self.apellido_materno + ' ' +
                     self.nombres
  end
  
end