note
	description : "Démarrage du jeu et menu d'accueil"
	auteur		: "Steve Duquet"
	date        : "16 février 2016"

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
			game_library.enable_video -- Active les fonctionnalités vidéo
			image_file_library.enable_image (true, false, false)  -- Active le format d'image PNG (mais pas TIF ou JPG)
			run_game  -- Exécute le créateur de base du jeu
			image_file_library.quit_library  -- Dissocie  correctement  la bibliothèque de fichiers images
			game_library.quit_library  -- Efface la bibliothèque avant de quitter
		end

	run_game
			-- Création des ressources et lancement du jeu
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_fond:IMAGE
			l_window:GAME_WINDOW_SURFACED
		do
			create l_fond
			if not l_fond.has_error then
			else
				print("Impossible de créer la surface du fond d'accueil.")
			end
		end


feature {NONE} -- Implémentation

	on_iteration(a_timestamp:NATURAL_32; l_fond:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED; a_must_redraw:BOOLEAN)
			-- Événement qui est lancé à chaque itération
		local
			l_area_dirty:ARRAYED_LIST[TUPLE[x,y,width,height:INTEGER]]
			l_must_redraw:BOOLEAN
		do
			l_must_redraw := a_must_redraw
			if (game_library.time_since_create - last_redraw_time) > 1000 then	-- Une fois chaque seconde, redessine la totalité de l'écran
				l_must_redraw := True
				last_redraw_time := game_library.time_since_create
			end
			create l_area_dirty.make(2)
			if l_must_redraw then
				-- Force la redéfinition de l'ensemble de la fenêtre
				l_area_dirty.extend ([0, 0, l_window.width, l_window.height])
			end

		end


	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action quand une touche du clavier a été poussée
		do
			if not a_key_state.is_repeat then		-- S'assure que l'événement n'est pas seulement une répétition de la clé
				if a_key_state.is_right then
				end
			end

		end

	on_quit(a_timestamp: NATURAL_32)
			-- Cette méthode est appelée lorsque le signal quitté est envoyé à l'application (ex: bouton X Windows pressé)
		do
			game_library.stop  -- Arrête la boucle de commande (permet game_library.launch pour revenir)
		end

	last_redraw_time:NATURAL_32
			-- La dernière fois que la totalité de l'écran a été redessinée

end
