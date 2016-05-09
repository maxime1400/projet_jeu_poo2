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
		-- reçoit un nombre `a_vie' qui représente le nombre de points de vie de la créature
		do
			vie:= a_vie
		end

feature -- accès

	set_vie(a_vie:INTEGER)
		-- set le nombre restant de vie de la créature
		do
			vie:=a_vie
		end

	soustrait_vie(a_degats:INTEGER)
		-- soustrait `vie' par l'argument envoyé
		do
			vie:= vie - a_degats
			if vie < 0 then
				vie:= 0
			end
		ensure
			vie_minimum: vie >= 0
		end

	attaque_recu(a_type:INTEGER; a_degats:INTEGER)
		--	Gère une attaque faite à la créature.
		--  La liste doit avoir deux cases, une pour le type, une pour les dégats.
		do
			soustrait_vie(a_degats)
		end

feature -- variables

	vie: INTEGER
		-- nombre représentant la quantité de points de vie d'une créature

end
