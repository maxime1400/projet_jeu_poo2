note
	description : "Génère un son à partir d'un fichier"
	auteur		: "Steve Duquet"
	date        : "1 mars 2016"

class
	SON

inherit
	AUDIO_LIBRARY_SHARED
	EXCEPTIONS


create
	make

feature {NONE} -- Constructeur

	make(a_filename:READABLE_STRING_GENERAL)
		local
			l_sound:AUDIO_SOUND_FILE
			sound_source:AUDIO_SOURCE	-- On a besoin d'une source pour chaque son qu'on veux jouer en même temps
		do
			-- Création d'un son à chaque fois qu'on appuie sur une touche de direction
			create l_sound.make (a_filename)
			if l_sound.is_openable then
				l_sound.open
				if l_sound.is_open then
					audio_library.sources_add
					sound_source:=audio_library.last_source_added
					sound_source.queue_sound (l_sound)
					sound_source.play
				else
					print("Impossible d'ouvrir le fichier audio.")
					die(1)
				end
			else
				print("Fichier audio non valide.")
				die(1)
			end

		end
end
