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
		-- Cr�ation des param�tres de base d'un jeu
		do
			io.put_string("D�but d'un combat!!! Bravo!!!")
		end

end
