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
   local t_vol_yes = "<span size=\"larger\"> 🔉 </span>"
   local t_vol_no = "<span size=\"larger\"> 🔈 </span>"
   local t_vol_mute =  "<span size=\"larger\" color=\"#DC0000\"> 🔇 </span>"

   volume_text = wibox.widget {
      align  = 'center',
      valign = 'center',
      markup = t_vol_no,
      widget = wibox.widget.textbox}
   widget_master = wibox.container.radialprogressbar()
   widget_master.widget 	=  volume_text

   widget_master.border_color = nil
   widget_master.min_value = 0
   widget_master.max_value = 100
   widget_master.value = 0
   widget_master.forced_width = 40
   widget_master.border_width = 2
   widget_master.border_color = beautiful.titlebar_bg_normal
   widget_master.color = beautiful.revelation_fg
   widget_master.opacity = 1
   -- widget_master.wiget =  wibox.widget.textbox()
   -- widget_master.wiget:set_text("dsa")

   local settings    = args.settings or function() end


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
            --    index =  string.match(stdout,  '\*%sindex: (%d+)') or "N/A",
            --    device = string.match(stdout,  '\*%sindex: .*device\.product.name = \"(.+)\"[%s]+device\.serial') or "N/A",
            --    sink   = device, -- legacy API
            --    muted  = string.match(stdout, "\*%sindex: .*muted: (%S+)") or "N/A",
            -- }

            local x, y = string.find(stdout,'%d+%s-/%s-(%d+)%%%s-/%s-.%d+.%d+%s-dB')

            -- pulseaudio.level = string.match(string.sub(stdout, x, y), '(%d+)%%')
            -- pulseaudio.device = volume_now.device
            -- pulseaudio.index = volume_now.index
            -- pulseaudio.muted = volume_now.muted
            -- pulseaudio.sink = volume_now.sink

            pulseaudio.level = string.match(string.sub(stdout, x, y), '(%d+)%%') or "N/A"
            pulseaudio.device = string.match(stdout,  '\*%sindex: .*device\.product.name = \"(.+)\"[%s]+device\.serial') or "N/A"
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
               -- volume_yes.shape.radial_progress(cr, 70, 20, .3)
               if  (pulseaudio.muted == "no") then
                  --                widget_master:set_widget(volume_yes)
                  volume_text:set_markup_silently(t_vol_yes)
                  widget_master.value = tonumber(pulseaudio.level)
                  -- widget_master.widget.text("!!!!!")

               elseif (pulseaudio.muted == "yes") then
                  --                  widget:set_widget(volume_no)
                 volume_text:set_markup_silently(t_vol_mute)
                  -- widget_master.wiget:set_text("??")

               end
            end

            -- pulseaudio.level = volume_now.left
            settings()
         end)
   end

   local notification = nil

   function pulseaudio:set_volume(direction, step)
      awful.spawn.easy_async(
         { shell, "-c",  pulseaudio.cmd_set_vol:format(pulseaudio.index, direction, step )},
         function(stdout, stderr, reason, exit_codes)
            pulseaudio.update()
         end)
      -- os.execute(pulseaudio.cmd_set_vol:format(pulseaudio.index, direction, step ))
      -- pulseaudio.update()
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

   -- pulseaudio.update()
   gears.timer {
      timeout   = timeout,
      autostart = true,
      callback = pulseaudio.update
   }

   -- widget:set_widget(volume_yes)
--   volume_text:set_text(t_vol_no)
   -- widget_master.widget:set_text("!")

   -- Bind onclick event function
   if onclick then
      widget:buttons(awful.util.table.join(
                        awful.button({}, 1, function() awful.util.spawn(onclick) end)
                                          ))
   end

   if widget_master then
      -- widget_master:set_widget(volume_yes)
      -- Hide the text when we want to popup the signal instead
      -- if not popup_signal then
      --    widget_master:set_widget(volume_no)
      -- end
      -- volume_text:set_text(t_vol_no)
--      widget_master.wiget:set_text("🔉")
 --     volume_text:set_text("🔉")
      pulseaudio:attach(widget_master,{onclick = onclick})
   end

   widget_master:connect_signal('mouse::enter', function () pulseaudio:show(0) end)
   widget_master:connect_signal('mouse::leave', function () pulseaudio:hide() end)

   return widget_master
end

function pulseaudio:attach(widget, args)
   local args = args or {}
   local onclick = args.onclick

   -- pulseaudio.icons     = args.icons or awful.util.getdir("config").."/"..module_path.."/my_widgets/icons/"
   -- pulseaudio.font      = args.font or beautiful.font:sub(beautiful.font:find(""),
   --                                                        beautiful.font:find(" "))
   -- pulseaudio.font_size = tonumber(args.font_size) or 11
   -- pulseaudio.fg        = args.fg or beautiful.fg_normal or "#FFFFFF"
   -- pulseaudio.bg        = args.bg or beautiful.bg_normal or "#FFFFFF"
   -- pulseaudio.position  = args.position or "top_right"

   -- Bind onclick event function
   if onclick then
      widget:buttons(awful.util.table.join(
                        awful.button({}, 1, function() awful.util.spawn(onclick) end)
                                          ))
   end
   widget:connect_signal('mouse::enter', function () pulseaudio:show(0) end)
   widget:connect_signal('mouse::leave', function () pulseaudio:hide() end)

   widget:buttons(awful.util.table.join( awful.button({ }, 1, function ()
                                                         pulseaudio:set_mute() end),
                                         awful.button({ }, 4, function ()
                                                         pulseaudio:set_volume('-', 5) end),
                                         awful.button({ }, 5, function ()
                                                         pulseaudio:set_volume('+', 5) end) ))
   return widget
end


return setmetatable(pulseaudio, {__call = function(_,...) return worker(...) end})
