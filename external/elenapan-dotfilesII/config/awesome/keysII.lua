local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local keys = {}

-- Mod keys
modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"



local awful = require('awful')
--local lunaconf = require('lunaconf')
--local pulseaudio = my_widgets.pulseaudio

local function brightness_control(which)
	awful.spawn.easy_async(lunaconf.utils.scriptpath() .. 'brightness.sh ' .. which, function(out)
		local value = tonumber(out)
        local dialog = lunaconf.dialogs.bar('preferences-system-brightness-lock', 1)
		dialog:set_value(value)
		dialog:show()
	end)
end


local function exit_session()
   awesome.quit()
end

-- {{{ Mouse bindings on desktop
keys.desktopbuttons = gears.table.join(
    awful.button({ }, 1, function ()
        mymainmenu:hide()
        sidebar.visible = false
        naughty.destroy_all_notifications()

        local function double_tap()
          uc = awful.client.urgent.get()
          -- If there is no urgent client, go back to last tag
          if uc == nil then
            awful.tag.history.restore()
          else
            awful.client.urgent.jumpto()
          end
        end
        helpers.single_double_tap(nil, double_tap)
    end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),

    -- Middle button - Toggle sidebar
    awful.button({ }, 2, function ()
        sidebar.visible = not sidebar.visible
    end),

    -- Scrolling - Switch tags
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),

    -- Side buttons - Control volume
    awful.button({ }, 9, function () awful.spawn.with_shell("volume-control.sh up") end),
    awful.button({ }, 8, function () awful.spawn.with_shell("volume-control.sh down") end)

    -- Side buttons - Minimize and restore minimized client
    -- awful.button({ }, 8, function()
    --     if client.focus ~= nil then
    --         client.focus.minimized = true
    --     end
    -- end),
    -- awful.button({ }, 9, function()
    --       local c = awful.client.restore()
    --       -- Focus restored client
    --       if c then
    --           client.focus = c
    --           c:raise()
    --       end
    -- end)
)
-- }}}

