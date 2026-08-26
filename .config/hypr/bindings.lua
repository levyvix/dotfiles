-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

o.bind("SUPER + PERIOD", "Move to next column", hl.dsp.layout("move +col"))
o.bind("SUPER + COMMA", "Move to previous column", hl.dsp.layout("move -col"))
o.bind("SUPER + SHIFT + PERIOD", "Move window to right column", hl.dsp.layout("movewindowto r"))
o.bind("SUPER + SHIFT + COMMA", "Move window to left column", hl.dsp.layout("movewindowto l"))
o.bind("SUPER + SHIFT + UP", "Move window up", hl.dsp.layout("movewindowto u"))
o.bind("SUPER + SHIFT + DOWN", "Move window down", hl.dsp.layout("movewindowto d"))
hl.unbind("SUPER + semicolon")

hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", "uwsm-app -- /usr/bin/nemo")

hl.unbind("SUPER + ALT + SHIFT + F")
o.bind(
	"SUPER + ALT + SHIFT + F",
	"File manager (cwd)",
	"uwsm-app -- /usr/bin/nemo \"$(omarchy-cmd-terminal-cwd)\""
)

hl.unbind("SUPER + comma")
o.bind("SUPER + ccedilla", "Dismiss last notification", "omarchy-shell notifications dismissOne")

hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Google Calendar", { webapp = "https://calendar.google.com/" })

hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Gmail", { webapp = "https://mail.google.com/" })

-- SUPER+F is fullscreen by default; scrolling layout uses it for fit.
o.bind("SUPER + R", "Resize column", hl.dsp.layout("colresize +conf"))
o.bind("SUPER + H", "Half-width column", hl.dsp.layout("colresize 0.5"))
o.bind(
	"SUPER + SHIFT + M",
	"YouTube Music",
	"omarchy-launch-or-focus-webapp 'YouTube Music' 'https://music.youtube.com/'"
)
