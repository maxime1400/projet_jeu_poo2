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
			l_client_socket: NETWORK_STREAM_SOCKET
		do
			create l_serveur_socket.make_server_by_port (1234)
			from
			until
				must_stop
			loop
				l_serveur_socket.listen (1)
				l_serveur_socket.accept
				--l_client_socket:= l_serveur_socket.accepted
				--l_client_socket.read_line
				--message_recu:= l_client_socket.last_integer
			end
			--l_client_socket.close
			l_serveur_socket.close
		end

feature {NONE} -- Implémentation

	must_stop: BOOLEAN
	message_recu: INTEGER

end
