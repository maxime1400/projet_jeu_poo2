note
	description 	: "Moteur principal du jeu"
	original		: "application.e"
	auteur			: "Louis Marchand"
	date			: "28 mars 2015"
	source			: "https://github.com/tioui/Eiffel_Game2.git"
	modification	: "Steve Duquet et Maxime Laflamme"

class
	JEU

inherit
	GAME_LIBRARY_SHARED

create
	run_game

feature {NONE} -- Constructeur

	run_game
			-- Cr�ation des ressources et lancement du jeu
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
			l_fond:FOND_JEU
			l_heros:HEROS
			l_musique:MUSIQUE
			l_fond_combat:FOND_COMBAT
			l_img_heros:IMG_HEROS
		do
			create l_musique.make("./sons/musique_fond.wav")
			create l_fond
			create l_heros
			create l_fond_combat
			create l_img_heros
			indicateur_combat:= 1

			if not (l_fond.has_error and l_fond_combat.has_error and l_img_heros.has_error and l_img_heros.has_error ) then
				create l_heros
				l_heros.y := 250
				l_heros.x := 250
				if not l_heros.has_error then
					create l_window_builder
					l_window_builder.set_dimension (500, 500)
					l_window_builder.set_title ("Combats �piques")
					l_window := l_window_builder.generate_window
					game_library.quit_signal_actions.extend (agent on_quit)
					l_window.key_pressed_actions.extend (agent on_key_pressed(?, ?, l_heros))
					l_window.key_released_actions.extend (agent on_key_released(?,?,  l_heros))
					game_library.iteration_actions.extend (agent on_iteration(?, l_heros, l_fond, l_window, False,
															l_fond_combat, l_img_heros))
					on_iteration(0, l_heros, l_fond, l_window, True, l_fond_combat, l_img_heros)
					last_redraw_time := game_library.time_since_create
					game_library.launch
				else
					print("Impossible de cr�er le personnage.")
				end
			else
				print("Probl�me de cr�ation d'images")
			end
		end

feature {NONE} -- Impl�mentation

	on_iteration(a_timestamp:NATURAL_32; a_heros:HEROS; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED;
					a_must_redraw:BOOLEAN; a_fond_combat:GAME_SURFACE; a_img_heros:GAME_SURFACE)
			-- �v�nement qui est lanc� � chaque it�ration
		local
			l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]]
			l_must_redraw:BOOLEAN
		do
			l_must_redraw := a_must_redraw
			if (game_library.time_since_create - last_redraw_time) > 1000 then
			-- Chaque seconde, redessine la totalit� de l'�cran
				l_must_redraw := True
				last_redraw_time := game_library.time_since_create
			end
			create l_area_dirty.make(2)

			if indicateur_combat = 3 then
				indicateur_combat:= 1
				l_must_redraw:= true
			end

			if indicateur_combat = 1 then
				if l_must_redraw then
					-- Force la red�finition de l'ensemble de la fen�tre
					l_area_dirty.extend ([0, 0, l_window.width, l_window.height])
				else
					-- Redessine seulement l'endroit o� �tait le personnage
					l_area_dirty.extend ([a_heros.x, a_heros.y, a_heros.sub_image_width, a_heros.sub_image_height])
				end

				if a_heros.get_determinant_creature > 3 then
					a_heros.set_determinant_creature(1)
				end
				if a_heros.get_compteur_pas > 10 then
					a_heros.set_compteur_pas(0)
					indicateur_combat:= 2
