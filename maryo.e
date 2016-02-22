note
	description: "[
					Our main character.
					Using animation with 4 states using 3 sub images
				]"
	author: "Louis Marchand"
	date: "Wed, 01 Apr 2015 18:46:46 +0000"
	revision: "2.0"

class
	MARYO

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
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
					create down_surface.make_from_image (l_image)
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
			is_dirty := True
		end

	initialize_animation_coordinate
			-- Create the `animation_coordinates'
		do
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(4)
			animation_coordinates.extend ([surface.width // 3, 0])	-- Be sure to place the image standing still first
			animation_coordinates.extend ([0, 0])
			animation_coordinates.extend ([(surface.width // 3) * 2, 0])
			animation_coordinates.extend ([0, 0])
			sub_image_x := animation_coordinates.at (1).x
			sub_image_y := animation_coordinates.at (1).y
		end

feature -- Access

	has_error:BOOLEAN
			-- Is an error happen when initializing the `surface'

	update(a_timestamp:NATURAL_32)
			-- Update the surface depending on the present `a_timestamp'.
			-- Each 100 ms, the image change; each 10ms `Current' is moving
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
						x := x + (l_delta_time // movement_delta).to_integer_32
					elseif going_left then
						surface := left_surface
						x := x - (l_delta_time // movement_delta).to_integer_32
					elseif going_up then
						surface := up_surface
						y := y - (l_delta_time // movement_delta).to_integer_32
					elseif going_down then
						surface := down_surface
						y := y + (l_delta_time // movement_delta).to_integer_32
					end
					old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
					is_dirty := True
				end
			end
		end

	go_left(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move left
		do
			old_timestamp := a_timestamp
			going_left := True
		end

	go_right(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move right
		do
			old_timestamp := a_timestamp
			going_right := True
		end

	go_up(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move up
		do
			old_timestamp := a_timestamp
			going_up := True
		end

	go_down(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move down
		do
			old_timestamp := a_timestamp
			going_down := True
		end

	stop_left
			-- Make `Current' stop moving to the left
		do
			going_left := False
			if not going_right then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
				is_dirty := True
			end
		end

	stop_right
			-- Make `Current' stop moving to the right
		do
			going_right := False
			if not going_left then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
				is_dirty := True
			end
		end

	stop_up
			-- Make `Current' stop moving to the left
		do
			going_up := False
			if not going_down then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
				is_dirty := True
			end
		end

	stop_down
			-- Make `Current' stop moving to the right
		do
			going_down := False
			if not going_up then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
				is_dirty := True
			end
		end

	going_left:BOOLEAN
			-- Is `Current' moving left

	going_right:BOOLEAN
			-- Is `Current' moving right

	going_up:BOOLEAN
			-- Is `Current' moving up

	going_down:BOOLEAN
			-- Is `Current' moving down

	x:INTEGER assign set_x
			-- Vertical position of `Current'

	y:INTEGER assign set_y
			-- Horizontal position of `Current'

	set_x(a_x:INTEGER)
			-- Assign the value of `x' with `a_x'
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	set_y(a_y:INTEGER)
			-- Assign the value of `y' with `a_y'
		do
			y := a_y
		ensure
			Is_Assign: y = a_y
		end

	sub_image_x, sub_image_y:INTEGER
			-- Position of the portion of image to show inside `surface'

	sub_image_width, sub_image_height:INTEGER
			-- Dimension of the portion of image to show inside `surface'

	surface:GAME_SURFACE
			-- The surface to use when drawing `Current'

	is_dirty:BOOLEAN
			-- If True, `Current' has been modified and have to be redraw.

	unset_dirty
			-- `Current's modification have been managed so set `is_dirty' to False
		do
			is_dirty := False
		end

feature {NONE} -- implementation

	animation_coordinates:LIST[TUPLE[x,y:INTEGER]]
			-- Every coordinate of portion of images in `surface'

	old_timestamp:NATURAL_32
			-- When appen the last movement (considering `movement_delta')

feature {NONE} -- constants

	movement_delta:NATURAL_32 = 10
			-- The delta time between each movement of `Current'

	animation_delta:NATURAL_32 = 100
			-- The delta time between each animation of `Current'

	left_surface:GAME_SURFACE

	right_surface:GAME_SURFACE

	up_surface:GAME_SURFACE

	down_surface:GAME_SURFACE

end
