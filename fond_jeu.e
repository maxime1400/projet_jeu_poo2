note
	description		: "Le fond d'écran principal du programme"
	original		: "desert.e"
	auteur			: "Louis Marchand"
	date			: "1er avril 2015"
	source			: "https://github.com/tioui/Eiffel_Game2.git"
	modification	: "Steve Duquet et Maxime Laflamme"

class
	FOND_JEU

inherit
	GAME_SURFACE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Constructeur

	default_create
		local
			l_image: IMG_IMAGE_FILE
		do
			create l_image.make("./images/terrain.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					make_from_image (l_image)
				else
					has_error := True
					make(1,1)
				end
			else
				has_error := True
				make(1,1)
			end
		end

end
