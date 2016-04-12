note
	description: "Tests unitaires de la classe CREATURES"
	author: "Steve Duquet"
	date: "11 avril 2016"
	testing: "type/manual"

class
	TEST_CREATURE

inherit
	EQA_TEST_SET

feature -- Test routines

	test_vie_creation
			-- Test pour voir si la vie envoy�e est la m�me sans avoir fait de demande de modification
		local
			new_creature: CREATURE
			vie: INTEGER
		do
			create new_creature.create_creature(100)
			vie:= new_creature.get_vie
			assert ("CREATURE test retour valeur initiale", vie ~ 100)
		end

	test_vie_diminuer
			-- Test pour voir si la vie diminue correctement
		local
			new_creature: CREATURE
			vie: INTEGER
		do
			create new_creature.create_creature(100)
			new_creature.set_vie(20)
			vie:= new_creature.get_vie
			assert ("CREATURE test diminution normale", vie ~ 80)
		end

	test_vie_limite
			-- Test pour voir si la vie descend pas en-dessous de 0
		local
			new_creature: CREATURE
			vie: INTEGER
		do
			create new_creature.create_creature(100)
			new_creature.set_vie(110)
			vie:= new_creature.get_vie
			assert ("CREATURE test diminution � z�ro", vie ~ 0)
		end

	test_vie_pareil
			-- Test pour voir si la vie reste pareil avec des d�gats de 0
		local
			new_creature: CREATURE
			vie: INTEGER
		do
			create new_creature.create_creature(100)
			new_creature.set_vie(0)
			vie:= new_creature.get_vie
			assert ("CREATURE test aucune diminution", vie ~ 100)
		end

	test_attaque_recu
			-- Test pour voir si une attaque est bien g�r�e.
		local
			new_creature: CREATURE
			vie: INTEGER
			attaque: ARRAY[INTEGER]
		do
			create new_creature.create_creature(100)
			create attaque.make_empty
			attaque.put(1, 80)
			new_creature.attaque_recu(attaque)
			vie:= new_creature.get_vie
			assert ("CREATURE test attaque_recu", vie ~ 20)
		end
end
