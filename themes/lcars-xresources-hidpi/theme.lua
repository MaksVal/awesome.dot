local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local apply_dpi = xresources.apply_dpi
local dpi = xresources.get_dpi(1)
local create_theme = require("actionless.common_theme").create_theme
local color_utils = require("utils.color")
local parse = require("utils.parse")

local theme_name = "lcars-xresources-hidpi"
local theme_dir = awful.util.getdir("config").."themes/"..theme_name
--local theme = dofile("/usr/share/awesome/themes/xresources/theme.lua")

awful.screen.connect_for_each_screen(function(s)
                                        xresources.set_dpi(dpi,s)
                                     end)

local debug_messages_enabled = true
local debug_messages_enabled = false
local log = function(...) if debug_messages_enabled then nlog(...) end end

local oomox_theme_keys = {}
for _, key in ipairs({
  "BG",
  "FG",
  "MENU_BG",
  "MENU_FG",
  "SEL_BG",
  "SEL_FG",
  "TXT_BG",
  "TXT_FG",
  "BTN_BG",
  "BTN_FG",
  "HDR_BTN_BG",
  "HDR_BTN_FG",

  "ROUNDNESS",
  "GRADIENT",

  "ICONS_LIGHT_FOLDER",
  "ICONS_LIGHT",
  "ICONS_MEDIUM",
  "ICONS_DARK",
}) do
  oomox_theme_keys[key] = key
end

local oomox_theme_name = "retro/uzi"
pcall(function()
  if OOMOX_THEME_NAME then
    oomox_theme_name = OOMOX_THEME_NAME
  end
end)

