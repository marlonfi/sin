class CreateEnvioEmails < ActiveRecord::Migration
  def change
    create_table :envio_emails do |t|
      t.date :fecha_envio
      t.date :ultimo_mes_enviado
      t.integer :emails_enviados
      t.integer :emails_no_enviados
      t.string :generado_por
      t.integer :acumulado
      t.string :status

      t.timestamps
    end
  end
end
