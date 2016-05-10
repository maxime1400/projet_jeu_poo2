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
	make_game

feature {NONE} -- Constructeur

	make_game
	local
		do
			etape_combat:= 1
			create ennemi.create_creature (100)
			run_game
		end

	run_game
			-- Création des ressources et lancement du jeu
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_fond:IMAGE_JEU
			l_heros:HEROS
			l_window:GAME_WINDOW_SURFACED
			l_musique:MUSIQUE
			l_fond_combat:IMAGE_JEU
			l_img_heros:IMAGE_JEU
		do
			create l_musique.make("./sons/musique_fond.wav")
			create l_fond.nouvelle_image("./images/terrain.png")
			create l_fond_combat.nouvelle_image ("./images/fond_combat.png")
			create l_img_heros.nouvelle_image ("./images/heros_combat.png")
			create l_heros

			if not (l_fond.has_error and l_fond_combat.has_error and l_img_heros.has_error and l_img_heros.has_error) then
				create l_heros
				l_heros.y := 250
				l_heros.x := 250
				l_heros.set_vie(100)
				if not l_heros.has_error then
					create l_window_builder
					l_window_builder.set_dimension (500, 500)
					l_window_builder.set_title ("Combats épiques")
					l_window := l_window_builder.generate_window
					game_library.quit_signal_actions.extend (agent on_quit)
					l_window.key_pressed_actions.extend (agent on_key_pressed(?, ?, l_heros))
					l_window.key_released_actions.extend (agent on_key_released(?,?,  l_heros))
					game_library.iteration_actions.extend (agent on_iteration(?, l_heros, l_fond,
															l_window, False, l_fond_combat, l_img_heros))
					on_iteration(0, l_heros, l_fond, l_window, True, l_fond_combat, l_img_heros)
					last_redraw_time := game_library.time_since_create
					game_library.launch
				else
					print("Impossible de créer le personnage.")
				end
			else
				print("Problème d'ouverture d'image")
			end

		end


