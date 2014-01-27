class Import < ActiveRecord::Base
	mount_uploader :archivo, ArchivoUploader
	validates_presence_of :tipo_clase
	validates_presence_of :archivo
end