-- {{{ Key bindings
keys.globalkeys = gears.table.join(
   -- awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
   --           {description="show help", group="awesome"}),
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
             {description = "view previous", group = "tag"}),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
             {description = "view next", group = "tag"}),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
             {description = "go back", group = "tag"}),

   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx( 1)
             end,
             {description = "focus next by index", group = "client"}
   ),
   awful.key({ modkey,           }, "k",
             function ()
                awful.client.focus.byidx(-1)
             end,
             {description = "focus previous by index", group = "client"}
   ),
   awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
             {description = "show main menu", group = "awesome"}),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
             {description = "swap with next client by index", group = "client"}),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
             {description = "swap with previous client by index", group = "client"}),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
             {description = "focus the next screen", group = "screen"}),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
             {description = "focus the previous screen", group = "screen"}),
   awful.key({ altkey,           }, "Tab", function () awful.screen.focus_relative(-1) end,
             {description = "focus the next screen", group = "screen"}),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
             {description = "jump to urgent client", group = "client"}),
   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus then
                   client.focus:raise()
                end
             end,
             {description = "go back", group = "client"}),

   -- Standard program
   awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
             {description = "open a terminal", group = "launcher"}),
   awful.key({ modkey, "Control" }, "r", awesome.restart,
             {description = "reload awesome", group = "awesome"}),
   awful.key({ modkey, "Shift"   }, "q", exit_session,
             {description = "quit awesome", group = "awesome"}),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
             {description = "increase master width factor", group = "layout"}),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
             {description = "decrease master width factor", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
             {description = "increase the number of master clients", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
             {description = "decrease the number of master clients", group = "layout"}),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
             {description = "increase the number of columns", group = "layout"}),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
             {description = "decrease the number of columns", group = "layout"}),
   awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
             {description = "select next", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
             {description = "select previous", group = "layout"}),

   awful.key({ modkey, "Control" }, "n",
             function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                   client.focus = c
                   c:raise()
                end
             end,
             {description = "restore minimized", group = "client"}),

   -- Prompt
   awful.key({ modkey },            "r",
             function ()
                run_once("rofi -show")
                -- awful.screen.focused().mypromptbox:run()
             end,
             { description = "run prompt", group = "launcher" }
   ),


   awful.key({ modkey }, "x",
             function ()
                awful.prompt.run {
                   prompt       = "Run Lua code: ",
                   textbox      = awful.screen.focused().mypromptbox.widget,
                   exe_callback = awful.util.eval,
                   history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
             end,
             {description = "lua execute prompt", group = "awesome"}),
   -- Menubar
   awful.key({ modkey }, "p", function() menubar.show() end,
             {description = "show the menubar", group = "launcher"}),

   -- User Binds

   -- Copy to clipboard
   -- awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

   -- User programs
   awful.key({ modkey, "Shift"   }, "b", function () awful.spawn(browser) end,
             {
                description = "open a browser",
                group = "launcher"
             }
   ),
   awful.key({ modkey, "Shift" }, "d", function () awful.spawn(filemanager) end,
             {
                description = "open a file manager",
                group = "launcher"
             }
   ),
   awful.key({ modkey, "Control" }, "d",
             function ()
                awful.spawn(cfilemanager, {tag = "2"})
             end,
             {
                description = "open a console file manager",
                group = "launcher"
             }
   ),
   awful.key({ modkey, "Shift" }, "e", function () awful.spawn(editorGui) end,
             {
                description = "open a file manager",
                group = "launcher"
             }
   ),
   awful.key({ modkey,	       }, "e", function () awful.spawn(mail) end,
             {
                description = "open a mail client",
                group = "launcher"
             }
   ),
   awful.key({      	       }, "XF86Mail", function () kill_and_run(mail) end,
             {
                description = "open a mail client",
                group = "launcher"
             }
   ),
   awful.key({ modkey,       }, "XF86Calculator", function () awful.spawn("gcalctool") end,
             {
                description = "open a calculator",
                group = "launcher"
             }
   ),
   -- Take a screenshot
   awful.key({  			 }, "Print", function()
                run_check("xfce4-screenshooter") end, -- "gnome-screenshot -c -a -f ~/Изображения/ScreenShot/$(date  +%y%h%d-%H%M%S).png"
             {
                description = "take a screenshot",
                group = "launcher"
             }
   ),


   -- Other
   awful.key({                 }, "Pause",  function() awful.spawn(xscreen_lock) end,
             {
                description = "lock of a screen",
                group = "screen"
             }
   ),

   -- MPD control
   awful.key({			 }, "XF86AudioPlay",
             function ()
                awful.spawn_with_shell(music_play)
                mpdwidget.update()
             end,
             {
                description = "Play",
                group = "Control of a music"
             }
   ),
   awful.key({			 }, "XF86AudioStop",
             function ()
                awful.spawn_with_shell(music_stop)
                mpdwidget.update()
             end,
             {
                description = "Stop",
                group = "Control of a music"
             }
   ),
   awful.key({ }, "XF86AudioPrev",
             function ()
                awful.spawn_with_shell(music_prev)
                mpdwidget.update()
             end,      {
                description = "Previous",
                group = "Control of a music"
                       }
   ),

   awful.key({ }, "XF86AudioNext",
             function ()
                awful.spawn_with_shell(music_next)
                mpdwidget.update()
             end,
             {
                description = "Next",
                group = "Control of a music"
             }
   ),


   -- MPD control
   awful.key({ altkey, "Control" }, "Up",
             function ()
                awful.spawn_with_shell(music_play)
                mpdwidget.update()
             end,
             {
                description = "Play",
                group = "Control of a music"
             }
   ),

   awful.key({ altkey, "Control" }, "Down",
             function ()
                awful.spawn_with_shell(music_stop)
                mpdwidget.update()
             end,
             {
                description = "Stop",
                group = "Control of a music"
             }
   ),

   awful.key({ altkey, "Control" }, "Left",
             function ()
                awful.spawn_with_shell(music_prev)
                mpdwidget.update()
             end,
             {
                description = "Previous",
                group = "Control of a music"
             }
   ),
   awful.key({ altkey, "Control" }, "Right",
             function ()
                awful.spawn_with_shell(music_next)
                mpdwidget.update()
             end,
             {
                description = "Next",
                group = "Control of a music"
             }
   ),
   awful.key({}, 'XF86MonBrightnessUp',
             function()
                brightness_control('up')
             end,
             {
                description = "Brightness UP",
                group = "Control of a screen"
             }
   ),
   awful.key({ 'Shift' }, 'XF86MonBrightnessUp',
             function()
                brightness_control('up small')
             end,
             {
                description = "Brightness small UP",
                group = "Control of a screen"
             }
   ),
   awful.key({}, 'XF86MonBrightnessDown',
             function()
                brightness_control('down')
             end,
             {
                description = "Brightness DOWN",
                group = "Control of a screen"
             }
   ),
   awful.key({ 'Shift' }, 'XF86MonBrightnessDown',
             function()
                brightness_control('down small')
             end,
             {
                description = "Brightness small DOWN",
                group = "Control of a screen"
             }
   )
   -- awful.key({}, 'XF86AudioRaiseVolume',
   --           function()
   --              pulseaudio:set_volume('+', 5)
   --              local dialog = lunaconf.dialogs.bar(beautiful.volume_icon, 1)
   --              dialog:set_value(pulseaudio.level)
   --              dialog:show()
   --           end,
   --           {
   --              description = "Volume UP",
   --              group = "Management of a periphery"
   --           }
   -- ),
   -- awful.key({}, 'XF86AudioLowerVolume',
   --           function()
   --              pulseaudio:set_volume('-', 5)
   --              local dialog = lunaconf.dialogs.bar(beautiful.volume_low_icon, 1)
   --              dialog:set_value(pulseaudio.level)
   --              dialog:show()
   --           end,
   --           {
   --              description = "Volume DOWN",
   --              group = "Management of a periphery"
   --           }
   -- ),
   -- awful.key({}, 'XF86AudioMute',
   --           function()
   --              pulseaudio:set_mute()
   --              if ( pulseaudio.muted == "no" ) then
   --                 local dialog = lunaconf.dialogs.bar(beautiful.volume_mute_icon, 1)
   --                 dialog:set_value(0)
   --                 dialog:show()
   --              elseif (pulseaudio.muted == "yes") then
   --                 local dialog = lunaconf.dialogs.bar(beautiful.volume_icon, 1)
   --                 dialog:set_value(pulseaudio.level)
   --                 dialog:show()
   --              end
   --           end,
   --           {
   --              description = "Volume DOWN",
   --              group = "Management of a periphery"
   --           }
   -- )
)

