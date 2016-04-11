note
	description: "Class de base pour une créature du jeu"
	author: "Steve Duquet & Maxime Laflamme"
	date: "15 mars 2016"

class
	CREATURE

create
	create_creature

feature --constructeur

	create_creature(a_vie:INTEGER)
		-- constructeur
		do
			vie:= a_vie
		end

feature -- accès

	get_vie:INTEGER
		-- retourne le nombre restant de vie de la créature
		do
			result:= vie
		end

	set_vie(a_degats:INTEGER)
		-- soustrait la vie par l'argument envoyé
		do
			vie:= vie - a_degats
			if vie < 0 then
				vie:= 0
			end
		ensure
			vie_minimum: vie >= 0
		end

	attaque_recu(a_attaque:ARRAY[INTEGER])
		--	Gère une attaque faite à la créature. La liste doit avoir deux cases, une pour le type, une pour les dégats.
		require
			longeur_array: a_attaque.count >= 2
		do
			set_vie(a_attaque[1])
		end

feature -- variables

	vie: INTEGER

end
