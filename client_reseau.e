note
	description: "Class serveur du jeu"
	auteur		: "Steve Duquet"
	date        : "3 mai 2016"
	EIS: "name=Unnamed", "protocol=URI", "src=http://www.yourwebsite.com"

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
		do
			make_thread
			must_stop:= false
		end

feature --Accès

	stop_thread
		do
			must_stop:= true
		end

feature {NONE} --méthodes du thread

	execute
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

feature {NONE} -- Implémentation

	must_stop: BOOLEAN
	message_recu: INTEGER

end
