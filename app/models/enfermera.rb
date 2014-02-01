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
  validates_inclusion_of :regimen, :in => ['CONTRATADO', 'CAS', 'NOMBRADO']

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


  def self.import_essalud(import)
    path = import.archivo.path
    CSV.foreach(path, headers: true) do |row|
      data_enfermera, data_trabajo = parse_row(row)
      if data_trabajo[:programa] == 'SALUD'
        if data_trabajo[:sub_programa][0..2] == 'RA '
          case data_trabajo[:actividad]
          when 'Ger.Red Asist.'
            ente = Ente.find_by_cod_essalud("Ger.Red Asist."+"-"+ data_trabajo[:sub_programa])
            crear_enfermera(ente, data_enfermera) if ente
          when 'Dir.Red Asist'
            ente = Ente.find_by_cod_essalud("Dir.Red Asist"+"-"+ data_trabajo[:sub_programa])
            crear_enfermera(ente, data_enfermera) if ente
          when 'Dir.Red Asist.'
            ente = Ente.find_by_cod_essalud("Dir.Red Asist"+"-"+ data_trabajo[:sub_programa])
            crear_enfermera(ente, data_enfermera) if ente
          else
            if data_trabajo[:actividad] == 'PM San Miguel'
              ente = Ente.find_by_cod_essalud("PM San Miguel"+"-"+ data_trabajo[:sub_programa])
              crear_enfermera(ente, data_enfermera) if ente               
            else
              ente = Ente.find_by_cod_essalud(data_trabajo[:actividad])
              crear_enfermera(ente, data_enfermera) if ente 
            end
          end
        elsif data_trabajo[:sub_programa] == 'INCOR'
          ente = Ente.find_by_cod_essalud(data_trabajo[:sub_programa])
          crear_enfermera(ente, data_enfermera) if ente 
        elsif data_trabajo[:sub_programa] == 'CN Salud Rena'
          ente = Ente.find_by_cod_essalud(data_trabajo[:sub_programa])
          crear_enfermera(ente, data_enfermera) if ente
        elsif data_trabajo[:sub_programa] == 'Programa CEI'
          ente = Ente.find_by_cod_essalud(data_trabajo[:sub_programa])
          crear_enfermera(ente, data_enfermera) if ente
        elsif data_trabajo[:sub_programa] == 'Def.del Asegu'
          ente = Ente.find_by_cod_essalud('Def.del Asegu' +'-'+ data_trabajo[:sub_actividad1])
          crear_enfermera(ente, data_enfermera) if ente          
        elsif data_trabajo[:sub_programa] == 'GC Pre.Soc.y'
          ente = Ente.find_by_cod_essalud('GC Pre.Soc.y' +'-'+ data_trabajo[:sub_actividad1])
          crear_enfermera(ente, data_enfermera) if ente
        elsif data_trabajo[:sub_programa] == 'Org.Ctrol.Ins'
          ente = Ente.find_by_cod_essalud('Org.Ctrol.Ins' +'-'+ data_trabajo[:actividad])
          crear_enfermera(ente, data_enfermera) if ente    
        elsif data_trabajo[:sub_programa] == 'GC Prest Salu'
          if data_trabajo[:sub_actividad1] == 'Despacho'
            ente = Ente.find_by_cod_essalud('Despacho-GCPS')
          else
            ente = Ente.find_by_cod_essalud(data_trabajo[:sub_actividad1])
          end
          crear_enfermera(ente, data_enfermera) if ente 
        end          
      else
        ente = Ente.find_by_cod_essalud('AFESSALUD')
        if ente
          crear_enfermera(ente, data_enfermera) if ente
        end
      end           
    end
  end




  def self.crear_enfermera(ente, data_enfermera)
    enfermera = Enfermera.find_by_cod_planilla(data_enfermera[:cod_planilla])
    if enfermera
      if enfermera.b_sinesss != data_enfermera[:b_sinesss]
        generar_bitacora(enfermera, data_enfermera[:b_sinesss])
      end
      enfermera.update_attributes(regimen: data_enfermera[:regimen], b_sinesss: data_enfermera[:b_sinesss],
                                 b_fedcut: data_enfermera[:b_fedcut], b_famesalud: data_enfermera[:b_famesalud])
    else
      ente.enfermeras.create!(data_enfermera)
    end
  end

  def self.generar_bitacora(enfermera, condicion_actual)
    #codigo para generar la bitacora de cambio en el campo sinesss
  end

  def self.parse_row(row)
    data_enfermera = {}
    data_trabajo = {}
    #para enfermera
    data_enfermera[:full_name] = row['APELLIDOS Y NOMBRES']
    ap_nombres = data_enfermera[:full_name].split
    data_enfermera[:apellido_paterno] = ap_nombres[0]
    data_enfermera[:apellido_materno] = ap_nombres[1]
    data_enfermera[:nombres] = ap_nombres[2..-1].join(' ')
    data_enfermera[:cod_planilla] = row['CODIGO']  
    data_enfermera[:regimen] = row['CONDICION']
    data_enfermera[:b_sinesss] = (row['SINESSS'] == 'X')
    data_enfermera[:b_fedcut] = (row['FED-CUT'] == 'X')
    data_enfermera[:b_famesalud] = (row['FAMENSSALUD'] == 'X')
    #para trabajo
    data_trabajo[:programa] = row['PROGRAMA']
    data_trabajo[:sub_programa] = row['SUB PROGRA']
    data_trabajo[:actividad] = row['ACTIVIDAD']
    data_trabajo[:sub_actividad1] = row['SUB ACTIV1']
    return data_enfermera,data_trabajo
  end 

 	private
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