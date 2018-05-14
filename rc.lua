-- Notification library
local _dbus = dbus; dbus = nil
naughty = require("naughty")
dbus = _dbus

-- Require the luarocks loader for luarocks dependencies
require('luarocks.loader')


-- Standard awesome library
awful = require("awful")
require("awful.autofocus")
freedesktop = require("freedesktop")
gears = require("gears")

-- Add our lib folder to the require lookup path
local configpath = gears.filesystem.get_configuration_dir()
package.path = configpath .. "/lib/?.lua;" .. configpath .. "/lib/?/init.lua;" .. package.path .. ";./y_widgets/?/;"


-- Widget and layout library
local wibox = require("wibox")
-- local orglendar = require("external.orglendar")
local lain = require("external.lain")
my_widgets = require("my_widgets")

local lunaconf = require('lunaconf')
local lunanotify = require('lunaconf.notify')

-- Theme handling library
beautiful   = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup").widget

function file_exists(name)
   local f=io.open(name,"r")
   if f ~= nil then
      io.close(f) return true else return false end
end

-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        -- naughty.notify({ preset = naughty.config.presets.critical,
        --                  title = "Oops, an error happened!",
        --                  text = tostring(err) })
        in_error = false
    end)
end
-- }}}


function run_systemd(cmd)
   awful.spawn("systemctl --user start app@" .. cmd)
end

function run_once(cmd, args)
   findme = cmd
   firstspace = cmd:find(" ")
   if firstspace then
      findme = cmd:sub(0, firstspace-1)
   end
   if (args) then
      awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. " " .. args .. ")")
   else
      awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd  .. ")")
   end
end

function run_check(cmd)
   local cmd = {"bash", "-c", cmd}
   awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
                             naughty.notify { text = "output is " .. stdout }
                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops...",
                                              text = tostring(stderr) })
                               end)
end

function kill_and_run(cmd)
   findme = cmd
   firstspace = cmd:find(" ")
   if firstspace then
      findme = cmd:sub(0, firstspace-1)
   end
   awful.util.spawn_with_shell("pkill -9 " .. cmd .. " ; (" .. cmd .. ")")
end

-- {{{ Autostart
awful.spawn.easy_async("xrdb -merge .Xdefaults")
run_systemd("wallpaper.sh")
run_systemd("nm-applet")
run_once("dropbox")
run_once("wmname")
run_once("emacs", "--daemon")
-- }}}

-- beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
-- beautiful.init(awful.util.get_configuration_dir().. "themes/my/theme.lua")
beautiful.init(awful.util.get_configuration_dir().. "themes/lcars-xresources-hidpi/theme.lua")
-- beautiful.init(awful.util.get_configuration_dir().. "themes/twmish/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal 		= "konsole" or "xterm"
terminal_run	= "konsole -e "
editor     		= os.getenv("EDITOR") or "emacs" or "vi"
editor_cmd 		= terminal .. " -e " .. editor
editorGui 		= (os.getenv("VISUAL") or "emacs -nw")
player     		= terminal .. " -e ncmpcpp"
browser_run	    = "google-chrome-stable"
browser_flags	= " --high-dpi-support=1 --force-device-scale-factor=1.3 --enable-extensions --embed-flash-fullscreen  --ignore-gpu-blacklist --password-store=basic"
browser			= browser_run .. browser_flags
mail            = editorGui   .. " -e \"\(mu4e\)\""
xscreen_lock	= "dm-tool lock"
music_play		= "mpc toggle || ncmpc toggle || pms toggle"
music_stop 		= "mpc stop || ncmpc stop || pms stop"
music_prev		= "mpc prev || ncmpc prev || pms prev"
music_next		= "mpc next || ncmpc next || pms next"
filemanager		= "spacefm"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey 		= "Mod4"
altkey     	= "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end }
}
mymainmenu = freedesktop.menu.build({
                                       before = {
                                          { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                          -- other triads can be put here
                                       },
                                       after = {
                                          { "Open terminal", terminal },
                                          -- other triads can be put here
                                       }
                                    })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = wibox.container.background(awful.widget.keyboardlayout(), "#313131")

-- {{{ Wibar
my_widgets = require("my_widgets")

-----------------------------------
-- PULSEAUDIO Widget
-----------------------------------
-- Create a pulseaudio widget
pulseaudio = wibox.container.background(
   my_widgets.pulseaudio({
                            brd_color = beautiful.panel_tasklist,
                            button_callback = function() end})
   , beautiful.panel_tasklist)
-- END PULSEAUDIO --

-------------------------------
-- CPU Widget --
-------------------------------
-- cpu = require("my_widgets.cpu-widget")
cpu =  wibox.container.background(
   my_widgets.cpu({
                     brd_color = beautiful.panel_tasklist
                  }),
   beautiful.panel_tasklist)
-- END CPU --

-------------------------------
-- MEMORY Widget --
-------------------------------
memory =  wibox.container.background(
   my_widgets.memory({
                        brd_color = "#313131"
                     })
   , "#313131")
--                                   -- require("my_widgets.memory")
-- END MEMORY --

-- -- BEGIN OF AWESOMPD WIDGET DECLARATION

local awesompd = require('my_widgets/awesompd/awesompd')

musicwidget = awesompd:create() -- Create awesompd widget
musicwidget.font = "Liberation Mono" -- Set widget font
-- musicwidget.font_color = "#FFFFFF" --Set widget font color
musicwidget.background = "#313131" --Set widget background color
musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 10 -- Set the update interval in seconds

-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/mgordeev/.config/awesome/my_widgets/awesompd/icons"

-- Set the path to the icon to be displayed on the widget itself
musicwidget.widget_icon = beautiful.music_icon

-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
musicwidget.jamendo_format = awesompd.FORMAT_MP3

-- Specify the browser you use so awesompd can open links from
-- Jamendo in it.
musicwidget.browser = "chromium"

-- If true, song notifications for Jamendo tracks and local tracks
-- will also contain album cover image.
musicwidget.show_album_cover = true

-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
musicwidget.album_cover_size = 50

-- This option is necessary if you want the album covers to be shown
-- for your local tracks.
musicwidget.mpd_config = awful.util.get_xdg_config_home() .. "mpd/mpd.conf"

-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
musicwidget.ldecorator = " "
musicwidget.rdecorator = " "

-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = {
   { server = "localhost",
     port = 6600 }
}

-- Set the buttons of the widget. Keyboard keys are working in the
-- entire Awesome environment. Also look at the line 352.
musicwidget:register_buttons(
   { { "", awesompd.MOUSE_LEFT, musicwidget:command_playpause() },
     { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
     { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
     { "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
     { "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
     { "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
     { "", "XF86AudioLowerVolume", musicwidget:command_volume_down() },
     { "", "XF86AudioRaiseVolume", musicwidget:command_volume_up() },
     { modkey, "Pause", musicwidget:command_playpause() } })

musicwidget:run() -- After all configuration is done, run the widget

mpd =  wibox.container.background(musicwidget.widget, "#313131")

-- -- END OF AWESOMPD WIDGET DECLARATION

-- Create a textclock widget
mytextclock = wibox.container.background(wibox.widget.textclock(), "#313131")

-- SYSTRAY
local systray = wibox.widget.systray()

-- orglendar.files = gears.filesystem.get_xdg_config_home() .. "ORG/projects.org.gpg"

-- MUSIC
-- act_widgets = require("actionless.widgets.music")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Separators
local separators = lain.util.separators
local arrow = separators.arrow_left
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox(beautiful.arrl)
arrl_dl = wibox.widget.imagebox(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox(beautiful.arrl_ld)

-- aliases for setup
local al = awful.layout.layouts
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, {al[4], al[2], al[8], al[6], al[2]})

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
       layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
            arrow(beautiful.panel_tasklist, "#313131"),
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
           layout = wibox.layout.fixed.horizontal,
           arrow(beautiful.panel_tasklist, "#313131"),
           mpd,
           arrow("#313131", beautiful.panel_tasklist),
           cpu,
           arrow(beautiful.panel_tasklist, "#313131"),
           memory,
           arrow("#313131", beautiful.panel_tasklist),
           pulseaudio,
           arrow(beautiful.panel_tasklist, "#313131"),
           mykeyboardlayout,
           arrow("#313131", beautiful.panel_tasklist),
           systray,
           arrow(beautiful.panel_tasklist, "#313131"),
           mytextclock,
           arrow("#313131", beautiful.panel_tasklist),
           s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Set bindings
require ('mybindings')
-- }}}

-- {{{ Set rules
require ('myrules')
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
