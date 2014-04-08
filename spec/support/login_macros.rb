module LoginMacros
	def loguear(dni,password)
		visit root_path
		fill_in 'user[dni]', with: dni
		fill_in 'user[password]', with: password
		click_button('Ingresar')
	end
	def cerrar_sesion
		click_link 'Cerrar Sesión'
	end
end
