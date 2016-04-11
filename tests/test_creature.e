note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_CREATURE

inherit
	EQA_TEST_SET

feature -- Test routines

	test_vie_creation
			-- Test pour voir si la vie envoyée est la même sans avoir fait de demande de modification
		local
			new_creature: CREATURE
			vie: INTEGER
		do
			create new_creature.create_creature(100)
			vie:= new_creature.get_vie
			assert ("CREATURE test normal", vie ~ 100)
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
			assert ("CREATURE test normal", vie ~ 80)
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
			assert ("CREATURE test normal", vie ~ 0)
		end

	test_vie_pareil
			-- Test pour voir si la vie reste pareil avec des dégats de 0
		local
			new_creature: CREATURE
			vie: INTEGER
		do
			create new_creature.create_creature(100)
			new_creature.set_vie(0)
			vie:= new_creature.get_vie
			assert ("CREATURE test normal", vie ~ 100)
		end

end


