local wibox			= require("wibox")
local awful 		= require("awful")
local lain 			= require("lain")

-- {{{ Battery widget
-- Wibox Icon
batteryIcon = wibox.widget.imagebox(beautiful.widget_battery)
batteryWidget = lain.widgets.bat({
    ac = "AC", -- ls /sys/class/power_supply = "AC"
    settings = function()
        if bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                widget:set_markup(" AC ")
                batteryIcon:set_image(beautiful.bat_ac)
                return
        elseif tonumber(bat_now.perc) <= 15 then batteryIcon:set_image(beautiful.bat_empty)
          -- It works eh?
          if tonumber(bat_now.perc) <= 5 then
            naughty.notify({
              preset     = naughty.config.presets.critical,
              title      = "Low battery",
              text       = "Connect your charger, " .. bat_now.perc .."% remaining.",
              timeout    = 10
            })
          else
            naughty.notify({
              title      = "Low battery",
              text       = "Connect your charger, " .. bat_now.perc .."% remaining.",
              timeout    = 10
            })
          end
        elseif tonumber(bat_now.perc) <= 25 then batteryIcon:set_image(beautiful.bat_low)
        elseif tonumber(bat_now.perc) <= 50 then batteryIcon:set_image(beautiful.bat_med)
        elseif tonumber(bat_now.perc) <= 75 then batteryIcon:set_image(beautiful.bat_high)
        else batteryIcon:set_image(beautiful.bat_full)
        end
        widget:set_markup(" " .. bat_now.perc .. "% ")
    else
       batteryIcon:set_image(beautiful.widget_ac)
    end
  end
})
batteryIcon:connect_signal("mouse::enter", function ()
     options = { title = "Battery status:", text = "Remaining: " .. bat_now.perc .. " %",
                 timeout = 0, hover_timeout = 0.5,
                 screen = mouse.screen }
     widget.hover = naughty.notify(options) end)
batteryIcon:connect_signal("mouse::leave", function () naughty.destroy(widget.hover) end)
-- }}}
