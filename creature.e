note
	description: "Class de base pour une cr�ature du jeu"
	author: "Steve Duquet & Maxime Laflamme"
	date: "15 mars 2016"

class
	CREATURE

create
	create_creature

feature --constructeur

	create_creature(a_vie:INTEGER)
		-- re�oit un nombre `a_vie' qui repr�sente le nombre de points de vie de la cr�ature
		do
			vie:= a_vie
		end

feature -- acc�s

	set_vie(a_vie:INTEGER)
		-- set le nombre restant de vie de la cr�ature
		do
			vie:=a_vie
		end

	soustrait_vie(a_degats:INTEGER)
		-- soustrait `vie' par l'argument envoy�
		do
			vie:= vie - a_degats
			if vie < 0 then
				vie:= 0
			end
		ensure
			vie_minimum: vie >= 0
		end

	attaque_recu(a_type:INTEGER; a_degats:INTEGER)
		--	G�re une attaque faite � la cr�ature.
		--  La liste doit avoir deux cases, une pour le type, une pour les d�gats.
		do
			soustrait_vie(a_degats)
		end

feature -- variables

	vie: INTEGER
		-- nombre repr�sentant la quantit� de points de vie d'une cr�ature

end
