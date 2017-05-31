local wibox			= require("wibox")
local awful 		= require("awful")
local beautiful 	= require("beautiful")
local naughty		= require("naughty")
local gears 		= require("gears")
local module_path 	= (...):match ("(.+/)[^/]+$") or ""
local shell   		= require("awful.util").shell

local pulseaudio 	= {}

local function worker(args)
   local args        = args or {}

   -- Settings
   local ICON_DIR = awful.util.getdir("config").."/"..module_path.."/my_widgets/icons/"
   local timeout = args.timeout or 5
   local font = args.font or beautiful.font
   local onclick = args.onclick
   local hidedisconnected = args.hidedisconnected
   local popup_signal  = args.popup_signal or false
   local popup_position = args.popup_position or naughty.config.defaults.position
   local settings    = args.settings or function() end
   local scallback   = args.scallback or nil
   local widget 	= wibox.container.background()
   local settings    = args.settings or function() end
   local volume_yes = wibox.widget {
      {
         widget = wibox.widget.imagebox,
         image = ICON_DIR.."vol.png",
         resize = false,
      },
      layout = wibox.container.margin(brightness_icon, 0, 0, 2)
   }
   local volume_no = wibox.widget {
      {
         widget = wibox.widget.imagebox,
         image = ICON_DIR.."vol_mute.png",
         resize = false,
      },
      layout = wibox.container.margin(brightness_icon, 0, 0, 2)
   }


   local volume_text = wibox.widget.textbox()
   volume_text:set_text(" N/A ")

   pulseaudio.device = "N/A"
   pulseaudio.muted = "N/A"
   pulseaudio.devicetype = args.devicetype or "sink"
   -- pulseaudio.cmd = args.cmd or "pacmd list-" .. pulseaudio.devicetype .. "s | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' -e '/device\\.string/p'"
   pulseaudio.cmd = args.cmd or "pacmd list-" .. pulseaudio.devicetype .. "s"

   local function text_grabber()
      local msg = pulseaudio.device

      return msg
   end

   function pulseaudio.update()
      if scallback then pulseaudio.cmd = scallback() end

      awful.spawn.easy_async(
         { shell, "-c", pulseaudio.cmd },
         function(stdout, stderr, reason, exit_codes)
            volume_now = {
               index =  string.match(stdout,  '\*%sindex: (%d+)') or "N/A",
               device = string.match(stdout,  '\*%sindex: .*device\.product.name = \"(.+)\"[%s]+device\.serial')
                  or "N/A",
               sink   = device, -- legacy API
               muted  = string.match(stdout, "'\*%sindex: .*muted: (%S+)") or "N/A"
            }

            pulseaudio.device = volume_now.device
            pulseaudio.index = volume_now.index
            pulseaudio.muted = volume_now.muted

            local ch = 1
            volume_now.channel = {}
            for v in string.gmatch(stdout, ":.-(%d+)%%") do
               volume_now.channel[ch] = v
               ch = ch + 1
            end

            volume_now.left  = volume_now.channel[1] or "N/A"
            volume_now.right = volume_now.channel[2] or "N/A"

            -- widget = pulseaudio.widget

            settings()
         end)

      if widget then
         if  (pulseaudio.muted == "no") then
            widget:set_widget(volume_yes)
         elseif (pulseaudio.muted == "yes") then
            widget:set_widget(volume_no)
         end
      end
   end

   -- pulseaudio.update()
   gears.timer {
    timeout   = timeout,
    autostart = true,
    callback = pulseaudio.update
   }

   widget:set_widget(volume_yes)
   if widget then
      -- widget:set_widget(volume_yes)
      -- Hide the text when we want to popup the signal instead
      -- if not popup_signal then
      --    widget:set_widget(volume_no)
      -- end
      pulseaudio:attach(widget,{onclick = onclick})
   end


   local notification = nil

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

   -- Bind onclick event function
   if onclick then
      widget:buttons(awful.util.table.join(
                        awful.button({}, 1, function() awful.util.spawn(onclick) end)
                                          ))
   end

   widget:connect_signal('mouse::enter', function () pulseaudio:show(0) end)
   widget:connect_signal('mouse::leave', function () pulseaudio:hide() end)
   return widget
end

function pulseaudio:attach(widget, args)
   local args = args or {}
   local onclick = args.onclick
   -- Bind onclick event function
   if onclick then
      widget:buttons(awful.util.table.join(
                        awful.button({}, 1, function() awful.util.spawn(onclick) end)
                                          ))
   end
   widget:connect_signal('mouse::enter', function () pulseaudio:show(0) end)
   widget:connect_signal('mouse::leave', function () pulseaudio:hide() end)
   return widget
end


return setmetatable(pulseaudio, {__call = function(_,...) return worker(...) end})
