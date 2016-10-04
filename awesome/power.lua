local wibox = require("wibox")
local awful = require("awful")


powercfg = {}
powercfg.widget = wibox.widget.textbox()
powercfg.widget:set_align("right");

powercfg.update = function ()
	local fd = io.popen("acpi | cut -d ':' -f 2")
	local status = fd:read("*all")
	fd:close()
	
	local power = tonumber(string.match(status, "%d+")) 
	stats = string.match(status,"(%s+),")
--	local charging = false
--
--	
	local colour = 'blue'
--	-- colours (start and end)
--	local sr, sg, sb = 0x3F,0x3F,0x3F
--	local er, eg, eb = 0xDC, 0xDC, 0xDC
--
--	-- make colour
--	local ir = math.floor(power * (er - sr) + sr)
--	local ib = math.floor(power * (eg - sg) + sg)
--	local ig = math.floor(power * (eb - sb) + sb)
--	--interpol_colour = string.format("%.2x%.2x%.2x", sr, ig, sb)
	interpol_colour = '3f4f3f'
--
--	if charging then
--		colour = 'green'
--	elseif power < 50 then
--		colour = 'yellow'
--	elseif power < 25 then
--		colour = 'orange'
--	elseif power < 10 then
--		colour = 'red'
--	end
	--power = status

	
	text = "<span color='" .. colour .. "' background='#" .. interpol_colour .. "'> " .. power .. "% </span>" .. status

	powercfg.widget.text = text
	powercfg.widget:set_markup(text)
end

-- start updating it
powercfg.update()
powercfg.timer = timer({ timeout = 1})
powercfg.timer:connect_signal("timeout", function () powercfg.update() end)
powercfg.timer:start()
