local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local create_theme = require("actionless.common_theme").create_theme
local color_utils = require("utils.color")
local parse = require("utils.parse")

local theme_name = "lcars-xresources-hidpi"

local theme_dir = awful.util.getdir("config").."themes/"..theme_name
--local theme = dofile("/usr/share/awesome/themes/xresources/theme.lua")


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
theme.icons_dir = theme.dir .. "/icons/"

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
--theme.widget_layoutbox_bg = theme.panel_layoutbox
--theme.widget_layoutbox_fg = theme.panel_widget_fg

-- WALLPAPER:
-- Use nitrogen:
theme.wallpaper = nil
theme.wallpaper_cmd     = "nitrogen --restore"
-- Use wallpaper tile:
--theme.wallpaper = theme_dir .. '/umbreon_pattern.png'

-- PANEL DECORATIONS:
--
theme.show_widget_icon = true
-- theme.widget_decoration_arrl = ''
-- theme.widget_decoration_arrr = ''

-- deprecated :
--theme.widget_decoration_arrl = ''
--theme.widget_decoration_arrr = ''

theme.arrl                          = theme.icons_dir .. "powerarrow-dark/arrl.png"
theme.arrl_dl                       = theme.icons_dir .. "powerarrow-dark/arrl_dl.png"
theme.arrl_ld                       = theme.icons_dir .. "powerarrow-dark/arrl_ld.png"

theme.layout_tile                   = theme.icons_dir .. "powerarrow-dark/tile.png"
theme.layout_tilegaps               = theme.icons_dir .. "powerarrow-dark/tilegaps.png"
theme.layout_tileleft               = theme.icons_dir .. "powerarrow-dark/tileleft.png"
theme.layout_tilebottom             = theme.icons_dir .. "powerarrow-dark/tilebottom.png"
theme.layout_tiletop                = theme.icons_dir .. "powerarrow-dark/tiletop.png"
theme.layout_fairv                  = theme.icons_dir .. "powerarrow-dark/fairv.png"
theme.layout_fairh                  = theme.icons_dir .. "powerarrow-dark/fairh.png"
theme.layout_spiral                 = theme.icons_dir .. "powerarrow-dark/spiral.png"
theme.layout_dwindle                = theme.icons_dir .. "powerarrow-dark/dwindle.png"
theme.layout_max                    = theme.icons_dir .. "powerarrow-dark/max.png"
theme.layout_fullscreen             = theme.icons_dir .. "powerarrow-dark/fullscreen.png"
theme.layout_magnifier              = theme.icons_dir .. "powerarrow-dark/magnifier.png"
theme.layout_floating               = theme.icons_dir .. "powerarrow-dark/floating.png"

-- theme.widget_decoration_arrl = '퟾'
-- theme.widget_decoration_arrr = '퟿'


theme.revelation_fg = theme.xrdb.color13
theme.revelation_border_color = theme.xrdb.color13
theme.revelation_bg = theme.panel_bg
theme.revelation_font = "Monospace Bold 24"
-- FONTS:
theme.font = "Monospace Bold "..tostring(dpi(10))
theme.small_font = "Monospace "..tostring(dpi(7))
theme.sans_font = "Sans Bold "..tostring(dpi(10))
theme.font = "Monospace Bold 10"
theme.tasklist_font = theme.font
theme.small_font = "Monospace 7"
theme.sans_font = "Sans Bold 10"
-- Don't use sans font:
--theme.sans_font	= "theme.font"

--theme.font = "Roboto Condensed Bold "..tostring(dpi(10))
--theme.sans_font = "Roboto Condensed Bold "..tostring(dpi(10))

--
--MISC:
--

theme.basic_panel_height = dpi(18)
theme.panel_padding_bottom = dpi(3)

--theme.border_width = dpi(3)
--theme.useless_gap = dpi(6)

--theme.border_radius = dpi(5)
--theme.notification_border_radius = dpi(10)
--theme.panel_widget_border_radius = dpi(4)

theme.border_radius = dpi(8)
theme.notification_border_radius = dpi(8)
theme.panel_widget_border_radius = dpi(4)

theme.notification_shape = function(cr,w,h)
  gears.shape.rounded_rect(
    cr, w, h, theme.notification_border_radius
  )
end

theme.border_width = dpi(4)
theme.useless_gap = dpi(5)

theme.border_width = dpi(5)
theme.useless_gap = dpi(4)

theme.border_width = dpi(4)
theme.border_radius = dpi(5)

local gtk_util = require("utils.gtk")
local gsc = gtk_util.get_theme_variables()
theme.border_radius = dpi(gtk.ROUNDNESS*1)
theme.panel_widget_border_radius = dpi(gtk.ROUNDNESS*0.7)

theme.base_border_width = theme.border_width
theme.border_width = 0

theme.panel_height = theme.basic_panel_height + theme.panel_padding_bottom
theme.titlebar_height = theme.basic_panel_height + theme.base_border_width*2


theme.left_panel_internal_corner_radius = dpi(30)

theme.left_panel_width = dpi(120)
theme.left_widget_min_height = dpi(120)

theme.menu_height		= dpi(16)
theme.menu_width		= dpi(150)
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

theme.panel_widget_spacing = dpi(10)
theme.panel_widget_spacing_medium = dpi(8)
theme.panel_widget_spacing_small = dpi(4)

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



theme.email_icon = theme.icons_dir .. "powerarrow-dark/mail.png"
theme.email_on_icon = theme.icons_dir .. "powerarrow-dark/mail_on.png"
theme.volume_icon = theme.icons_dir .. "audio.svg"
theme.volume_low_icon = theme.icons_dir .. "powerarrow-dark/vol_low.png"
theme.volume_mute_icon = theme.icons_dir .. "powerarrow-dark/vol_mute.png"
theme.volume_no_icon = theme.icons_dir .. "powerarrow-dark/vol_no.png"

return theme
