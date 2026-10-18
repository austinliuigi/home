local palette = require(os.getenv("HOME") .. "/.local/share/hyprland/palette.lua")

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 3,
		no_focus_fallback = true, -- don't wrap when changing window focus

		col = {
			active_border = palette.palette.base0A,
			inactive_border = palette.palette.base01 .. "00",
			nogroup_border_active = palette.palette.base0D,
			nogroup_border = palette.palette.base01 .. "00",
		},

		layout = "scrolling",
	},

	master = {
		new_status = "slave",
		mfact = 0.5,
	},

	scrolling = {
		-- workspaces with one window will always fullscreen that window
		fullscreen_on_one_column = true,
		follow_focus = true,
		follow_min_visible = 0.75,

		direction = "right",
	},

	decoration = {
		rounding = 5,
		active_opacity = 0.97,
		inactive_opacity = 0.97,
		dim_inactive = true,
		dim_strength = 0.05,

		blur = {
			enabled = true,
			size = 5,
			passes = 1,
			xray = false,
		},

		shadow = {
			enabled = false,
			range = 3,
			render_power = 3,
			color = "#000000CC",
		},

		glow = {
			enabled = false,
		},

		motion_blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},

	cursor = {
		inactive_timeout = 0,
	},

	input = {
		kb_layout = "us",
		repeat_rate = 30,
		repeat_delay = 250,
		follow_mouse = 1,

		touchpad = {
			disable_while_typing = true,
			clickfinger_behavior = true,
			tap_to_click = false,
			natural_scroll = true,
			drag_3fg = 0,
		},
	},

	gestures = {
		workspace_swipe_cancel_ratio = 0.25,
		workspace_swipe_min_speed_to_force = 1,
		scrolling = {
			move_snap_to_grid = false,
			move_snap_cursor = false,
		},
	},

	misc = {
		disable_hyprland_logo = true,
		on_focus_under_fullscreen = 2,
	},
})
