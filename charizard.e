note
	description: "Class pour la créature CHARIZARD"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "15 mars 2016"

class
	CHARIZARD

inherit
	CREATURE
	VOLANT
	FEU
	DRAGON

create
	create_image

feature {NONE} -- Constructeur

	create_image
		local
			l_image: IMG_IMAGE_FILE
		do
			create l_image.make("./images/charizard.png")
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
