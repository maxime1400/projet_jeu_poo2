note
	description: "Class avec les routines propres � une cr�ature de type VOLANT"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "15 mars 2016"

class
	VOLANT

inherit
	TYPE_CREATURE
		redefine
			degat_1, degat_2, degat_3, degat_4
		end

feature

	degat_1(a_degats:INTEGER):INTEGER
		--	Modifie les d�gats de type feu re�u
		do
			result:= a_degats * 4
		end

	degat_2(a_degats:INTEGER):INTEGER
		--	Modifie les d�gats de type feu re�u
		do
			result:= a_degats * 3
		end

	degat_3(a_degats:INTEGER):INTEGER
		--	Modifie les d�gats de type feu re�u
		require else
			a_degats_not_zero: a_degats > 0
		do
			result:= a_degats // 2
		end

	degat_4(a_degats:INTEGER):INTEGER
		--	Modifie les d�gats de type feu re�u
		require else
			a_degats_not_zero: a_degats > 0
		do
			result:= a_degats // 2
		end

end
