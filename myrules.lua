-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
   },
   -- Floating clients.
   {
      rule_any = {
         instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
         },
         class = {
            "Arandr", "Gpick", "Kruler", "MessageWin",  -- kalarm.
            "Sxiv", "Wpa_gui", "pinentry", "veromix",
            "xtightvncviewer", "MPlayer", "pinentry",
            "Speedcrunch", "Wine", "Gcalctool"
         },
         name = {
            "Please wait...", "Копирование",  "Перемещение", "Добавление",
            "New Folder", "Звонок", "Event Tester"  -- xev.
         },
         role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
         }
      }, properties = { floating = true, callback = function(c) c.ontop = not c.ontop end }
   },
   -- Add titlebars to normal clients and dialogs
   -- {
   --    rule_any = {
   --       type = {
   --          "normal", "dialog"
   --       }
   --    }, properties = { titlebars_enabled = true }
   -- },
   {
      rule_any = {
         class = {
            "konsole"
         }
      }, properties = { screen = 1, tag = "1" }
   },
   {
      rule_any = {
         class = {
            "Skype", "Jitsi", "Ekiga", "Pidgin",
            "Thunderbird", "Mattermost"
         }
      }, properties = { screen = 1, tag = "4" }
   },
   {
      rule_any = {
         class = {
            "Emacs", "xfreerdp"
         }
      }, properties = { screen = 2, tag = "1",switchtotag = true  }
   },
   {
      rule_any = {
         class = {
            "Dolphin", "dolphin"
         }
      }, properties = { screen = awful.screen.preferred, tag = "2" }
   },
   {
      rule_any = {
         class = {
            "Chromium-browser", "chromium-browser-chromium", "Chromium-browser-chromium"
         }
      }, properties = { screen = awful.screen.preferred, tag = "3" }
   }
   -- {
   --    rule = { instance = "crx_nckgahadagoaajjgafhacjanaoiihapd" },
   --    properties = { floating = true },
   --    callback = function(c)
   --       -- Show to titlebar else you may not know who you're talking with.
   --       awful.titlebar.show(c, { modkey = modkey })
   --    end }

   --
   --

   -- Set Firefox to always map on the tag named "2" on screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { screen = 1, tag = "2" } },
}
-- }}}
