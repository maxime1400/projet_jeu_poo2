note
	description		: "Moteur principal d'un combat"
	auteur			: "Steve Duquet et Maxime Laflamme"
	date			: "21 mars 2016"

class
	COMBAT

create
	make_combat

feature {NONE} -- Constructeur

	make_combat
		-- Création des paramètres de base d'un jeu
		do
			io.put_string("Début d'un combat!!! Bravo!!!")
		end

end
