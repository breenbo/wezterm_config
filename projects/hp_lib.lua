local function startup(wezterm)
	local mux = wezterm.mux
	local project_dir = wezterm.home_dir .. "/Documents/homePad/homepad-fe-library"

	local tab, pane, window = mux.spawn_window({
		cwd = project_dir,
		workspace = "homePad",
	})

	tab:set_title("hp_fe_lib")
	pane:send_text("nv\n")
end

return {
	startup = startup,
}
