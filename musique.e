note
	description: "Génère la musique de fond."
	author: "Maxime Laflamme"
	date: "1 mars 2016"

class
	MUSIQUE

inherit
	AUDIO_LIBRARY_SHARED	-- Enable the `audio_library' functionnality

create
	make

feature {NONE} -- Initialization

	make(a_filename:READABLE_STRING_GENERAL)
			-- Run application.
		do
			run_player(a_filename)
		end

	run_player(a_filename:READABLE_STRING_GENERAL)
		-- Execute the sound player
		local
			l_sound:AUDIO_SOUND_FILE
		do
			audio_library.launch_in_thread	-- This feature update the sound context in another thread.
							-- With this functionnality, the application is more performant
							-- on multi-core computer. It is also more easy to program the other
							-- aspect of the application because you dont have to think about using
							-- the audio_library.update reguraly. If you use precompile library,
							-- these library must be precompile with multi-thread enable.
				create l_sound.make (a_filename)	-- Open the sound
				if l_sound.is_openable then
					l_sound.open
					if l_sound.is_open then
						audio_library.sources_add					-- Create a new sound source
						audio_library.last_source_added.queue_sound_infinite_loop (l_sound)	-- Queued the sound in the newly created source
						audio_library.last_source_added.play			-- Play the source.		
					end
				end
--			audio_library.stop_thread		-- Destroy the thread created by the "launch_in_thread" feature
		end

end
