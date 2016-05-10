note
	description: "Class serveur du jeu"
	auteur		: "Steve Duquet"
	date        : "3 mai 2016"

class
	SERVEUR_RESEAU

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
			l_serveur_socket: NETWORK_STREAM_SOCKET
		do
			create l_serveur_socket.make_server_by_port (1234)
			l_serveur_socket.listen (1)
			l_serveur_socket.accept
			from
			until
				must_stop
			loop
				l_serveur_socket.read_stream
				io.put_string ("Le client a dit: ")
				io.put_string (l_serveur_socket.last_string)
			end
			l_serveur_socket.close
		end

feature {NONE} -- Implémentation

	must_stop: BOOLEAN
	message_recu: INTEGER

end
