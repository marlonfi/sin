# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user do
  	email nil
    password '1234abcd'
    password_confirmation '1234abcd'
    dni '46399081'
    apellidos_nombres 'Paez Chavez Wenceslao'
    cargo 'Secretario General'
		factory :superadmin do
    	superadmin true
    end
    factory :banned_user do
    	desabilitado true
    end
  end
end
