local function startup(wezterm)
	local mux = wezterm.mux
	local project_dir = wezterm.home_dir .. "/Documents/homePad/homepad_admin"

	local tab, pane, window = mux.spawn_window({
		cwd = project_dir,
		workspace = "homePad",
	})

	tab:set_title("node_hp_admin")
	pane:send_text("npm run dev\n")

	local code_tab, code_pane = window:spawn_tab({
		cwd = project_dir,
	})

	code_tab:set_title("hp_admin")
	code_pane:send_text("nv\n")
end

return {
	startup = startup,
}