--					choix_img_creature(a_heros.get_determinant_creature)
				end

				a_heros.update (a_timestamp)	-- Met � jour l'animation du personnage et le coordonne

				if a_heros.is_dirty or l_must_redraw then	-- Redessine seulement s'il y a des modifications au personnage
					a_heros.unset_dirty
					-- S'assure que le personnage ne sort pas de l'�cran
					if a_heros.x < 0 then
						a_heros.x := 0
					elseif a_heros.y < 0 then
						a_heros.y := 0
					elseif a_heros.x + a_heros.sub_image_width > a_image.width then
						a_heros.x := a_image.width - a_heros.sub_image_width
					elseif a_heros.y + a_heros.sub_image_height > a_image.height then
						a_heros.y := a_image.height - a_heros.sub_image_height
					end

					-- Dessine la sc�ne (ne redessine pas ce que nous n'avons pas � redessiner)
					l_window.surface.draw_rectangle (
										create {GAME_COLOR}.make_rgb (0, 128, 255),
										l_area_dirty.first.x, l_area_dirty.first.y,
										l_area_dirty.first.width, l_area_dirty.first.height
									)
					l_window.surface.draw_sub_surface (
										a_image,
										l_area_dirty.first.x, l_area_dirty.first.y,
										l_area_dirty.first.width, l_area_dirty.first.height,
										l_area_dirty.first.x, l_area_dirty.first.y
									)
					l_window.surface.draw_sub_surface (a_heros.surface, a_heros.sub_image_x, a_heros.sub_image_y,
											a_heros.sub_image_width, a_heros.sub_image_height, a_heros.x, a_heros.y)

					-- Mise � jour de la modification dans l'�cran
					l_area_dirty.extend ([a_heros.x, a_heros.y, a_heros.sub_image_width, a_heros.sub_image_height])
					l_window.update_rectangles (l_area_dirty)
				end

			elseif indicateur_combat = 2 then
				if l_must_redraw then
					-- Force la red�finition de l'ensemble de la fen�tre
					l_area_dirty.extend ([0, 0, l_window.width, l_window.height])

				l_window.surface.draw_rectangle (
										create {GAME_COLOR}.make_rgb (0, 128, 255),
										0, 0,
										500, 500
									)

				l_window.surface.draw_sub_surface (
									a_fond_combat,
									0, 0,
									500, 500,
									0, 0
								)

				l_window.surface.draw_sub_surface (
									a_img_heros,
									0, 0,
									500, 250,
									0, 80
								)
				end
			end
			l_window.update_rectangles (l_area_dirty)
		end


	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_heros:HEROS)
			-- Action quand une touche du clavier a �t� pouss�e
		do
			if not a_key_state.is_repeat then		-- S'assure que l'�v�nement n'est pas seulement une r�p�tition de la cl�
				if a_key_state.is_right then
					a_heros.go_right(a_timestamp)
				elseif a_key_state.is_left then
					a_heros.go_left(a_timestamp)
				elseif a_key_state.is_up then
					a_heros.go_up(a_timestamp)
				elseif a_key_state.is_down then
					a_heros.go_down(a_timestamp)

				elseif a_key_state.is_return then
					indicateur_combat:= 3
				end
			end
		end

	on_key_released(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_heros:HEROS)
			-- Action quand une touche du clavier a �t� lib�r�e
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_right then
					a_heros.stop_right
				elseif a_key_state.is_left then
					a_heros.stop_left
				elseif a_key_state.is_up then
					a_heros.stop_up
				elseif a_key_state.is_down then
					a_heros.stop_down
				end
			end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- Cette m�thode est appel�e lorsque le signal pour quitter est envoy� � l'application (ex.: bouton X press�)
		do
			game_library.stop  -- Arr�te la boucle de commande (game_library.launch pour revenir)
		end

--	choix_img_creature(a_determinant: INTEGER)
--		-- Retourne l'image de la cr�ature
--		local
--			l_img_1: IMG_CHARIZARD
--		do
--			if a_determinant = 1 then
--				create l_img_1
--				img_creature:= l_img_1
--			end
--		end

feature

	last_redraw_time:NATURAL_32
			-- La derni�re fois que la totalit� de l'�cran a �t� redessin�e

	indicateur_combat:INTEGER
			-- 1 = pas en combat, 2 = combat en cours, 3 = vient de sortir du combat

--	img_creature:GAME_SURFACE
--			-- image de la cr�ature � utiliser pendant un combat

end
