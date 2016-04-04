note
	description		: "Moteur principal d'un combat"
	auteur			: "Steve Duquet et Maxime Laflamme"
	date			: "21 mars 2016"

class
	COMBAT

inherit
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	EXCEPTIONS

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
			l_img_heros:IMG_HEROS
			l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]]
			l_heros:HEROS
		do
			create l_fond
			create l_img_heros
			create l_heros
			if not l_fond.has_error and not l_img_heros.has_error then
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
									l_img_heros,
									0, 0,
									500, 250,
									0, 80
								)

				create l_area_dirty.make(2)
				l_area_dirty.extend ([0, 0, 500, 500])
				l_window.update_rectangles (l_area_dirty)

				l_window.key_pressed_actions.extend (agent key_pressed(?, ?, l_heros))
				from
				until
					touche=0

				loop
					l_window.key_pressed_actions.extend (agent key_pressed(?, ?, l_heros))
				end

			else
				print("Impossible de créer la surface de fond du combat.")
			end
		end

	key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_heros:HEROS)
			-- Action quand une touche du clavier a été poussée
		do
			print("test")
			if not a_key_state.is_repeat then
				if a_key_state.is_return then
					touche:=1
				else
					touche:=0
				end
			end
		end

feature {NONE} -- variables & constantes

	touche:INTEGER
			-- le numéro de touche appuyé

end
