-- Volume widget
local awful = require("awful")
local wibox = require("wibox")

volumecfg = {}
volumecfg.channel = "Master"

volumecfg.widget = wibox.widget.textbox()
volumecfg.widget:set_align("right")
volumecfg.widget.name = 'volumecfg.widget'

volumecfg_t = awful.tooltip({ objects = { volumecfg.widget },})
volumecfg_t:set_text("Volume")

-- command must start with a space!
volumecfg.mixercommand = function (command)
	local fd = io.popen("amixer " .. command)
	local status = fd:read("*all")
	fd:close()
	
	local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
	-- volume = string.format("% 3d", volume)
	status = string.match(status, "%[(o[^%]]*)%]")

	-- starting colour
	local sr, sg, sb = 0x3F, 0x3F, 0x3F
	-- ending colour
	local er, eg, eb = 0xDC, 0xDC, 0xCC
	
	if string.find(status, "on", 1, true) then
		color = 'blue'
		mute = '♪'
	else
		sr, sg, sb = 0xFF, 0x33, 0xAA
		color = 'red'
		mute = 'M'
	end
	
	local ir = math.floor(volume/100 * (er - sr) + sr)
	local ig = math.floor(volume/100 * (eg - sg) + sg)
	local ib = math.floor(volume/100 * (eb - sb) + sb)
	interpol_colour = string.format("%.2x%.2x%.2x", sr, ig, sb)
	
	volume = " <span color='" .. color .. "' background='#" .. interpol_colour .. "'>   ".. mute .. math.floor(volume) .. "%  </span>"
--	              volume = volume .. "%"


	volumecfg.widget.text = volume
	volumecfg.widget:set_markup(volume)

end
volumecfg.update = function ()
       volumecfg.mixercommand(" sget " .. volumecfg.channel)
end
volumecfg.up = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1%+")
end
volumecfg.down = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1%-")
end
volumecfg.toggle = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " toggle")
end
volumecfg.widget:buttons(awful.util.table.join(
	awful.button({ }, 4, function () volumecfg.up() end),
	awful.button({ }, 5, function () volumecfg.down() end),
	awful.button({ }, 1, function () volumecfg.toggle() end),
	awful.button({ }, 3, function () os.execute("pavucontrol &") end)
))
-- start updating
volumecfg.update()
mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () volumecfg.update() end)
mytimer:start()
