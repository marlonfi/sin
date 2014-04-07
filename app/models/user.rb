class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_uniqueness_of :dni
  validates_presence_of :apellidos_nombres, :dni, :cargo
  validates :dni, length: { is: 8 }
  validates :cargo, length: { maximum: 250 }
  validates :apellidos_nombres, length: { maximum: 250 }
  def email_required?
  	false
	end
end
