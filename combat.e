note
	description		: "Moteur principal d'un combat"
	auteur			: "Steve Duquet et Maxime Laflamme"
	date			: "21 mars 2016"

class
	COMBAT

create
	make

feature {NONE} -- Constructeur

	make(a_window:GAME_WINDOW_SURFACED; determinant_creature:NATURAL_32)
		-- Début d'un combat
		local
			l_img_creature_1:IMG_CHARIZARD
		do
			if determinant_creature = 1 or determinant_creature = 2 or determinant_creature = 3 then
				create l_img_creature_1
				if not l_img_creature_1.has_error then
					make_window(a_window, l_img_creature_1)
				else
					print("Impossible de créer la surface de la créature.")
				end
			end
		end

	make_window(l_window:GAME_WINDOW_SURFACED; l_img_creature:GAME_SURFACE)
		-- Mise en place des images de la fenêtre de combat
		local
			l_fond:FOND_COMBAT
			l_heros:IMG_HEROS
			l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]]
--			l_key:INTEGER_32
		do
			create l_fond
			create l_heros
			if not l_fond.has_error and not l_heros.has_error then
				l_window.surface.draw_rectangle (
										create {GAME_COLOR}.make_rgb (0, 128, 255),
										0, 0,
										500, 500
									)

				l_window.surface.draw_sub_surface (
									l_fond,
									0, 0,
									500, 500,
									0, 0
								)

				l_window.surface.draw_sub_surface (
									l_img_creature,
									0, 0,
									250, 250,
									250, 0
								)

				l_window.surface.draw_sub_surface (
									l_heros,
									0, 0,
									500, 250,
									0, 80
								)

				create l_area_dirty.make(2)
				l_area_dirty.extend ([0, 0, 500, 500])
				l_window.update_rectangles (l_area_dirty)

--				from
--					l_key:= l_window.key_pressed_actions.extend (agent on_key_pressed(?))
--				until
--					l_key=0
--				loop
--					l_key:= l_window.key_pressed_actions.extend (agent on_key_pressed(a_key_state()))
--				end

			else
				print("Impossible de créer la surface de fond du combat.")
			end
		end

--	on_key_pressed(a_key_state: GAME_KEY_STATE):INTEGER
--			-- Action quand une touche du clavier a été poussée
--		local
--			l_key:INTEGER

--		do
--			if not a_key_state.is_repeat then		-- S'assure que l'événement n'est pas seulement une répétition de la clé
--				if a_key_state.is_right then
--					l_key:=0
--				end
--			end
--			Result:=l_key
--		end

end
