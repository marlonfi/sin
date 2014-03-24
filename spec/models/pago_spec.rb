require 'spec_helper'

describe Pago do

  it "is invalid without enfermera_id" do
    expect(build(:pago, enfermera_id: nil)).to have(1).errors_on(:enfermera_id)
  end
  it "is invalid without monto" do
    expect(build(:pago, monto: nil)).to have(1).errors_on(:monto)
  end
  it "is invalid without mes_cotizacion" do
    expect(build(:pago, mes_cotizacion: nil)).to have(2).errors_on(:mes_cotizacion)
  end
  it "is invalid without base" do
    expect(build(:pago, base: nil)).to have(1).errors_on(:base)
  end
  it "is invalid without generado_por" do
    expect(build(:pago, generado_por: nil)).to have(1).errors_on(:generado_por)
  end
  it "is a valid mes_cotizacion format" do
    expect(build(:pago, mes_cotizacion: '12-popd-23oif')).to have(2).errors_on(:mes_cotizacion)
  end
  
  context 'importation of pagos' do
    before(:each) do
      @archivo = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
      @archivo2 = Import.create(tipo_clase: "Pago", tipo_txt: 'NOMBRADOS Y CONTRATADOS',
                                fecha_pago: '15-10-2013',
                               archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/pagos_txt.TXT'))))
      RedAsistencial.import(@archivo)
      Ente.import(@archivo)
      Enfermera.import_essalud(@archivo)
    end
    it "creates aditional Enfermeras" do
      expect(Ente.find_by_cod_essalud('Ente_prueba')).to eq(nil)
      expect{
				Pago.import(@archivo2)
			}.to change(Enfermera, :count).by(3)
      enfermera1 = Enfermera.find_by_cod_planilla('1111111')
      expect(enfermera1.bitacoras.first.descripcion).to eq('Nueva enfermera generada por el block de notas.')
      expect(enfermera1.bitacoras.first.tipo).to eq('AFILIACION')
      expect(Ente.find_by_cod_essalud('Ente_prueba')).to_not eq(nil)
    end
    it 'afiliates a existing enfermera and generates his bitacoras' do
      enfermera1 = Enfermera.find_by_cod_planilla('5601041')
      enfermera2 = Enfermera.find_by_cod_planilla('2536669')
      ente = enfermera2.ente
      expect(enfermera1.b_sinesss).to_not be_true
      expect(enfermera2.b_sinesss).to_not be_true
      expect{
        Pago.import(@archivo2)
      }.to change(Bitacora, :count).by(26)
      enfermera1.reload
      enfermera2.reload
      expect(enfermera1.b_sinesss).to be_true
      expect(enfermera2.b_sinesss).to be_true
      expect(enfermera1.bitacoras.first.tipo).to eq('AFILIACION')
      expect(enfermera2.bitacoras.first.tipo).to eq('AFILIACION')
      expect(enfermera1.bitacoras.first.tipo).to_not eq('Nueva enfermera generada por el block de notas.')
      expect(enfermera2.ente).to eq(ente)
    end
    it "generates a bitacora 'Traslado' of an existing enfermera" do
      enfermera1 = Enfermera.find_by_cod_planilla('1513068')
      enfermera2 = Enfermera.find_by_cod_planilla('3824084')
      expect(enfermera1.ente.cod_essalud).to eq('Programa CEI')
      expect(enfermera2.ente.cod_essalud).to eq('Esc Emer Desas')
      Pago.import(@archivo2)
      enfermera1.reload
      enfermera2.reload
      expect(enfermera1.ente.cod_essalud).to eq('Org.Ctrol.Ins-RA Junin')
      expect(enfermera2.ente.cod_essalud).to eq('SG Procura')
      bitacora1 = enfermera1.bitacoras.first
      bitacora2 = enfermera2.bitacoras.first
      expect(bitacora1.tipo).to eq('TRASLADO')
      expect(bitacora2.tipo).to eq('TRASLADO')
      expect(bitacora1.ente_inicio).to eq('Programa CEI')
      expect(bitacora1.ente_fin).to eq('Org.Ctrol.Ins-RA Junin')
      expect(bitacora2.ente_inicio).to eq('Esc Emer Desas')
      expect(bitacora2.ente_fin).to eq('SG Procura')
    end
    it "afiliates an enfermera and changes her ente, also generates bitacora" do
      enfermera1 = Enfermera.find_by_cod_planilla('5118432')
      enfermera2 = Enfermera.find_by_cod_planilla('1979324')
      expect(enfermera1.ente.cod_essalud).to eq('D HII Moquegua')
      expect(enfermera2.ente.cod_essalud).to eq('H II Luis Negr')
      expect(enfermera1.b_sinesss).to_not be_true
      expect(enfermera2.b_sinesss).to_not be_true
      Pago.import(@archivo2)
      enfermera1.reload
      enfermera2.reload      
      expect(enfermera1.bitacoras.count).to eq(2)
      expect(enfermera1.ente.cod_essalud).to eq('H II Luis Negr')
      expect(enfermera2.ente.cod_essalud).to eq('D HII Moquegua')
      bitacora1 = enfermera1.bitacoras.first
      bitacora11 = enfermera1.bitacoras.last
      bitacora2 = enfermera2.bitacoras.first
      bitacora22 = enfermera2.bitacoras.last
      expect(enfermera1.b_sinesss).to be_true
      expect(enfermera2.b_sinesss).to be_true
      expect(bitacora1.tipo).to eq('AFILIACION')
      expect(bitacora11.tipo).to eq('TRASLADO')
      expect(bitacora2.tipo).to eq('AFILIACION')
      expect(bitacora22.tipo).to eq('TRASLADO')
      expect(bitacora1.ente_inicio).to eq('H II Luis Negr')
      expect(bitacora1.ente_fin).to eq('H II Luis Negr')
      expect(bitacora2.ente_inicio).to eq('D HII Moquegua')
      expect(bitacora2.ente_fin).to eq('D HII Moquegua')
      expect(bitacora22.ente_inicio).to eq('H II Luis Negr')
      expect(bitacora22.ente_fin).to eq('D HII Moquegua')
    end
	end
  context 'generation of pagos' do
    before(:each) do
      @archivo = Import.create(tipo_clase: "Enfermera",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/lista_essalud.csv'))))
      @archivo2 = Import.create(tipo_clase: "Pago", tipo_txt: 'NOMBRADOS Y CONTRATADOS',
                                fecha_pago: '15-10-2013',
                               archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/pagos_txt.TXT'))))
      @bases = Import.create(tipo_clase: "Base",
                              archivo: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
                              '/spec/factories/files/bases.csv'))))
      RedAsistencial.import(@archivo)
      Ente.import(@archivo)
      Enfermera.import_essalud(@archivo)
      Base.import_bases(@bases)
    end
    it "creates all pagos, including the Falta de pago" do
      expect{
        Pago.import(@archivo2)
      }.to change(Pago, :count).by(56)
    end
    it "creates empty pagos" do
      Pago.import(@archivo2)
      expect(Pago.por_fecha(@archivo2.fecha_pago).
            where(generado_por: 'Falta de pago').count).to eq(2)
      enfermera1 = Enfermera.find_by_cod_planilla('1449707')
      enfermera2 = Enfermera.find_by_cod_planilla('4428611')
      expect(Pago.por_fecha(@archivo2.fecha_pago).
            where(generado_por: 'Falta de pago').count).to eq(2)
      expect(enfermera1.pagos.first.monto).to eq(0.0)
      expect(enfermera2.pagos.first.monto).to eq(0.0)
    end
    it 'generates all pgos with the correct monto_total' do
      Pago.import(@archivo2)
      expect(Pago.por_fecha(@archivo2.fecha_pago).sum(:monto).to_f).to eq(1652.08)
    end
    it 'collocates the pago in the correct base' do      
      Pago.import(@archivo2)
      pago1 = Enfermera.find_by_cod_planilla('1979324').pagos.first
      pago2 = Enfermera.find_by_cod_planilla('5001461').pagos.first
      pago3 = Enfermera.find_by_cod_planilla('2439438').pagos.first
      expect(pago1.base).to eq('B-D HII Moquegua')
      expect(pago1.monto.to_f).to eq(50.89)
      expect(pago2.base).to eq('B-STAE')
      expect(pago2.monto.to_f).to eq(26.74)
      expect(pago3.base).to eq('B-D HIV Huancayo')
      expect(pago3.monto.to_f).to eq(34.50)
    end
    it 'show for pagos libres in what ente goes the payment' do
      Pago.import(@archivo2)
      pago1 = Enfermera.find_by_cod_planilla('2080335').pagos.first
      pago2 = Enfermera.find_by_cod_planilla('2222222').pagos.first
      expect(pago1.base).to eq('Pago libre')
      expect(pago1.monto.to_f).to eq(26.74)
      expect(pago1.ente_libre).to eq('PM Chancay')
      expect(pago2.base).to eq('Pago libre')
      expect(pago2.monto.to_f).to eq(29.33)
      expect(pago2.ente_libre).to eq('Ente_prueba')
    end
  end
end
