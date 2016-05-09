note
	description: "Tests unitaires de la classe GYARADOS"
	author: "Steve Duquet"
	date: "19 avril 2016"
	testing: "type/manual"

class
	TEST_GYARADOS

inherit
	EQA_TEST_SET

feature -- Test routines

	test_attaque_1
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: GYARADOS
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 1
			degats:= 40
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.vie
			assert ("CREATURE test attaque_recu", vie ~ 80)
		end

	test_attaque_2
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: GYARADOS
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 2
			degats:= 20
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.vie
			assert ("CREATURE test attaque_recu", vie ~ 60)
		end

	test_attaque_3
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: GYARADOS
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 3
			degats:= 20
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.vie
			assert ("CREATURE test attaque_recu", vie ~ 90)
		end

	test_attaque_4
			-- Test normal pour voir si une attaque est bien gérée.
		local
			new_creature: GYARADOS
			vie: INTEGER
			type: INTEGER
			degats: INTEGER
		do
			create new_creature.create_creature(100)
			type:= 4
			degats:= 20
			new_creature.attaque_recu(type, degats)
			vie:= new_creature.vie
			assert ("CREATURE test attaque_recu", vie ~ 90)
		end

end
