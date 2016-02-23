note
	description: "Class qui génère une image"
	auteur		: "Steve Duquet"
	date        : "23 février 2016"

class
	IMAGE

create
	creer_image

feature {NONE} -- Initialization

	creer_image (a_nom_fichier:STRING)
		local
			l_image: IMG_IMAGE_FILE
		do
			create l_image.make (a_nom_fichier)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					GAME_SURFACE.make_from_image (l_image)
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
