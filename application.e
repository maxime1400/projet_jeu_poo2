note
	description : "D�marrage du jeu"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "16 f�vrier 2016"

class
	APPLICATION

inherit
	JEU

create
	make

feature {NONE} -- Constructeur

	make
		do
			make_game
			image_file_library.quit_library
			audio_library.quit_library
			game_library.quit_library
		end
end
