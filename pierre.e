note
	description: "Class avec les routines propres à une créature de type PIERRE"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "15 mars 2016"

class
	PIERRE

inherit
	TYPE_CREATURE
		redefine
			degat_1, degat_2, degat_3, degat_4
		end

feature

	degat_1(a_degats:INTEGER):INTEGER
		--	Modifie les dégats de type feu reçu
		require else
			a_degats_not_zero: a_degats > 0
		do
			result:= a_degats // 2
		end

	degat_2(a_degats:INTEGER):INTEGER
		--	Modifie les dégats de type glace reçu
		require else
			a_degats_not_zero: a_degats > 0
		do
			result:= a_degats * 2
		end

	degat_3(a_degats:INTEGER):INTEGER
		--	Modifie les dégats de type épée reçu
		require else
			a_degats_not_zero: a_degats > 0
		do
			result:= a_degats
		end

	degat_4(a_degats:INTEGER):INTEGER
		--	Modifie les dégats de type pierre reçu
		require else
			a_degats_not_zero: a_degats > 0
		do
			result:= a_degats
		end

end
