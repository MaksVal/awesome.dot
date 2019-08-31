-- {{{ Key bindings
local awful     = require 'awful'
local rules     = require 'awful.rules'

-- local br = redflat.float.brightness
-- local drop = require("scratchdrop")

-- globalkeys = awful.util.table.join(
--    -- Take a screenshot
--    awful.key({  }, "Print", function() kill_and_run("spectacle") end),

--    -- Configure the hotkeys of PulseAudio.
--    -- awful.key({ }, "XF86AudioRaiseVolume",
--    --          function ()
--    --             os.execute(string.format("pactl set-sink-volume %d +1000", volpulse.index))
--    --             volpulse.update()
--    --             local v = volume_now.left

--                 -- print(sink_default_s)
--                 -- print(sink_default_i)
--                 -- print(volpulse.sink)
--    --              rednotify:show({ value = v/100, text  = string.format('%.0f', v) .. "%", icon  = beautiful.icons.volume })
--    --           end
--    -- ),

--    -- awful.key({ }, "XF86AudioLowerVolume",
--    --           function ()
--    --              os.execute(string.format("pactl set-sink-volume %d -1000", volpulse.index))
--    --              volpulse.update()
--    --              volume_now.index = volpulse.index
--    --              local v = volume_now.left
--    --              rednotify:show({ value = v/100, text  = string.format('%.0f', v) .. "%", icon  = beautiful.icons.volume })
--    --           end
--    -- ),
--    -- awful.key({ }, "XF86AudioMute",
--    --           function ()
--    --              if volume_now.muted == "yes" then
--    --                 os.execute(string.format("pactl set-sink-mute %d no", volpulse.index))
--    --              else
--    --                 os.execute(string.format("pactl set-sink-mute %d yes", volpulse.index))
--    --              end
--    --              volpulse.update()
--    --              local v = volume_now.left
--    --              local volicon = beautiful.icons.volume
--    --              if volume_now.muted == "yes"  then
--    --                 volicon =  beautiful.icons.mute
--    --                 v = 0
--    --              end
--    --              rednotify:show({ value = v/100, text  = string.format('%.0f', v) .. "%", icon  = volicon })
--    --           end
--    -- ),

--    -- Brightness control
--    -- awful.key({ }, "XF86MonBrightnessUp",  function() br:change({ step = 0 }) end),
--    -- awful.key({ }, "XF86MonBrightnessDown", function() br:change({ step = 0, down = 1 }) end),

--    -- Tag browsing
--    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
--    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
--    awful.key({ modkey }, "Escape", awful.tag.history.restore),

--    -- Non-empty tag browsing
--    -- awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
--    -- awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

--    -- Default client focus
--    awful.key({ altkey }, "k",
--              function ()
--                 awful.client.focus.byidx( 1)
--                 if client.focus then client.focus:raise() end
--              end),
--    awful.key({ altkey }, "j",
--              function ()
--                 awful.client.focus.byidx(-1)
--                 if client.focus then client.focus:raise() end
--              end),

--    -- By direction client focus
--    awful.key({ modkey }, "j",
--              function()
--                 awful.client.focus.bydirection("down")
--                 if client.focus then client.focus:raise() end
--              end),
--    awful.key({ modkey }, "k",
--              function()
--                 awful.client.focus.bydirection("up")
--                 if client.focus then client.focus:raise() end
--              end),
--    awful.key({ modkey }, "h",
--              function()
--                 awful.client.focus.bydirection("left")
--                 if client.focus then client.focus:raise() end
--              end),
--    awful.key({ modkey }, "l",
--              function()
--                 awful.client.focus.bydirection("right")
--                 if client.focus then client.focus:raise() end
--              end),

--    -- Show Menu
--    awful.key({ modkey }, "w",
--              function ()
--                 mymainmenu:show({ keygrabber = true })
--              end),

--    -- Show/Hide Wibox
--    awful.key({ modkey }, "b", function ()
--                 mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
--                 mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
--                               end),

--    -- Layout manipulation
--    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
--    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
--    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
--    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
--    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
--    awful.key({ modkey, "Control" }, "Tab",
--              function ()
--                 awful.client.focus.history.previous()
--                 if client.focus then
--                    client.focus:raise()
--                 end
--              end),
--    awful.key({ modkey, 		 }, "Tab",
--              function () awful.client.focus.byidx(  1)
--                 if client.focus then
--                    client.focus:raise()
--                 end
--              end),
--    awful.key({ altkey,           }, "Tab", function () awful.screen.focus_relative(1)  end ),
--    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
--    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
--    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
--    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
--    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
--    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
--    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
--    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
--    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

--    -- Standard program
--    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
--    awful.key({ modkey, "Control" }, "r",      awesome.restart),
--    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

--    -- Dropdown terminal
--    -- awful.key({ modkey,	          }, "z",      function () drop(terminal) end),
--    -- Dropdown player
--    -- awful.key({ modkey,	          }, "a",      function () drop(player) end),

--    -- Widgets popups
--  --  awful.key({ altkey, "Control" }, "c",      function () lain.widgets.calendar:show(7) end),
--  --  awful.key({ altkey, "Control" }, "h",      function () fswidget.show(7) end),
--  --  awful.key({ altkey, "Control" }, "w",      function () myweather.show(7) end),

--    -- MPD control
--    awful.key({ }, "XF86AudioPlay",
--              function ()
--                 awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
--                 mpdwidget.update()
--              end),
--    awful.key({ }, "XF86AudioStop",
--              function ()
--                 awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
--                 mpdwidget.update()
--              end),
--    awful.key({ }, "XF86AudioPrev",
--              function ()
--                 awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
--                 mpdwidget.update()
--              end),
--    awful.key({ }, "XF86AudioNext",
--              function ()
--                 awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
--                 mpdwidget.update()
--              end),

--       -- MPD control
--    awful.key({ altkey, "Control" }, "Up",
--              function ()
--                 awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
--                 mpdwidget.update()
--              end),
--    awful.key({ altkey, "Control" }, "Down",
--              function ()
--                 awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
--                 mpdwidget.update()
--              end),
--    awful.key({ altkey, "Control" }, "Left",
--              function ()
--                 awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
--                 mpdwidget.update()
--              end),
--    awful.key({ altkey, "Control" }, "Right",
--              function ()
--                 awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
--                 mpdwidget.update()
--              end),
--    -- Copy to clipboard
--    -- awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

--    -- User programs
--    awful.key({ modkey, "Shift" }, "b", function () awful.util.spawn(browser) end),
--    awful.key({ modkey, "Shift" }, "e", function () awful.util.spawn(gui_editor) end),
--    awful.key({ modkey, "Shift" }, "d", function () awful.util.spawn("dolphin") end),
--    awful.key({ modkey, "Shift" }, "r", function () awful.util.spawn("rdp") end),
--    awful.key({                 }, "Pause", function() awful.util.spawn(xscreen_lock) end),
--    awful.key({ modkey	       }, "g", function () awful.util.spawn(graphics) end),
--    -- awful.key({ modkey,	       }, "e", function () drop(mail) end),
--    -- awful.key({      	       }, "XF86Mail", function () drop(mail) end),
--    -- awful.key({      	       }, "F2", function () drop(mail) end),
--    awful.key({ modkey,         }, "XF86Calculator", function () awful.util.spawn("gcalctool") end)

--    -- Prompt
--    -- awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
--    -- awful.key({   }, "Super_R", function () mypromptbox[mouse.screen]:run() end),
--    -- awful.key({ modkey }, "x",
--    --          function ()
--    --             awful.prompt.run({ prompt = "Run Lua code: " },
--    --                              mypromptbox[mouse.screen].widget,
--    --                              awful.util.eval, nil,
--    --                              awful.util.getdir("cache") .. "/history_eval")
--    --          end)
-- )

-- clientkeys = awful.util.table.join(
--    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
--    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
--    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
--    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
--    awful.key({ modkey,           }, "p",      awful.client.movetoscreen                        ),
--    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
--    awful.key({ modkey,           }, "n",
--              function (c)
--                 -- The client currently has the input focus, so it cannot be
--                 -- minimized, since minimized clients can't have the focus.
--                 c.minimized = true
--              end),
--    awful.key({ modkey,           }, "m",
--              function (c)
--                 c.maximized_horizontal = not c.maximized_horizontal
--                 c.maximized_vertical   = not c.maximized_vertical
--              end)
-- )

-- -- Bind all key numbers to tags.
-- -- be 1careful: we use keycodes to make it works on any keyboard layout.
-- -- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 9 do
--    globalkeys = awful.util.table.join(globalkeys,
--                                       -- View tag only.
--                                       awful.key({ modkey }, "#" .. i + 9,
--                                                 function ()
--                                                    local screen = mouse.screen
--                                                    local tag = awful.tag.gettags(screen)[i]
--                                                    if tag then
--                                                       awful.tag.viewonly(tag)
--                                                    end
--                                                 end),
--                                       -- Toggle tag.
--                                       awful.key({ modkey, "Control" }, "#" .. i + 9,
--                                                 function ()
--                                                    local screen = mouse.screen
--                                                    local tag = awful.tag.gettags(screen)[i]
--                                                    if tag then
--                                                       awful.tag.viewtoggle(tag)
--                                                    end
--                                                 end),
--                                       -- Move client to tag.
--                                       awful.key({ modkey, "Shift" }, "#" .. i + 9,
--                                                 function ()
--                                                    if client.focus then
--                                                       local tag = awful.tag.gettags(client.focus.screen)[i]
--                                                       if tag then
--                                                          awful.client.movetotag(tag)
--                                                       end
--                                                    end
--                                                 end),
--                                       -- Toggle tag.
--                                       awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
--                                                 function ()
--                                                    if client.focus then
--                                                       local tag = awful.tag.gettags(client.focus.screen)[i]
--                                                       if tag then
--                                                          awful.client.toggletag(tag)
--                                                       end
--                                                    end
--                                                 end))
-- end

-- clientbuttons = awful.util.table.join(
--    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
--    awful.button({ modkey }, 1, awful.mouse.client.move),
--    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- -- Set keys
-- root.keys(globalkeys)
-- -- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    awful.key({ altkey }, "p", function() os.execute("screenshot") end),

    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
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

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end),  -- move to previous tag
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end),  -- move to next tag
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
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

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end),

    -- Widgets popups
    -- awful.key({ altkey, }, "c", function () lain.widget.calendar.show(7) end),
    -- awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end),
    -- awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end),

    -- ALSA volume control
    awful.key({ altkey }, "Up",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ altkey }, "Down",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ altkey }, "m",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ altkey, "Control" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ altkey, "Control" }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end),


    -- MPD control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.spawn.with_shell("mpc toggle")
            beautiful.mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.spawn.with_shell("mpc stop")
            beautiful.mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.spawn.with_shell("mpc prev")
            beautiful.mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.spawn.with_shell("mpc next")
            beautiful.mpd.update()
        end),
    awful.key({ altkey }, "0",
        function ()
            local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey }, "c", function () awful.spawn("xsel | xsel -i -b") end),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey }, "v", function () awful.spawn("xsel -b | xsel") end),

    -- User programs
    awful.key({ modkey }, "e", function () awful.spawn(gui_editor) end),
    awful.key({ modkey }, "q", function () awful.spawn(browser) end)

    -- Default
    --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    --]]
    --[[ dmenu
    awful.key({ modkey }, "x", function ()
        awful.spawn(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
        beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
		end)
    --]]
    -- Prompt
--    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
--              {description = "run prompt", group = "launcher"}),

--    awful.key({ modkey }, "x",
--              function ()
--                  awful.prompt.run {
--                    prompt       = "Run Lua code: ",
--                    textbox      = awful.screen.focused().mypromptbox.widget,
--                   exe_callback = awful.util.eval,
--                    history_path = awful.util.get_cache_dir() .. "/history_eval"
--                  }
--              end,
--              {description = "lua execute prompt", group = "awesome"})
    --]]
)

clientkeys = awful.util.table.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client                         ),
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
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
