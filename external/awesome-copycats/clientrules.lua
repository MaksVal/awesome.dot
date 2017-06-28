local awful     = require 'awful'
local rules     = require 'awful.rules'
-- local beautiful 	= require("beautiful")
-- local confdir                       = os.getenv("HOME") .. "/.config/awesome/"
-- beautiful.init(confdir .. "themes/multicolor/theme.lua")
-- beautiful.init(confdir .. "themes/kdesome/theme.lua")

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
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                    size_hints_honor = false
     }
   },

   -- Titlebars
   { rule_any = { type = { "dialog", "normal" } },
     properties = { titlebars_enabled = true } },

   {
      rule_any = { class = { "MPlayer", "pinentry", "Speedcrunch" } },
      properties = { floating = true } },
   {
      rule = { class = "Wine", name = "Please wait..." },
      properties = { floating = true } },
   {
      rule = { class = "konsole" },
      properties = { screen = 1, tag = screen[1].tags[1] } },
   {
      rule_any = { class = { "Skype", "Jitsi", "Ekiga", "Pidgin", "Thunderbird", "Mattermost" } },
      properties = { screen = 1, tag = screen[1].tags[4] } },
   {
      rule = { name = "sip:", class="Ekiga" },
      properties = { floating = true, focus = true, switchtotag = true, buttons = clientbuttons,
                     keys = clientkeys, callback = function(c) c.ontop = not c.ontop end  } },
   {
      rule = { class = "Gcalctool" },
      properties = { floating = true, callback = function(c) c.ontop = not c.ontop end  } },
   {
      rule_any = { name = { "Копирование",  "Перемещение",  "Добавление", "New Folder", "Звонок" } },
      properties = { floating = true  } },
   {
      rule_any = { class = {"Emacs", "xfreerdp" }},
      properties = { screen = 2, tag = screen[2].tags[1], switchtotag = true } },
   {
      rule_any = { class = {"Dolphin", "dolphin" }},
      properties = { screen = 1, tag = screen[1].tags[2] } },
   {
      rule_any = { class = { "Chromium-browser", "chromium-browser-chromium", "Chromium-browser-chromium"} },
      properties = { screen[1], tag = screen[1].tags[3] } },
   {
      rule = { type = "dialog" },
      properties = { floating = true } },
   -- {
   --    rule = { instance = "crx_nckgahadagoaajjgafhacjanaoiihapd" },
   --    properties = { floating = true },
   --    callback = function(c)
   --       -- Show to titlebar else you may not know who you're talking with.
   --       awful.titlebar.show(c, { modkey = modkey })
   --    end }

}
-- }}}
