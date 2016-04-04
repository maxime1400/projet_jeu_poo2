note
	description		: "Personnage principal du programme"
	original		: "maryo.e"
	auteur			: "Louis Marchand"
	date			: "1er avril 2015"
	source			: "https://github.com/tioui/Eiffel_Game2.git"
	modification	: "Steve Duquet et Maxime Laflamme"

class
	HEROS

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end
	AUDIO_LIBRARY_SHARED
	redefine
		default_create
	end
	EXCEPTIONS
	redefine
		default_create
	end

create
	default_create

feature {NONE} -- Constructeur

	default_create
			-- Constructeur de `Current'
		local
			l_image:IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("./images/perso.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create right_surface.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} left_surface.make_zoom_x_y (right_surface, -1, 1, True)
					create up_surface.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} down_surface.make_zoom_x_y (right_surface, -1, 1, True)
					sub_image_width := right_surface.width // 3
					sub_image_height := right_surface.height
				else
					has_error := False
					create right_surface.make(1,1)
					left_surface := right_surface
					up_surface := right_surface
					down_surface := right_surface
				end
			else
				has_error := False
				create right_surface.make(1,1)
				left_surface := right_surface
				up_surface := right_surface
				down_surface := right_surface
			end
			surface := right_surface
			initialize_animation_coordinate
			initialize_sound
			is_dirty := True
		end

	initialize_sound
			-- Création de `sound_source'
		do
			create l_sound.make ("./sons/marche.ogg")
			if l_sound.is_openable then
				l_sound.open
				if l_sound.is_open then
					audio_library.sources_add
					sound_source:=audio_library.last_source_added

				else
					print("Impossible d'ouvrir le fichier audio.")
					die(1)
				end
			else
				print("Fichier audio non valide.")
				die(1)
			end
		end

	initialize_animation_coordinate
			-- Création de `animation_coordinates'
		do
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(4)
			animation_coordinates.extend ([surface.width // 3, 0])
			animation_coordinates.extend ([0, 0])
			animation_coordinates.extend ([(surface.width // 3) * 2, 0])
			animation_coordinates.extend ([0, 0])
			sub_image_x := animation_coordinates.at (1).x
			sub_image_y := animation_coordinates.at (1).y
		end

feature -- Accès

	has_error:BOOLEAN
			-- Est-ce qu'une erreur est survenue lors de l'initialisation de `surface'

	update(a_timestamp:NATURAL_32)
			-- Mise à jour de la surface en fonction de la présente `to_timestamp'
		local
			l_coordinate:TUPLE[x,y:INTEGER]
			l_delta_time:NATURAL_32
		do
			if going_left or going_right or going_up or going_down then
				l_coordinate := animation_coordinates.at ((((a_timestamp // animation_delta) \\
												animation_coordinates.count.to_natural_32) + 1).to_integer_32)
				if sub_image_x /= l_coordinate.x or sub_image_y /= l_coordinate.y then
					sub_image_x := l_coordinate.x
					sub_image_y := l_coordinate.y
					is_dirty := True
				end
				l_delta_time := a_timestamp - old_timestamp
				if l_delta_time // movement_delta > 0 then
					if going_right then
						surface := right_surface
						x := x + (l_delta_time // movement_delta * 2).to_integer_32
						if not sound_source.is_playing then
							compteur_pas:= compteur_pas + 1
							determinant_creature:= determinant_creature + 1
							sound_source.queue_sound (l_sound)
							sound_source.play
						end
					elseif going_left then
						surface := left_surface
						x := x - (l_delta_time // movement_delta * 2).to_integer_32
						if not sound_source.is_playing then
							compteur_pas:= compteur_pas + 1
							determinant_creature:= determinant_creature + 1
							sound_source.queue_sound (l_sound)
							sound_source.play
						end
					elseif going_up then
						surface := up_surface
						y := y - (l_delta_time // movement_delta * 2).to_integer_32
						if not sound_source.is_playing then
							compteur_pas:= compteur_pas + 1
							determinant_creature:= determinant_creature + 1
							sound_source.queue_sound (l_sound)
							sound_source.play
						end
					elseif going_down then
						surface := down_surface
						y := y + (l_delta_time // movement_delta * 2).to_integer_32
						if not sound_source.is_playing then
							compteur_pas:= compteur_pas + 1
							determinant_creature:= determinant_creature + 1
							sound_source.queue_sound (l_sound)
							sound_source.play
						end
					end
					old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
					is_dirty := True
				end
			end
		end

	go_left(a_timestamp:NATURAL_32)
			-- `Current' commence à se déplacer vers la gauche
		do
			old_timestamp := a_timestamp
			going_left := True
		end

	go_right(a_timestamp:NATURAL_32)
			-- `Current' commence à se déplacer vers la droite
		do
			old_timestamp := a_timestamp
			going_right := True
		end

	go_up(a_timestamp:NATURAL_32)
			-- `Current' commence à se déplacer vers le haut
		do
			old_timestamp := a_timestamp
			going_up := True
		end

	go_down(a_timestamp:NATURAL_32)
			-- `Current' commence à se déplacer vers le bas
		do
			old_timestamp := a_timestamp
			going_down := True
		end

	stop_left
			-- `Current' arrête de se déplacer vers la gauce
		do
			going_left := False
			if not going_right then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
				is_dirty := True
			end
		end

	stop_right
			-- `Current' arrête de se déplacer vers la droite
		do
			going_right := False
			if not going_left then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
				is_dirty := True
			end
		end

	stop_up
			-- `Current'  arrête de se déplacer vers le bas
		do
			going_up := False
			if not going_down then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
				is_dirty := True
			end
		end

	stop_down
			-- `Current'  arrête de se déplacer vers le haut
		do
			going_down := False
			if not going_up then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
				is_dirty := True
			end
		end

	going_left:BOOLEAN
			-- Est-ce que `Current' se déplace à gauche

	going_right:BOOLEAN
			--Est-ce que `Current' se déplace à droite

	going_up:BOOLEAN
			-- Est-ce que `Current' se déplace vers le haut

	going_down:BOOLEAN
			-- Est-ce que `Current' se déplace vers le bas

	x:INTEGER assign set_x
			-- Position verticale de `Current'

	y:INTEGER assign set_y
			-- Position horizontale de `Current'

	set_x(a_x:INTEGER)
			-- Attribue la valeur de `x' avec` a_x'
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	set_y(a_y:INTEGER)
			--  Attribue la valeur de `y' avec` a_y'
		do
			y := a_y
		ensure
			Is_Assign: y = a_y
		end

	sub_image_x, sub_image_y:INTEGER
			-- Position de la partie de l'image pour montrer à l'intérieur de la `surface '

	sub_image_width, sub_image_height:INTEGER
			-- Dimension de la partie de l'image pour montrer à l'intérieur de la `surface '

	surface:GAME_SURFACE
			-- La surface à utiliser lors de l'élaboration de `actuelle'

	is_dirty:BOOLEAN
			-- Si vrai, `actuel' a été modifié et doit être redessiné.

	unset_dirty
			-- `Current' a été gérée donc `is_dirty' est mis à faux
		do
			is_dirty := False
		end

	get_compteur_pas:NATURAL_32
			-- retourne le nombre de pas
		do
			result:= compteur_pas
		end

	set_compteur_pas(a_nombre:NATURAL_32)
			-- modifie le nombre de pas
		do
			compteur_pas:= a_nombre
		end

	get_determinant_creature:NATURAL_32
			-- retourne le nombre de pas
		do
			result:= determinant_creature
		end

	set_determinant_creature(a_nombre:NATURAL_32)
			-- modifie le nombre de pas
		do
			determinant_creature:= a_nombre
		end

feature {NONE} -- implémentation

	l_sound:AUDIO_SOUND_FILE

	sound_source:AUDIO_SOURCE

	animation_coordinates:LIST[TUPLE[x,y:INTEGER]]
			-- Chaque coordonnée de la partie des images dans `surface'

	old_timestamp:NATURAL_32
			-- Quand est arrivé le dernier mouvement (en considérant le mouvement `delta')

feature {NONE} -- variables & constantes

	movement_delta:NATURAL_32 = 10
			-- Le temps delta entre chaque mouvement de `actuel'

	animation_delta:NATURAL_32 = 100
			-- Le temps delta entre chaque animation de `actuel'

	left_surface:GAME_SURFACE

	right_surface:GAME_SURFACE

	up_surface:GAME_SURFACE

	down_surface:GAME_SURFACE

	compteur_pas:NATURAL_32

	determinant_creature:NATURAL_32


invariant
	l_sound_not_null: l_sound /= Void
	compteur_pas_max: compteur_pas <= 11

end
