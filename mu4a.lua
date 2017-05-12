-- Calendar with Emacs org-mode agenda for Awesome WM
-- Inspired by and contributed from the org-awesome module, copyright of Damien Leone
-- Licensed under GPLv2
-- Version 1.1-awesome-git
-- @author Alexander Yakushev <yakushev.alex@gmail.com>

local awful = require("awful")
local util = awful.util
local format = string.format
local naughty = require("naughty")
local lfs = require 'lfs'
local wibox = require("wibox")
local mails = nil

local mu4a = { widget = wibox.widget.imagebox(beautiful.email_icon, false),
               char_width = nil,
               text_color = beautiful.fg_normal or "#FFFFFF",
               today_color = beautiful.fg_focus or "#00FF00",
               event_color = beautiful.fg_urgent or "#FF0000",
               font = beautiful.font or 'monospace 8',
               parse_on_show = true,
               limit_todo_length = nil,
               date_format = "%d-%m-%Y" }

mu4a_widget = wibox.widget.imagebox()
mu4a_widget:set_image(beautiful.email_icon)

function capture(command)
   local tmpfile = '/tmp/mu4a'
   local exit = os.execute(command .. ' | sed \'s/\x1b/\\e/g\' > ' .. tmpfile .. ' 2>&1 ')

   local stdout_file = io.open(tmpfile)
   local stdout = stdout_file:read("*all")

   stdout_file:close()
   os.remove(tmpfile)

   return exit, stdout
end

function list_unread()
   local res, sout = capture("mu find maildir:/INBOX flag:unread 2>/dev/null")

   if (res ~= 0 ) then
      sout = nil
   end

   local __, count = string.gsub(sout, '\n', '\n')

   return sout
end

function mu4a.hide()
   if mails ~= nil then
      naughty.destroy(mails)
      mails = nil
      offset = 0
   end
end

function mu4a.show()
   mails = naughty.notify({ title = "Unread messages",
                            text = list_unread(),
                            timeout = 0, hover_timeout = 0.5,
                            screen = mouse.screen,
                          })
end

function mu4a.register(widget)
   widget:connect_signal("mouse::enter", function() mu4a.show(0) end)
   widget:connect_signal("mouse::leave", mu4a.hide)
   widget:buttons(util.table.join( awful.button({ }, 3, function()
                                                   -- mu4a.parse_agenda()
                                                        end),
                                   awful.button({ }, 4, function()
                                                   mu4a.hide()
                                                   mu4a.show()
                                                        end),
                                   awful.button({ }, 5, function()
                                                   mu4a.hide()
                                                   mu4a.show()
                                                        end)))
end

mu4a.register(mu4a_widget)
