note
	description : "[
					Moteur principal du jeu. 
					Affiche le terrain et le personnage.
					G�re les touches et ex�cute les d�placements.
				]"
	auteur		: "Steve Duquet et Maxime Laflamme"
	date        : "16 f�vrier 2016"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- Pour utiliser `game_library'
	IMG_LIBRARY_SHARED		-- Pour utiliser `image_file_library'

create
	make

feature {NONE} -- Constructeur

	make
		do
			game_library.enable_video -- Active les fonctionnalit�s vid�o
			image_file_library.enable_image (true, false, false)  -- Active le format d'image PNG (mais pas TIF ou JPG)
			run_game  -- Ex�cute le cr�ateur de base du jeu
			image_file_library.quit_library  -- Dissocie  correctement  la biblioth�que de fichiers images
			game_library.quit_library  -- Efface la biblioth�que avant de quitter
		end

	run_game
			-- Cr�ation des ressources et lancement du jeu
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_fond:IMAGE
			l_maryo:MARYO
			l_window:GAME_WINDOW_SURFACED
		do
			create l_fond
			if not l_fond.has_error then
				create l_maryo
				l_maryo.y := 250
				l_maryo.x := 250
				if not l_maryo.has_error then
					create l_window_builder
					l_window_builder.set_dimension (500, 500)
					l_window_builder.set_title ("Combats �piques")
					l_window := l_window_builder.generate_window
					game_library.quit_signal_actions.extend (agent on_quit)
					l_window.key_pressed_actions.extend (agent on_key_pressed(?, ?, l_maryo))
					l_window.key_released_actions.extend (agent on_key_released(?,?,  l_maryo))
					game_library.iteration_actions.extend (agent on_iteration(?, l_maryo, l_fond, l_window, False))
					on_iteration(0, l_maryo, l_fond, l_window, True)
					last_redraw_time := game_library.time_since_create
					game_library.launch
				else
					print("Impossible de cr�er le personnage.")
				end
			else
				print("Impossible de cr�er la surface de fond.")
			end
		end


feature {NONE} -- Impl�mentation

	on_iteration(a_timestamp:NATURAL_32; a_maryo:MARYO; a_IMAGE:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED; a_must_redraw:BOOLEAN)
			-- �v�nement qui est lanc� � chaque it�ration
		local
			l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]]
			l_must_redraw:BOOLEAN
		do
			l_must_redraw := a_must_redraw
			if (game_library.time_since_create - last_redraw_time) > 1000 then	-- Une fois chaque seconde, redessine la totalit� de l'�cran
				l_must_redraw := True
				last_redraw_time := game_library.time_since_create
			end
			create l_area_dirty.make(2)
			if l_must_redraw then
				-- Force la red�finition de l'ensemble de la fen�tre
				l_area_dirty.extend ([0, 0, l_window.width, l_window.height])
			else
				-- Redessine seulement l'endroit o� �tait Maryo
				l_area_dirty.extend ([a_maryo.x, a_maryo.y, a_maryo.sub_image_width, a_maryo.sub_image_height])
			end

			a_maryo.update (a_timestamp)	-- Met � jour l'animation de Maryo et coordonne

			if a_maryo.is_dirty or l_must_redraw then	-- Redessine seulement s'il y a des modifications � Maryo
				a_maryo.unset_dirty
				-- S'assure que Maryo ne sort pas de l'�cran
				if a_maryo.x < 0 then
					a_maryo.x := 0
				elseif a_maryo.x + a_maryo.sub_image_width > a_IMAGE.width then
					a_maryo.x := a_IMAGE.width - a_maryo.sub_image_width
				end

				-- Dessine la sc�ne (ne redessine pas ce que nous n'avons pas � redessiner)
				l_window.surface.draw_rectangle (
									create {GAME_COLOR}.make_rgb (0, 128, 255),
									l_area_dirty.first.x, l_area_dirty.first.y,
									l_area_dirty.first.width, l_area_dirty.first.height
								)
				l_window.surface.draw_sub_surface (
									a_IMAGE,
									l_area_dirty.first.x, l_area_dirty.first.y,
									l_area_dirty.first.width, l_area_dirty.first.height,
									l_area_dirty.first.x, l_area_dirty.first.y
								)
				l_window.surface.draw_sub_surface (a_maryo.surface, a_maryo.sub_image_x, a_maryo.sub_image_y,
										a_maryo.sub_image_width, a_maryo.sub_image_height, a_maryo.x, a_maryo.y)

				-- Mise � jour de la modification dans l'�cran
				l_area_dirty.extend ([a_maryo.x, a_maryo.y, a_maryo.sub_image_width, a_maryo.sub_image_height])
				l_window.update_rectangles (l_area_dirty)
			end


		end


	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_maryo:MARYO)
			-- Action quand une touche du clavier a �t� pouss�e
		do
			if not a_key_state.is_repeat then		-- S'assure que l'�v�nement n'est pas seulement une r�p�tition de la cl�
				if a_key_state.is_right then
					a_maryo.go_right(a_timestamp)
				elseif a_key_state.is_left then
					a_maryo.go_left(a_timestamp)
				elseif a_key_state.is_up then
					a_maryo.go_up(a_timestamp)
				elseif a_key_state.is_down then
					a_maryo.go_down(a_timestamp)
				end
			end

		end

	on_key_released(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_maryo:MARYO)
			-- Action quand une touche du clavier a �t� lib�r�e
		do
			if not a_key_state.is_repeat then		-- Je ne sais pas si une lib�ration se r�p�te, mais on ne sait jamais ...
				if a_key_state.is_right then
					a_maryo.stop_right
				elseif a_key_state.is_left then
					a_maryo.stop_left
				elseif a_key_state.is_up then
					a_maryo.stop_up
				elseif a_key_state.is_down then
					a_maryo.stop_down
				end
			end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- Cette m�thode est appel�e lorsque le signal quitter est envoy� � l'application (ex.: bouton X press�)
		do
			game_library.stop  -- Arr�te la boucle de commande (permet game_library.launch pour revenir)
		end

	last_redraw_time:NATURAL_32
			-- La derni�re fois que la totalit� de l'�cran a �t� redessin�e

end
