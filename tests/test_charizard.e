note
	description: "Tests unitaires de la classe CHARIZARD"
	author: "Steve Duquet"
	date: "19 avril 2016"
	testing: "type/manual"

class
	TEST_CHARIZARD

inherit
	EQA_TEST_SET

feature -- Test routines

	test_attaque_1
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: CHARIZARD
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 1
			degats:= 10
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.get_vie
			assert ("CREATURE test attaque_recu", vie ~ 95)
		end

	test_attaque_2
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: CHARIZARD
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 2
			degats:= 10
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.get_vie
			assert ("CREATURE test attaque_recu", vie ~ 90)
		end

	test_attaque_3
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: CHARIZARD
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 3
			degats:= 10
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.get_vie
			assert ("CREATURE test attaque_recu", vie ~ 95)
		end

	test_attaque_4
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: CHARIZARD
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 4
			degats:= 10
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.get_vie
			assert ("CREATURE test attaque_recu", vie ~ 80)
		end

end
