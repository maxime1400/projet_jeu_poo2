note
	description: "Class serveur du jeu"
	auteur		: "Steve Duquet"
	date        : "3 mai 2016"

class
	CLIENT_RESEAU

inherit
	THREAD
	rename
		make as make_thread
	end

create
	make

feature {NONE} -- Constructeur

	make
		-- Ex�cute la m�thode d'�coute du r�seau dans un thread
		do
			make_thread
			must_stop:= false
		end

feature --Acc�s

	stop_thread
		-- Change la variable qui arr�te la boucle de la class
		do
			must_stop:= true
		end

feature {NONE} -- M�thodes du thread

	execute
		-- �coute sur le r�seau
		local
			l_addr_factory:INET_ADDRESS_FACTORY
			l_address: INET_ADDRESS
			l_socket:NETWORK_STREAM_SOCKET
		do
			create l_addr_factory
			if attached l_addr_factory.create_from_name ("localhost") as la_address then
				create l_socket.make_client_by_address_and_port (la_address, 1234)
				l_socket.connect
				from
				until
					must_stop
					loop
					l_socket.put_string ("Bonjour Serveur!%N")
					l_socket.read_stream(50)
					io.put_string ("Le serveur a dit: ")
					io.put_string (l_socket.last_string)
					io.put_new_line
				end
				l_socket.close
			end

		end

feature {NONE} -- Impl�mentation

	must_stop: BOOLEAN
		-- variable qui arr�te la boucle de la class si True

	message_recu: INTEGER
		-- Le chiffre re�u du r�seau

end
