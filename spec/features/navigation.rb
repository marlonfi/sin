#encoding: utf-8
require "spec_helper"

feature "Aside Navigation bar" do
	scenario "toggles display organizationals links", js: true do
		visit dashboard_path
		expect(page).to_not have_content 'Redes Asistenciales'
		expect(page).to_not have_content 'Enfermeras'
		click_link 'Organizacional'
		click_link 'Organizacional'
		expect(page).to_not have_content 'Redes Asistenciales'
		expect(page).to_not have_content 'Enfermeras'
	end
end
