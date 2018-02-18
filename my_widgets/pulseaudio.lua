local wibox			= require("wibox")
local awful 		= require("awful")
-- local beautiful 	= require("beautiful")
local naughty		= require("naughty")
local gears 		= require("gears")
local module_path 	= (...):match ("(.+/)[^/]+$") or ""
local shell   		= require("awful.util").shell

local pulseaudio 	= {}

local function worker(args)
   local args        = args or {}

   -- Settings
   local ICON_DIR =  awful.util.getdir("config").."/"..module_path.."/my_widgets/icons/"
   local timeout = args.timeout or 5
   -- local font = args.font or beautiful.font
   local onclick = args.onclick
   local hidedisconnected = args.hidedisconnected
   local popup_signal  = args.popup_signal or false
   local popup_position = args.popup_position or naughty.config.defaults.position
   local settings    = args.settings or function() end
   local scallback   = args.scallback or nil
   local t_vol_yes = beautiful.volume_icon
   local t_vol_no = beautiful.volume_no_icon
   local t_vol_mute = beautiful.volume_mute_icon

   widget_master = wibox.widget {
      {
         id = "icon",
         image  = t_vol_yes,
         resize = true,
         widget = wibox.widget.imagebox
      },
      border_color = nil,
      min_value = 0,
      max_value = 100,
      value = 0,
      paddings = 0,
      -- forced_width = 30,
      -- forced_height = nil,
      border_width = 3,
      border_color = "#313131",--beautiful.titlebar_bg_normal
      color = beautiful.revelation_fg,
      opacity = 1,
      widget = wibox.container.radialprogressbar,
      set_image = function(self, value)
         self.icon.image = value
      end
   }

   local settings    = args.settings or function() end
   pulseaudio.button_callback = args.button_callback or function() end

   pulseaudio.device = "N/A"
   pulseaudio.muted = "N/A"
   pulseaudio.devicetype = args.devicetype or "sink"
   -- pulseaudio.cmd = args.cmd or "pacmd list-" .. pulseaudio.devicetype .. "s | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' -e '/device\\.string/p'"
   pulseaudio.cmd = args.cmd or "pacmd list-" .. pulseaudio.devicetype .. "s"
   pulseaudio.cmd_set_vol = "pactl set-sink-volume %d %s%d%%"
   pulseaudio.cmd_set_mute = "pactl set-sink-mute %d toggle"

   local function text_grabber()
      local msg = pulseaudio.device

      return msg
   end

   function pulseaudio.update()
      if scallback then pulseaudio.cmd = scallback() end

      awful.spawn.easy_async(
         { shell, "-c", pulseaudio.cmd },
         function(stdout, stderr, reason, exit_codes)
            volume_now = {}
            local x, y = string.find(stdout,'\*%sindex: .*%d+%s-/%s-(%d+)%%%s-/%s-.%d+.%d+%s-dB')

            pulseaudio.level = string.match(string.sub(stdout, x, y), '(%d+)%%') or "N/A"
            -- pulseaudio.device = string.match(stdout,  '\*%sindex: .*device\.product.name = \"(.+)\"[%s]+device\.serial') or "N/A"
            pulseaudio.device = string.match(stdout,  '\*%sindex: .*device\.description = \"(.+)\" [%s%p]+alsa') or "N/A"
            pulseaudio.index = string.match(stdout,  '\*%sindex: (%d+)') or "N/A"
            pulseaudio.muted = string.match(stdout, "\*%sindex: .*muted: (%S+)") or "N/A"
            pulseaudio.sink = index

            local ch = 1
            volume_now.channel = {}
            for v in string.gmatch(stdout, ":.-(%d+)%%") do
               volume_now.channel[ch] = v
               ch = ch + 1
            end

            volume_now.left  = volume_now.channel[1] or "N/A"
            volume_now.right = volume_now.channel[2] or "N/A"

            if widget_master then
               if  (pulseaudio.muted == "no") then
                  widget_master.image = t_vol_yes
                  widget_master.value = tonumber(pulseaudio.level)
               elseif (pulseaudio.muted == "yes") then
                  widget_master.image = t_vol_mute
                  widget_master.value = tonumber(0)
               end
            end

            settings()
         end)
   end

   local notification = nil


   -- pulseaudio.update()
   gears.timer {
      timeout   = timeout,
      autostart = true,
      callback = pulseaudio.update
   }

   -- Bind onclick event function
   if widget_master then
      pulseaudio:attach(widget_master)
   end

   widget_master:connect_signal('mouse::enter', function () pulseaudio:show(0) end)
   widget_master:connect_signal('mouse::leave', function () pulseaudio:hide() end)

   return widget_master
end

local function text_grabber()
   local msg = pulseaudio.device

   return msg
end

function pulseaudio:set_volume(direction, step)
   awful.spawn.easy_async(
      { shell, "-c",  pulseaudio.cmd_set_vol:format(pulseaudio.index, direction, step )},
      function(stdout, stderr, reason, exit_codes)
         pulseaudio.update()
      end)
end

function pulseaudio:set_mute()
   awful.spawn.easy_async(
      { shell, "-c",  pulseaudio.cmd_set_mute:format(pulseaudio.index)},
      function(stdout, stderr, reason, exit_codes)
         pulseaudio.update()
      end)
   -- os.execute(pulseaudio.cmd_set_mute:format(pulseaudio.index))
end

function pulseaudio:hide()
   if notification ~= nil then
      naughty.destroy(notification)
      notification = nil
   end
end

function pulseaudio:show(t_out)
   pulseaudio:hide()

   notification = naughty.notify({
                                    preset = fs_notification_preset,
                                    text = text_grabber(),
                                    timeout = t_out,
                                    screen = mouse.screen,
                                    position = popup_position
                                 })

end

function pulseaudio:attach(widget, args)
   local args = args or {}

   widget:connect_signal('mouse::enter', function () pulseaudio:show(0) end)
   widget:connect_signal('mouse::leave', function () pulseaudio:hide() end)

   widget:buttons(awful.util.table.join( awful.button({ }, 1, function ()
                                                         pulseaudio.button_callback()
                                                         pulseaudio:set_mute() end),
                                         awful.button({ }, 4, function ()
                                                         pulseaudio:set_volume('-', 5) end),
                                         awful.button({ }, 5, function ()
                                                         pulseaudio:set_volume('+', 5) end) ))
   return widget
end


return setmetatable(pulseaudio, {__call = function(_,...) return worker(...) end})
