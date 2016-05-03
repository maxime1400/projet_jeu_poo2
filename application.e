note
	description : "Démarrage du jeu"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "16 février 2016"

class
	APPLICATION

inherit
	JEU

create
	make

feature {NONE} -- Constructeur

	make
		do
			game_library.enable_video
			audio_library.enable_sound
			audio_library.launch_in_thread	-- Cette fonctionnalité met à jour le contexte sonore dans un autre thread.
			image_file_library.enable_image (true, false, false)  -- Active PNG (mais pas TIF ou JPG)

			make_game
			image_file_library.quit_library
			audio_library.quit_library
			game_library.quit_library
		end
end