feature {NONE} -- Implémentation

	on_iteration(a_timestamp:NATURAL_32; a_heros:HEROS; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED;
					a_must_redraw:BOOLEAN; a_fond_combat:GAME_SURFACE; a_img_heros:GAME_SURFACE)
			-- Événement qui est lancé à chaque itération
		local
			l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]]
			l_must_redraw:BOOLEAN
		do
			l_must_redraw := a_must_redraw
			if (game_library.time_since_create - last_redraw_time) > 250 then	-- Chaque seconde, redessine la totalité de l'écran
				l_must_redraw := True
				last_redraw_time := game_library.time_since_create
			end

			create l_area_dirty.make(2)

			if etape_combat = 4 then
				etape_combat:= 1
				a_heros.set_vie(100)
				l_must_redraw:= true
			end

			if etape_combat = 6 then
				etape_combat:= 1
				l_must_redraw:= true
			end

			if etape_combat = 1 then

				doit_redessiner (l_window, a_heros, l_must_redraw, l_area_dirty)

				if a_heros.get_determinant_creature > 3 then
					a_heros.set_determinant_creature(1)
				end
				if a_heros.get_compteur_pas > 10 then
					a_heros.set_compteur_pas(0)
					etape_combat:= 2
				end

				a_heros.update (a_timestamp)	-- Met à jour l'animation du personnage et le coordonne

				if a_heros.is_dirty or l_must_redraw then	-- Redessine seulement s'il y a des modifications au personnage
					a_heros.unset_dirty
					-- S'assure que le personnage ne sort pas de l'écran
					if a_heros.x < 0 then
						a_heros.x := 0
					elseif a_heros.y < 0 then
						a_heros.y := 0
					elseif a_heros.x + a_heros.sub_image_width > a_image.width then
						a_heros.x := a_image.width - a_heros.sub_image_width
					elseif a_heros.y + a_heros.sub_image_height > a_image.height then
						a_heros.y := a_image.height - a_heros.sub_image_height
					end

					dessine_scene(l_window, l_area_dirty, a_image, a_heros, a_fond_combat, a_img_heros)

					-- Mise à jour de la modification dans l'écran
					l_area_dirty.extend ([a_heros.x, a_heros.y, a_heros.sub_image_width, a_heros.sub_image_height])
					l_window.update_rectangles (l_area_dirty)
				end

			elseif etape_combat = 2 then
				ennemi:= who_is_creature(a_heros.get_determinant_creature)
				etape_combat:= 3

			elseif etape_combat = 3 then
				if l_must_redraw then
					doit_redessiner(l_window, a_heros, l_must_redraw, l_area_dirty)
					dessine_scene (l_window, l_area_dirty, a_image, a_heros, a_fond_combat, a_img_heros)
					l_window.update_rectangles (l_area_dirty)
					if choix_attaque /= 0 then
						a_heros.dommages(15)
					end
					dommage_creature(ennemi)
				end

				if ennemi.vie = 0 then
					etape_combat:= 4
				end
				if a_heros.get_vie = 0 then
					etape_combat:= 5
				end

			elseif etape_combat = 5 then
				if l_must_redraw then
					doit_redessiner(l_window, a_heros, l_must_redraw, l_area_dirty)
					dessine_scene (l_window, l_area_dirty, a_image, a_heros, a_fond_combat, a_img_heros)
					l_window.update_rectangles (l_area_dirty)
				end
			end
		end


	doit_redessiner(l_window:GAME_WINDOW_SURFACED; a_heros:HEROS; l_must_redraw:BOOLEAN; l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]])
		do
			if l_must_redraw then
				-- Force la redéfinition de l'ensemble de la fenêtre
				l_area_dirty.extend ([0, 0, l_window.width, l_window.height])
			elseif l_must_redraw = false AND etape_combat /= 2 then
				-- Redessine seulement l'endroit où était le personnage
				l_area_dirty.extend ([a_heros.x, a_heros.y, a_heros.sub_image_width, a_heros.sub_image_height])
			end
		end


	dessine_scene(l_window:GAME_WINDOW_SURFACED;
					l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]];
					a_image:GAME_SURFACE; a_heros:HEROS;
					a_fond_combat:GAME_SURFACE; a_img_heros:GAME_SURFACE)
			-- Dessine la scène (ne redessine pas ce que nous n'avons pas à redessiner)
		local
			l_img_game_over:IMAGE_JEU
		do
			if etape_combat = 1 then

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

			elseif etape_combat = 3 then

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

				apparition_creature (l_window, a_heros.get_determinant_creature)

				apparition_attaque_joueur (l_window)

				l_window.surface.draw_sub_surface (
									a_img_heros,
									0, 0,
									500, 250,
									0, 80)

				apparition_attaque_ennemi (l_window, a_heros.get_determinant_creature)

			elseif etape_combat = 5 then
				create l_img_game_over.nouvelle_image ("./images/game_over.png")

				l_window.surface.draw_sub_surface (
									l_img_game_over,
									0, 0,
									500, 500,
									0, 0)
			end
		end


	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_heros:HEROS)
			-- Action quand une touche du clavier a été poussée
		do
			if not a_key_state.is_repeat then		-- S'assure que l'événement n'est pas seulement une répétition de la clé

				if etape_combat = 1 then
					if a_key_state.is_right then
						a_heros.go_right(a_timestamp)
					elseif a_key_state.is_left then
						a_heros.go_left(a_timestamp)
					elseif a_key_state.is_up then
						a_heros.go_up(a_timestamp)
					elseif a_key_state.is_down then
						a_heros.go_down(a_timestamp)
					end
				elseif etape_combat = 3 then
					if a_key_state.is_A then
						choix_attaque:= 1	-- feu
					elseif a_key_state.is_S then
						choix_attaque:= 2	-- glace
					elseif a_key_state.is_Z then
						choix_attaque:= 3	-- épée
					elseif a_key_state.is_X then
						choix_attaque:= 4	-- roche
					end
				elseif etape_combat = 5 then
					if a_key_state.is_return then
						a_heros.set_vie(100)
						etape_combat:= 6
					end
				end
			end
		end

	on_key_released(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_heros:HEROS)
			-- Action quand une touche du clavier a été libérée
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
			-- Cette méthode est appelée lorsque le signal pour quitter est envoyé à l'application (ex.: bouton X pressé)
		do
			game_library.stop  -- Arrête la boucle de commande (game_library.launch pour revenir)
		end

	apparition_creature (a_window: GAME_WINDOW_SURFACED; a_determinant_creature: NATURAL_32)
		local
			l_image: IMAGE_JEU
			l_creature: GAME_SURFACE
		do
			if a_determinant_creature = 1 then
				create l_image.nouvelle_image ("./images/charizard.png")
			elseif a_determinant_creature = 2 then
				create l_image.nouvelle_image ("./images/aerodactyl.png")
			else
				create l_image.nouvelle_image ("./images/gyarados.png")
			end
			l_creature:= l_image
			a_window.surface.draw_sub_surface (l_creature, 0, 0, 250, 250, 250, 0)
		end

	apparition_attaque_joueur(a_window: GAME_WINDOW_SURFACED)
		local
			l_image: IMAGE_JEU
			l_attack_joueur: GAME_SURFACE
		do
			if choix_attaque /= 0 then
				if choix_attaque = 1 then
					create l_image.nouvelle_image ("./images/attack_fire.png")
				elseif choix_attaque = 2 then
					create l_image.nouvelle_image ("./images/attack_ice.png")
				elseif choix_attaque = 3 then
					create l_image.nouvelle_image ("./images/attack_sword.png")
				elseif choix_attaque = 4 then
					create l_image.nouvelle_image ("./images/attack_rock.png")
				else
					create l_image.nouvelle_image ("./images/vide.png")
				end

				l_attack_joueur := l_image
				a_window.surface.draw_sub_surface (l_attack_joueur, 0, 0, 250, 250, 250, 0)
			end
		end

	apparition_attaque_ennemi(a_window: GAME_WINDOW_SURFACED; a_determinant_creature: NATURAL_32)
		local
			l_image: IMAGE_JEU
			l_attack_ennemi: GAME_SURFACE
		do
			if choix_attaque /= 0 then
				if a_determinant_creature = 1 then
					create l_image.nouvelle_image ("./images/attack_fire.png")
				elseif a_determinant_creature = 2 then
					create l_image.nouvelle_image ("./images/attack_rock.png")
				elseif a_determinant_creature = 3 then
					create l_image.nouvelle_image ("./images/attack_ice.png")
				else
					create l_image.nouvelle_image ("./images/vide.png")
				end

				l_attack_ennemi:= l_image
				a_window.surface.draw_sub_surface (l_attack_ennemi, 0, 0, 250, 250, 0, 80)
			end
		end

	who_is_creature(a_determinant_creature: NATURAL_32):CREATURE
		-- Renvoi un objet de type CREATURE
		local
			charizard:CHARIZARD
			aerodactyl:AERODACTYL
			gyarados:GYARADOS
		do
			if a_determinant_creature = 1 then
				create charizard.create_creature(100)
				result:= charizard
			elseif a_determinant_creature = 2 then
				create aerodactyl.create_creature(100)
				result:= aerodactyl
			else
				create gyarados.create_creature(100)
				result:= gyarados
			end
		end

	dommage_creature (a_ennemi:CREATURE)
		-- envoi les dommages à l'objet de type CREATURE
	do
		a_ennemi.attaque_recu (choix_attaque, 10)
		choix_attaque:= 0
	end

feature {NONE} -- Variables

	last_redraw_time:NATURAL_32
			-- La dernière fois que la totalité de l'écran a été redessinée

	etape_combat:INTEGER
			-- 1=pas en combat, 2=initialisation du combat 3=combat en cours, 4=vient de sortir du combat
			-- 5= Game Over, 6= vient de sortir du Game Over

	choix_attaque:INTEGER
			-- 1= feu, 2= glace, 3=épée, 4=roche

	ennemi:CREATURE
			-- Objet des ennemis que le joueur affronte

end
