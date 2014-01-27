class Import < ActiveRecord::Base
	mount_uploader :archivo, ArchivoUploader
end