keys.clientkeys = gears.table.join(
   awful.key({ modkey,           }, "f",
             function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
             end,
             {description = "toggle fullscreen", group = "client"}),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
             {description = "close", group = "client"}),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
             {description = "toggle floating", group = "client"}),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
             {description = "move to master", group = "client"}),
   awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
             {description = "move to screen", group = "client"}),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
             {description = "toggle keep on top", group = "client"}),
   awful.key({ modkey,           }, "n",
             function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
             end ,
             {description = "minimize", group = "client"}),
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized = not c.maximized
                c:raise()
             end ,
             {description = "(un)maximize", group = "client"}),
   awful.key({ modkey, "Control" }, "m",
             function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
             end ,
             {description = "(un)maximize vertically", group = "client"}),
   awful.key({ modkey, "Shift"   }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
             end ,
             {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local ntags = 10
for i = 1, ntags do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ superkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        local current_tag = screen.selected_tag
                        -- Tag back and forth:
                        -- If you try to focus the same tag you are at,
                        -- go back to the previous tag.
                        -- Useful for quick switching after for example
                        -- checking an incoming chat message at tag 2
                        -- and coming back to your work at tag 1
                        if tag then
                           if tag == current_tag then
                               awful.tag.history.restore()
                           else
                               tag:view_only()
                           end
                        end
                        -- Simple tag view
                        --if tag then
                           --tag:view_only()
                        --end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ superkey, ctrlkey }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ superkey, shiftkey }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
        {description = "move focused client to tag #"..i, group = "tag"}),
        -- Move all visible clients to tag and focus that tag
        awful.key({ superkey, altkey }, "#" .. i + 9,
                  function ()
                    local tag = client.focus.screen.tags[i]
                    local clients = awful.screen.focused().clients
                    if tag then
                        for _, c in pairs(clients) do
                           c:move_to_tag(tag)
                        end
                        tag:view_only()
                    end
                  end,
        {description = "move all visible clients to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ superkey, ctrlkey, shiftkey }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end


-- Mouse buttons on the client (whole window, not just titlebar)
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ superkey }, 1, awful.mouse.client.move),
    awful.button({ superkey }, 2, function (c) c:kill() end),
    awful.button({ superkey }, 3, function(c)
        awful.mouse.resize(c, nil, {jump_to_corner=true})
    end)
)
-- }}}

-- Set keys
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

return keys
-- }}}


-- -- Brightness Control
-- lunaconf.keys.globals(
-- 	awful.key({}, 'XF86MonBrightnessUp', function() brightness_control('up') end),
-- 	awful.key({ 'Shift' }, 'XF86MonBrightnessUp', function() brightness_control('up small') end),
-- 	awful.key({}, 'XF86MonBrightnessDown', function() brightness_control('down') end),
-- 	awful.key({ 'Shift' }, 'XF86MonBrightnessDown', function() brightness_control('down small') end)
-- )
