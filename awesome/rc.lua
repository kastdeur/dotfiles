--
-- Load libraries
--
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
beautiful = require("beautiful")
naughty = require("naughty")

--
-- Configuration
--

AWESOME_CONFDIR = awful.util.getdir('config')
AWESOME_THEME = '/usr/share/awesome/themes/default/theme.lua'

-- HOSTNAME = socket.dns.gethostname()
HOMEDIR = os.getenv('HOME')

TERMINAL = "terminology"
EDITOR = os.getenv("EDITOR") or "vim"
EDITOR_CMD = TERMINAL .. " -e " .. EDITOR
MODKEY = "Mod4"

-- lock = terminal .. " -e xscreensavercmd -lock"
CMD_LOCK = 'xlock -mode rain'
CMD_SUSPEND =  'systemctl suspend'

BROWSER = 'firefox'
FILEMANAGER = 'nemo'

--
-- Run Once
--
function run_once(prg,arg_string,pname,screen)
	if not prg then
		do return nil end
	end
	
	if not pname then
		pname = prg
	end
	
	if not arg_string then 
		awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
	else
		awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
	end
end

run_once("xscreensaver","-no-splash")
run_once("nm-applet")


--
-- Alt-Tab
--
local alttab = require("alttab")
   alttab.settings.preview_box = true                 -- display preview-box
   alttab.settings.preview_box_bg = "#ddddddaa"       -- background color
   alttab.settings.preview_box_border = "#22222200"   -- border-color
   alttab.settings.preview_box_fps = 30               -- refresh framerate
   alttab.settings.preview_box_delay = 150            -- delay in ms

   alttab.settings.client_opacity = false             -- set opacity for unselected clients
   alttab.settings.client_opacity_value = 0.5         -- alpha-value
   alttab.settings.client_opacity_delay = 150         -- delay in ms

--
-- Error Handling
--
require("error")

-- Init Theming
beautiful.init(AWESOME_THEME)

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}


-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
   --  awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
   --  awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
   --  awful.layout.suit.fair,
     awful.layout.suit.fair.horizontal,
     awful.layout.suit.spiral,
   --  awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {"main", "web", "tmux",4,5,"sxc","ru",8,9}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags, s, layouts[1])
end
-- }}}

-- Get topbar, bindings, rules, signals
require("topbar")
require("keybindings")
require("rules")
require("signals")

