note
	description: "Class pour la créature CHARIZARD"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "15 mars 2016"

class
	CHARIZARD

inherit
	CREATURE
		redefine
			attaque_recu
		end
	VOLANT
		rename
			degat_3 as gerer_epee
		select
			gerer_epee
		end
	FEU
		rename
			degat_1 as gerer_feu, degat_2 as gerer_glace, degat_4 as gerer_roche
		select
			gerer_feu, gerer_glace, gerer_roche
		end

create
	create_creature

feature

	attaque_recu(a_type:INTEGER; a_degats:INTEGER)
		--	Gère une attaque faite à la créature. La liste doit avoir deux cases, une pour le type, une pour les dégats.
		do
			if not (a_degats = 0) then
				if a_type = 1 then
					soustrait_vie(gerer_feu(a_degats))
				elseif a_type = 2 then
					soustrait_vie(gerer_glace(a_degats))
				elseif a_type = 3 then
					soustrait_vie(gerer_epee(a_degats))
				elseif a_type = 4 then
					soustrait_vie(gerer_roche(a_degats))
				end
			end
		end

end
