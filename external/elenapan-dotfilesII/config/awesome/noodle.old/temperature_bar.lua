local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = beautiful.temperature_bar_active_color or "#5AA3CC"
local background_color = beautiful.temperature_bar_background_color or "#222222"

-- Configuration
local update_interval = 15            -- in seconds

local temperature_bar = wibox.widget{
  max_value     = 100,
  value         = 50,
  forced_height = 10,
  margins       = {
    top = 10,
    bottom = 10,
  },
  forced_width  = 200,
  shape         = gears.shape.rounded_bar,
  bar_shape     = gears.shape.rounded_bar,
  color         = active_color,
  background_color = background_color,
  border_width  = 0,
  border_color  = beautiful.border_color,
  widget        = wibox.widget.progressbar,
}

local function update_widget(temp_cur, temp_max)
   temperature_bar.value = temp_cur
   temperature_bar.max_value = temp_max
end

-- local temp_script = [[
--   bash -c "
--   sensors | grep Package | awk '{printf \"%d\", $4}' | cut -c 2-3
--   "]]

local temp_script = [[
  bash -c "
  sensors | grep Package |sed 's/(\|)\|°C\|+\|,//g' | awk  '{printf \"%s@@%s@\", $7, $10}'
  "]]

awful.widget.watch(temp_script, update_interval, function(widget, stdout)
                      local cur = tonumber(stdout:match('(.*)@@'))
                      local max = tonumber(stdout:match('@@(.*)@'))
                      -- temp = string.gsub(temp, '^%s*(.-)%s*$', '%1')
                      -- temp = tonumber(string.match(".*"))
                      update_widget(cur, max)
end)

return temperature_bar
