note
	description: "Class pour la cr�ature CHARIZARD"
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
			degat_3 as gerer_3, degat_4 as gerer_4
		select
			gerer_3, gerer_4
		end
	FEU
		rename
			degat_1 as gerer_1, degat_2 as gerer_2
		select
			gerer_1, gerer_2
		end

create
	create_creature

feature

	attaque_recu(a_type:INTEGER; a_degats:INTEGER)
		--	G�re une attaque faite � la cr�ature. La liste doit avoir deux cases, une pour le type, une pour les d�gats.
		do
			if not (a_degats = 0) then
				if a_type = 1 then
					soustrait_vie(gerer_1(a_degats))
				elseif a_type = 2 then
					soustrait_vie(gerer_2(a_degats))
				elseif a_type = 3 then
					soustrait_vie(gerer_3(a_degats))
				elseif a_type = 4 then
					soustrait_vie(gerer_4(a_degats))
				end
			end
		end

end
