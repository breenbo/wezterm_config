local wezterm = require("wezterm")
local act = wezterm.action
--
-- table to old config
--
local config = {}
--
-- builder to provide clearer error messages
--
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.color_scheme = "tokyonight_moon"
config.window_decorations = "RESIZE"
config.color_scheme = "tokyonight_moon"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 14
config.inactive_pane_hsb = { hue = 1.0, saturation = 1, brightness = 0.4 }
config.hide_tab_bar_if_only_one_tab = false
config.adjust_window_size_when_changing_font_size = false
config.window_frame = {
	font = wezterm.font({ family = "Comic Sans MS", weight = "Regular" }),
}
--
--
-- workspaces
--
--
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)
--
--
-- keys
--
--
config.send_composed_key_when_left_alt_is_pressed = true
config.disable_default_key_bindings = true
config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	--
	-- remove alt+enter for fullscreen (used in broot)
	--
	{
		key = ":",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "=",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	--
	-- adjust pane sizekeys = {
	--
	{ key = "H", mods = "CMD", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "CMD", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "CMD", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L", mods = "CMD", action = act.AdjustPaneSize({ "Right", 5 }) },
	--
	-- navigate in panes
	--
	{
		key = "h",
		mods = "CMD",
		action = act({ ActivatePaneDirection = "Left" }),
	},
	{
		key = "j",
		mods = "CMD",
		action = act({ ActivatePaneDirection = "Down" }),
	},
	{
		key = "k",
		mods = "CMD",
		action = act({ ActivatePaneDirection = "Up" }),
	},
	{
		key = "l",
		mods = "CMD",
		action = act({ ActivatePaneDirection = "Right" }),
	},
	--
	-- navigate in tabs
	--
	{ key = "&", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "é", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = '"', mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "'", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "(", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "§", mods = "LEADER", action = act({ ActivateTab = 5 }) },
	{ key = "è", mods = "LEADER", action = act({ ActivateTab = 6 }) },
	{ key = "!", mods = "LEADER", action = act({ ActivateTab = 7 }) },
	{ key = "ç", mods = "LEADER", action = act({ ActivateTab = 8 }) },
	{
		key = "X",
		mods = "LEADER|SHIFT",
		action = act({ CloseCurrentTab = { confirm = true } }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act({ CloseCurrentPane = { confirm = true } }),
	},
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	--
	{ key = "X", mods = "CTRL", action = act.ActivateCopyMode },
	--
	-- show launcher
	--
	{
		key = ")",
		mods = "CMD",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	--
	-- workspaces
	--
	{ key = "N", mods = "CTRL", action = act.SwitchWorkspaceRelative(1) },
	{ key = "P", mods = "CTRL", action = act.SwitchWorkspaceRelative(-1) },
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "W",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- change tab title
	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

--
-- manage projects default tab/pane template
--
local project = require("project")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
	project.startup("WZ_PROJECT", "projects", wezterm)
	--
	--
	--
	local scrum_tab, scrum_pane, window = mux.spawn_window({
		workspace = "--- homePad ---",
		cwd = wezterm.home_dir .. "/Documents/homePad/sprints/template",
	})
	scrum_tab:set_title("Scrum")
	scrum_pane:send_text("nv sprintReview.typ\n")
	--
	--
	--
	local admin_tab, admin_pane, _ = window:spawn_tab({
		cwd = wezterm.home_dir .. "/Documents/homePad/homepad_admin",
	})
	admin_tab:set_title("Admin")
	admin_pane:split({ direction = "Left", size = 0.9 })
	--
	--
	--
	local doc_tab, doc_pane, _ = window:spawn_tab({
		cwd = wezterm.home_dir .. "/Documents/homePad/homepad_documents",
	})
	doc_tab:set_title("Docs")
	doc_pane:split({ direction = "Left", size = 0.9 })
	--
	--
	--
	local ticket_tab, ticket_pane, _ = window:spawn_tab({
		cwd = wezterm.home_dir .. "/Documents/homePad/homepad_tickets",
	})
	ticket_tab:set_title("Tickets")
	ticket_pane:split({ direction = "Left", size = 0.9 })
	--
	--
	--
	local login_tab, login_pane, _ = window:spawn_tab({
		cwd = wezterm.home_dir .. "/Documents/homePad/homepad_login",
	})
	login_tab:set_title("Login")
	login_pane:split({ direction = "Left", size = 0.9 })
	--
	--
	--
	scrum_tab:activate()
end)

--
-- return the config
--
return config
