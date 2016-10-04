local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function raise_volume()
	os.execute("amixer sset Master 1%+")
end

function lower_volume ()
	os.execute("amixer sset Master 1%-")
end

function toggle_volume ()
	os.execute("amixer sset Master toggle")
end

function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()

   local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
   -- volume = string.format("% 3d", volume)

   status = string.match(status, "%[(o[^%]]*)%]")

   -- starting colour
   local sr, sg, sb = 0x3F, 0x3F, 0x3F
   -- ending colour
   local er, eg, eb = 0xDC, 0xDC, 0xCC

   local ir = math.floor(volume/100 * (er - sr) + sr)
   local ig = math.floor(volume/100 * (eg - sg) + sg)
   local ib = math.floor(volume/100 * (eb - sb) + sb)
   interpol_colour = string.format("%.2x%.2x%.2x", sr, ig, sb)
   if string.find(status, "on", 1, true) then
       volume = " <span color='blue' background='#" .. interpol_colour .. "'>   ".. math.floor(volume) .. "%  </span>"
   else
       volume = " <span color='red' background='#" .. interpol_colour .. "'> M(".. math.floor(volume) .."%) </span>"
   end
   widget:set_markup(volume)
end


-- start updating
update_volume(volume_widget)
mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
