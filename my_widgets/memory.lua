local gears 		= require("gears")
local wibox			= require("wibox")
local lain 			= require("lain")

local memory = {}

local function worker(args)
   local timeout = args.timeout or 5
   local args     = args or {}
   local brd_color = args.brd_color or beautiful.titlebar_bg_normal
   local settings = args.settings or function() end
   local gmatch, lines, floor = string.gmatch, io.lines, math.floor

   local widget_master = wibox.widget {
      {
         id = "icon",
         image = beautiful.memory,
         resize = true,
         widget = wibox.widget.imagebox
      },
      min_value = 0,
      max_value = 100,
      value = memory.perc,
      paddings = 0,
      -- forced_width = 30,
      -- forced_height = nil,
      border_width = 3,
      border_color = brd_color,
      color = beautiful.border_focus,
      opacity = 1,
      widget = wibox.container.radialprogressbar,
      set_image = function(self, value)
         self.icon.image = value
      end
   }


   function memory.update()
      mem_now = {}
      for line in lines("/proc/meminfo") do
         for k, v in gmatch(line, "([%a]+):[%s]+([%d]+).+") do
            if     k == "MemTotal"     then mem_now.total = floor(v / 1024 + 0.5)
            elseif k == "MemFree"      then mem_now.free  = floor(v / 1024 + 0.5)
            elseif k == "Buffers"      then mem_now.buf   = floor(v / 1024 + 0.5)
            elseif k == "Cached"       then mem_now.cache = floor(v / 1024 + 0.5)
            elseif k == "SwapTotal"    then mem_now.swap  = floor(v / 1024 + 0.5)
            elseif k == "SwapFree"     then mem_now.swapf = floor(v / 1024 + 0.5)
            elseif k == "SReclaimable" then mem_now.srec  = floor(v / 1024 + 0.5)
            end
         end
      end

      mem_now.used = mem_now.total - mem_now.free - mem_now.buf - mem_now.cache - mem_now.srec
      mem_now.swapused = mem_now.swap - mem_now.swapf
      mem_now.perc = math.floor(mem_now.used / mem_now.total * 100)

      widget_master.value = mem_now.perc
   end

   gears.timer {
      timeout   = timeout,
      autostart = true,
      callback = memory.update
   }

   return widget_master
end

return setmetatable(memory, {__call = function(_,...) return worker(...) end})
