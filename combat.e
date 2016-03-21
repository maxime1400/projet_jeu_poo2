note
	description		: "Moteur principal d'un combat"
	auteur			: "Steve Duquet et Maxime Laflamme"
	date			: "21 mars 2016"

class
	COMBAT

create
	make_window

feature {NONE} -- Constructeur

	make_window(a_window:GAME_WINDOW_SURFACED; a_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]])
		-- Mise en place des images de la fenêtre de combat
		local
			l_fond:FOND_COMBAT
			test:INTEGER
			test2:INTEGER
		do
			io.put_string("Début d'un combat!!! Bravo!!!")
			create l_fond
			if not l_fond.has_error then
				a_window.surface.draw_rectangle (
										create {GAME_COLOR}.make_rgb (0, 128, 255),
										0, 0,
										500, 500
									)

				a_window.surface.draw_sub_surface (
									l_fond,
									0, 0,
									500, 500,
									0, 0
								)

				a_window.update_rectangles (a_area_dirty)

				io.put_string("Tu es dans une boucle hihihi xD")
				from
					test2:=10000000
				until
					test2/=0
				loop
					from
						test:=10000000
					until
						test/=0
					loop
						test:= test - 1
					end
					test2:= test2 - 1
				end

			else
				print("Impossible de créer la surface de fond du combat.")
			end
		end
end
