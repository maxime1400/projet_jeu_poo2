note
	description: "Génère la musique de fond."
	author: "Maxime Laflamme"
	date: "1 mars 2016"

class
	MUSIQUE

inherit
	AUDIO_LIBRARY_SHARED	-- Rend les fonctionnalités de `audio_library' disponible

create
	make

feature {NONE} -- Initialization

	make(a_filename:READABLE_STRING_GENERAL)
			-- Run application.
		do
			run_player(a_filename)
		end

feature {NONE} -- Access

	run_player(a_filename:READABLE_STRING_GENERAL)
		-- Execute le son
		local
			l_sound:AUDIO_SOUND_FILE
		do
			create l_sound.make (a_filename)	-- Ouvre le son
			if l_sound.is_openable then
				l_sound.open
				if l_sound.is_open then
					audio_library.sources_add					-- Crée une nouvelle source de son
					audio_library.last_source_added.set_gain (0.32)
					audio_library.last_source_added.queue_sound_infinite_loop (l_sound)	-- Ajoute le son dans la nouvelle source
					audio_library.last_source_added.play			-- Joue la source.
				end
			end
		end

end
