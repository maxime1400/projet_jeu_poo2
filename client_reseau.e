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
		do
			make_thread
			must_stop:= false
		end

feature --Acc�s

	stop_thread
		do
			must_stop:= true
		end

feature {NONE} --m�thodes du thread

	execute
		local
			l_addr_factory:INET_ADDRESS_FACTORY
			l_address: INET_ADDRESS
			l_socket:NETWORK_STREAM_SOCKET
		do

			from
			until
				must_stop
			loop
				create l_addr_factory
				--l_address:= l_addr_factory.create_from_name ("localhost")
				--create l_socket.make_client_by_address_and_port (l_address, 12345)
				--l_socket.connect
				--l_socket.put_integer (10)
				--l_socket.read_line
				--message_recu:= l_socket.last_integer
			end
			--l_socket.close
		end

feature {NONE} -- Impl�mentation

	must_stop: BOOLEAN
	message_recu: INTEGER

end
