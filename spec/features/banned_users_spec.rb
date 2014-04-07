#encoding: utf-8
require "spec_helper"

feature 'Loggeando usuarios' do
	background do
		@user1 = create(:user, dni: '46399081')
		@user2 = create(:banned_user, dni: '46399082')
		visit root_path
	end
	scenario "A banned user tries to sign in" do
		fill_in 'user[dni]', with: '46399082'
		fill_in 'user[password]', with: '1234abcd'
		click_button('Ingresar')
		expect(page).to have_content 'Usuario deshabilitado'
	end
	scenario 'A not banned user tries to sign in' do
		fill_in 'user[dni]', with: '46399081'
		fill_in 'user[password]', with: '1234abcd'
		click_button('Ingresar')
		expect(page).to have_content @user2.apellidos_nombres
	end
end
