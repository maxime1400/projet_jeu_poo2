note
	description : "D�marrage du jeu et menu d'accueil"
	auteur		: "Steve Duquet"
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
			l_window:GAME_WINDOW_SURFACED
		do
			create l_fond
			if not l_fond.has_error then
			else
				print("Impossible de cr�er la surface du fond d'accueil.")
			end
		end


feature {NONE} -- Impl�mentation

	on_iteration(a_timestamp:NATURAL_32; l_fond:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED; a_must_redraw:BOOLEAN)
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
			end

		end


	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action quand une touche du clavier a �t� pouss�e
		do
			if not a_key_state.is_repeat then		-- S'assure que l'�v�nement n'est pas seulement une r�p�tition de la cl�
				if a_key_state.is_right then
				end
			end

		end

	on_quit(a_timestamp: NATURAL_32)
			-- Cette m�thode est appel�e lorsque le signal quitt� est envoy� � l'application (ex: bouton X Windows press�)
		do
			game_library.stop  -- Arr�te la boucle de commande (permet game_library.launch pour revenir)
		end

	last_redraw_time:NATURAL_32
			-- La derni�re fois que la totalit� de l'�cran a �t� redessin�e

end
