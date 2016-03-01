note
	description : "Moteur principal du jeu"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "16 février 2016"

class
	IMAGE

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
