note
	description : "Démarrage du jeu"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "16 février 2016"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED

create
	make_serveur,
	make_client

feature {NONE} -- Constructeur

	make_serveur
		local
			jeu: JEU
			l_serveur: SERVEUR_RESEAU
		do
			io.put_string("Serveur")
			create l_serveur.make
			l_serveur.launch
			game_library.enable_video
			audio_library.enable_sound
			audio_library.launch_in_thread	-- Cette fonctionnalité met à jour le contexte sonore dans un autre thread.
			image_file_library.enable_image (true, false, false)  -- Active PNG (mais pas TIF ou JPG)

			create jeu.make_game

			image_file_library.quit_library
			audio_library.quit_library
			game_library.quit_library
		end

	make_client
		local
			jeu: JEU
			l_client: CLIENT_RESEAU
		do
			io.put_string("Client")
			create l_client.make
			l_client.launch
			game_library.enable_video
			audio_library.enable_sound
			audio_library.launch_in_thread	-- Cette fonctionnalité met à jour le contexte sonore dans un autre thread.
			image_file_library.enable_image (true, false, false)  -- Active PNG (mais pas TIF ou JPG)

			create jeu.make_game

			image_file_library.quit_library
			audio_library.quit_library
			game_library.quit_library
		end
end