local gtk = parse.find_values_in_file(
  awful.util.get_configuration_dir() .. "themes/gtk.colors",
  "(.*)=(.*)",
  oomox_theme_keys,
  function(value)
    return "#"..value
  end
)
gtk.ROUNDNESS = tonumber(gtk.ROUNDNESS:sub(2,#gtk.ROUNDNESS))
gtk.GRADIENT = tonumber(gtk.GRADIENT:sub(2,#gtk.GRADIENT))
gtk.MENU_BG = color_utils.darker(gtk.MENU_BG, -math.ceil(gtk.GRADIENT*10))
log(gtk)

pcall(function()
  if OOMOX_SEL_BG then
    gtk.SEL_BG = OOMOX_SEL_BG
  end
end)


local MAIN_COLOR = gtk.SEL_BG
if oomox_theme_name == 'retro/uzi' then
  MAIN_COLOR = gtk.BTN_BG
end

local theme_dir = awful.util.getdir("config").."/themes/"..theme_name
--local theme = dofile("/usr/share/awesome/themes/xresources/theme.lua")

local theme = {}

theme.gtk = gtk



local theme = {}

theme.xrdb = xresources.get_current_theme()

theme.dir = theme_dir
theme.icons_dir = awful.util.getdir("config") .."/themes/icons/"

--theme.error = theme.xrdb.color1
--theme.warning = theme.xrdb.color2


-- TERMINAL COLORSCHEME:
--
theme.color = xresources.get_current_theme()
theme.xrdb = xresources.get_current_theme()

-- PANEL COLORS:
--

theme.panel_taglist = theme.xrdb.color7
theme.panel_close = theme.xrdb.color1
theme.panel_tasklist = theme.xrdb.background
theme.panel_media = theme.xrdb.color14
theme.panel_info = theme.xrdb.color13
theme.panel_layoutbox = theme.xrdb.color7
-- theme.widget_layoutbox_bg = theme.panel_layoutbox
-- theme.widget_layoutbox_fg = theme.panel_widget_fg

-- WALLPAPER:
-- Use nitrogen:
--theme.wallpaper = nil
theme.wallpaper_cmd     = "nitrogen --restore"
-- Use wallpaper tile:
-- cmd = 'find ' . awful.util.getdir("config") . "../../Pictures -type f \( -iname '*.jpg' -o -iname '*.png' \) -print0 | shuf -n1 -z"
-- awful.spawn.easy_async(cmd,
--                        function(stdout, stderr, reason, exit_code)
--                           theme.wallpaper = stdout
--                           print(stdout, stderr, cmd)
--                        end)

-- PANEL DECORATIONS:
--
theme.show_widget_icon = true

theme.arrl                          = theme.icons_dir .. "powerarrow-dark/arrl.png"
theme.arrl_dl                       = theme.icons_dir .. "powerarrow-dark/arrl_dl.png"
theme.arrl_ld                       = theme.icons_dir .. "powerarrow-dark/arrl_ld.png"

local layouts_icon 				 	= theme.icons_dir .. "layouts/"

theme.layout_tile                   = layouts_icon .. "tile.png"
theme.layout_tilegaps               = layouts_icon .. "tilegaps.png"
theme.layout_tileleft               = layouts_icon .. "tileleft.png"
theme.layout_tilebottom             = layouts_icon .. "tilebottom.png"
theme.layout_tiletop                = layouts_icon .. "tiletop.png"
theme.layout_fairv                  = layouts_icon .. "fairv.png"
theme.layout_fairh                  = layouts_icon .. "fairh.png"
theme.layout_spiral                 = layouts_icon .. "spiral.png"
theme.layout_dwindle                = layouts_icon .. "dwindle.png"
theme.layout_max                    = layouts_icon .. "max.png"
theme.layout_fullscreen             = layouts_icon .. "fullscreen.png"
theme.layout_magnifier              = layouts_icon .. "magnifier.png"
theme.layout_floating               = layouts_icon .. "floating.png"

theme.revelation_fg = theme.xrdb.color13
theme.revelation_border_color = theme.xrdb.color13
theme.revelation_bg = theme.panel_bg
theme.revelation_font = "Monospace Bold " .. tostring(apply_dpi(10))
-- FONTS:
theme.font = "Roboto Condensed Bold "..tostring(apply_dpi(10))
theme.sans_font = "Roboto Condensed Bold "..tostring(apply_dpi(10))
-- theme.font = "Monospace Bold "..tostring(apply_dpi(11))
theme.small_font = "Monospace "..tostring(apply_dpi(8))
-- theme.sans_font = "Sans Bold "..tostring(apply_dpi(11))
theme.tasklist_font = theme.font
-- Don't use sans font:
--theme.sans_font	= "theme.font"


--
--MISC:
--

theme.notification_shape = function(cr,w,h)
  gears.shape.rounded_rect(
    cr, w, h, theme.notification_border_radius
  )
end

local gtk_util = require("utils.gtk")
local gsc = gtk_util.get_theme_variables()
theme.border_radius = apply_dpi(gtk.ROUNDNESS*1)
theme.panel_widget_border_radius = apply_dpi(gtk.ROUNDNESS*0.7)


theme.basic_panel_height = apply_dpi(10)
theme.panel_padding_bottom = apply_dpi(3)

--theme.border_width = apply_dpi(3)
--theme.useless_gap = apply_dpi(6)

--theme.border_radius = apply_dpi(5)
--theme.notification_border_radius = apply_dpi(10)
--theme.panel_widget_border_radius = apply_dpi(4)

-- theme.border_radius = apply_dpi(8)
theme.notification_border_radius = apply_dpi(8)
-- theme.panel_widget_border_radius = apply_dpi(4)


theme.border_width = apply_dpi(4)
theme.useless_gap = apply_dpi(5)

theme.border_width = apply_dpi(5)
theme.useless_gap = apply_dpi(4)

theme.border_width = apply_dpi(4)
theme.border_radius = apply_dpi(5)


theme.base_border_width = theme.border_width
theme.border_width = 0

theme.panel_height = theme.basic_panel_height + theme.panel_padding_bottom
theme.titlebar_height = theme.basic_panel_height + theme.base_border_width*2

theme.left_panel_internal_corner_radius = apply_dpi(3)

-- theme.left_panel_width = apply_dpi(120)
-- theme.left_widget_min_height = apply_dpi(120)

theme.menu_height		= apply_dpi(16)
theme.menu_width		= apply_dpi(15)
theme.menu_border_color = theme.xrdb.color1

--theme.apw_fg_color = "theme.xrdb.color8"
theme.apw_bg_color = "theme.xrdb.color8"
theme.apw_mute_bg_color = "theme.xrdb.color1"
theme.apw_mute_fg_color = "theme.xrdb.color9"



--theme.taglist_squares_sel       = "theme.null"
--theme.taglist_squares_unsel     = "theme.null"
--theme.taglist_fg_focus		= "theme.theme"
theme.taglist_fg_focus		= "theme.bg"
--theme.taglist_bg_focus		= "theme.xrdb.color6"
if color_utils.is_dark(theme.xrdb.background) then
  theme.taglist_bg_focus		= "theme.xrdb.color15"
else
  theme.taglist_bg_focus		= "theme.xrdb.color0"
end
--theme.taglist_bg_focus		= "theme.xrdb.color8"
--theme.taglist_fg_focus		= "theme.xrdb.foreground"

--theme.titlebar_fg_focus		= "theme.titlebar_border"
--theme.titlebar_bg_focus		= "theme.titlebar_focus_border"
theme.titlebar_fg_normal	= "theme.tasklist_fg_normal"
theme.titlebar_bg_normal	= "theme.titlebar_border"
theme.titlebar_fg_focus		= "theme.titlebar_fg_normal"
theme.titlebar_bg_focus		= "theme.titlebar_bg_normal"
theme.titlebar_bg_focus		= "theme.titlebar_bg_normal"

if theme.border_radius == 0 then
  theme.border_focus = "theme.xrdb.color10"
  theme.titlebar_bg_focus		= "theme.border_focus"
  theme.titlebar_fg_focus		= "theme.xrdb.background"
end


--theme.titlebar_border           = theme.border_normal

theme.panel_widget_spacing = apply_dpi(10)
theme.panel_widget_spacing_medium = apply_dpi(8)
theme.panel_widget_spacing_small = apply_dpi(4)

theme.panel_widget_bg		= theme.xrdb.color3
theme.panel_widget_bg_error = theme.xrdb.color1
theme.panel_widget_fg_error = theme.xrdb.color15

theme.widget_music_bg = theme.xrdb.color11
theme.widget_music_fg = theme.bg

--theme.tasklist_fg_focus = "theme.fg"
theme.tasklist_fg_focus = theme.xrdb.foreground

theme.widget_close_bg = "theme.panel_widget_bg"
theme.widget_close_error_color_on_hover = true


theme = create_theme({ theme_name=theme_name, theme=theme, })

if awesome.composite_manager_running then
  --theme.titlebar_bg_normal = theme.titlebar_bg_normal .."66"
  theme.border = theme.border .."66"
  theme.border_normal       = theme.border_normal .."66"
  theme.border_focus        = theme.border_focus .."66"
  theme.titlebar_bg_normal  = theme.titlebar_bg_normal.."dd"
  theme._titlebar_bg_normal = theme.titlebar_bg_normal.."dd"
  theme.titlebar_bg_focus   = theme.titlebar_bg_focus.."dd"
  theme._titlebar_bg_focus  = theme.titlebar_bg_focus.."dd"
end

-- Recolor titlebar icons:
local theme_assets = require("beautiful.theme_assets")
theme = theme_assets.recolor_layout(theme, theme.fg_normal)
theme = theme_assets.recolor_titlebar_normal(theme, theme.titlebar_fg_normal)
theme = theme_assets.recolor_titlebar_focus(theme, theme.titlebar_fg_focus)


if color_utils.is_dark(theme.xrdb.background) then
  --theme.clock_fg  = theme.xrdb.color15
  theme.clock_fg = color_utils.darker(theme.xrdb.foreground, -16)
  --theme.tasklist_fg_focus = color_utils.darker(theme.fg, -33)
  theme.tasklist_fg_focus = color_utils.darker(theme.xrdb.foreground, 12)
  --theme.border_normal = color_utils.darker(theme.xrdb.background, -20)
else
  --theme.clock_fg  = theme.xrdb.color0
  theme.clock_fg = color_utils.darker(theme.xrdb.foreground, 16)
  --theme.border_normal = color_utils.darker(theme.xrdb.background, 20)
end



theme.email_icon 		= theme.icons_dir .. "powerarrow-dark/mail.png"
theme.email_on_icon 	= theme.icons_dir .. "powerarrow-dark/mail_on.png"
theme.volume_icon 		= theme.icons_dir .. "powerarrow-dark/vol.png"
theme.volume_low_icon 	= theme.icons_dir .. "powerarrow-dark/vol_low.png"
theme.volume_mute_icon 	= theme.icons_dir .. "powerarrow-dark/vol_mute.png"
theme.volume_no_icon 	= theme.icons_dir .. "powerarrow-dark/vol_no.png"
theme.music_icon	 	= theme.icons_dir .. "powerarrow-dark/note.png"
theme.music_on_icon	 	= theme.icons_dir .. "powerarrow-dark/note_on.png"
return theme
