
--[[

     Powerarrow - Gruvbox
     by Alphonse Mariyagnanaseelan

     Powerarrow Awesome WM theme: github.com/copycat-killer
     Gruvbox: github.com/morhetz/gruvbox/

--]]

-- Gruvbox colors

local black_dark       = "#282828"
local black_light      = "#928374"
local red_dark         = "#cc241d"
local red_light        = "#fb4934"
local green_dark       = "#98971a"
local green_light      = "#b8bb26"
local yellow_dark      = "#d79921"
local yellow_light     = "#fabd2f"
local blue_dark        = "#458588"
local blue_light       = "#83a598"
local purple_dark      = "#b16286"
local purple_light     = "#d3869b"
local aqua_dark        = "#689d6a"
local aqua_light       = "#8ec07c"
local white_dark       = "#a89984"
local white_light      = "#ebdbb2"
local orange_dark      = "#d65d0e"
local orange_light     = "#fe8019"

local bw0_h            = "#1d2021"
local bw0              = "#282828"
local bw0_s            = "#32302f"
local bw1              = "#3c3836"
local bw2              = "#504945"
local bw3              = "#665c54"
local bw4              = "#7c6f64"
local bw5              = "#928374"
local bw6              = "#a89984"
local bw7              = "#bdae93"
local bw8              = "#d5c4a1"
local bw9              = "#ebdbb2"
local bw10             = "#fbf1c7"

-- local fs_bg_normal      = bw2
-- local temp_bg_normal    = bw2
local pacman_bg_normal  = bw2
local users_bg_normal   = bw2
local sysload_bg_normal = bw2
local cpu_bg_normal     = bw2
local mem_bg_normal     = bw2
local vol_bg_normal     = bw2
local bat_bg_normal     = bw2
local net_bg_normal     = bw1
local clock_bg_normal   = bw0

local gears            = require("gears")
-- local widgets          = require("widgets")
local awful            = require("awful")
local wibox            = require("wibox")
local naughty          = require("naughty")
local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi
local os, math, string = os, math, string

local theme      			= { }
local theme_name 			= "powerarrow-gruvbox"
theme.shape		 			= { }
theme.dir		 			= awful.util.getdir("config").."themes/"..theme_name
theme.xrdb 		 			= xresources.get_current_theme()
theme.icons_dir = awful.util.getdir("config").."/themes/icons/" ..theme_name.. "/"
awesome_icon = theme.icons_dir
path = theme.dir
theme.layouts_icon 			= theme.icons_dir .. "../layouts/"
theme.wallpaper_original	= theme.dir .. "/wallpapers/matterhorn.jpg"
theme.wallpaper             = theme.dir .. "/wallpapers/matterhorn_base.jpg"
theme.wallpaper_blur        = theme.dir .. "/wallpapers/matterhorn_blur.jpg"

local font_name                                 = "Iosevka Custom"
local font_size                                 = "11"

function theme.shape.powerline (cr, width, height)
   gears.shape.powerline(cr, width, height, -10)
end

theme.font                                      = font_name .. " " ..                         font_size
theme.font_bold                                 = font_name .. " " .. "Bold"        .. " " .. font_size
theme.font_italic                               = font_name .. " " .. "Italic"      .. " " .. font_size
theme.font_bold_italic                          = font_name .. " " .. "Bold Italic" .. " " .. font_size
theme.font_big                                  = font_name .. " " .. "Bold"        .. " 16"

theme.border_normal                             = bw2
theme.border_focus                              = bw5
theme.border_marked                             = bw5
theme.border_bar_normal                         = theme.border_normal

theme.fg_normal                                 = bw9
theme.fg_focus                                  = red_light
theme.fg_urgent                                 = bw0
theme.bg_normal                                 = bw0
theme.bg_focus                                  = bw2
theme.bg_urgent                                 = red_light
theme.bg_systray 								= "#313131"

theme.border_width                              = dpi(4)
-- theme.border_width                              = dpi(4)
theme.border_bar_width                          = dpi(2)
theme.border_radius                             = dpi(1)
theme.menu_height                               = dpi(20)
theme.menu_width                                = dpi(250)
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = true
theme.tasklist_spacing                          = dpi(3)
theme.useless_gap                               = dpi(14)

theme.bg_systray 								= theme.bg_normal
theme.systray_icon_spacing                      = dpi(4)

theme.snap_bg                                   = theme.border_focus

theme.taglist_font                              = theme.font_bold
theme.taglist_fg_normal                         = theme.fg_normal
theme.taglist_fg_focus                          = theme.fg_focus
theme.taglist_fg_urgent                         = bw0
theme.taglist_bg_normal                         = bw0
theme.taglist_bg_occupied                       = bw0
theme.taglist_bg_empty                          = bw0
theme.taglist_bg_volatile                       = bw0
theme.taglist_bg_focus                          = bw0
theme.taglist_bg_urgent                         = red_light

theme.tasklist_font_normal                      = theme.font
theme.tasklist_font_focus                       = theme.font_bold
theme.tasklist_font_urgent                      = theme.font_bold
theme.tasklist_fg_normal                        = bw7
theme.tasklist_fg_focus                         = bw9
theme.tasklist_fg_minimize                      = bw5
theme.tasklist_fg_urgent                        = red_light
theme.tasklist_bg_normal                        = bw0
theme.tasklist_bg_focus                         = bw0_h
theme.tasklist_bg_urgent                        = bw2
theme.tasklist_shape_border_color				= theme.border_bar_normal
theme.tasklist_shape_border_color_focus 	 	= theme.border_focus
theme.tasklist_shape_border_width		 	 	= dpi(2)
theme.tasklist_shape 							= theme.shape.powerline

theme.titlebar_fg_normal                        = bw5
theme.titlebar_fg_focus                         = bw8
theme.titlebar_fg_marked                        = bw8
theme.titlebar_bg_normal                        = theme.border_normal
theme.titlebar_bg_focus                         = theme.border_focus
theme.titlebar_bg_marked                        = theme.border_marked

theme.wibar_border_width 						= theme.border_radius
theme.wibar_border_color						= theme.border_normal

theme.hotkeys_border_width                      = dpi(30)
theme.hotkeys_border_color                      = bw0
theme.hotkeys_group_margin                      = dpi(30)
theme.hotkeys_shape                             = function(cr, width, height)
                                                      gears.shape.rounded_rect(cr, width, height, dpi(20))
                                                  end

theme.prompt_bg                                 = bw2
theme.prompt_fg                                 = theme.fg_normal
theme.bg_systray                                = theme.tasklist_bg_normal
-- theme.snap_shape                                = function(cr, w, h)
--                                                       gears.shape.rounded_rect(cr, w, h, theme.border_radius or 0)
--                                                   end

theme.menu_submenu_icon                         = theme.icons_dir .. "submenu.png"
theme.awesome_icon                              = theme.icons_dir .. "awesome.png"
theme.taglist_squares_sel                       = theme.icons_dir .. "square_sel.png"
theme.taglist_squares_unsel                     = theme.icons_dir .. "square_unsel.png"

theme.layout_cascadetile                        = theme.layouts_icon .. "cascadetile.png"
theme.layout_centerwork                         = theme.layouts_icon .. "centerwork.png"
theme.layout_cornerne                           = theme.layouts_icon .. "cornerne.png"
theme.layout_cornernw                           = theme.layouts_icon .. "cornernw.png"
theme.layout_cornerse                           = theme.layouts_icon .. "cornerse.png"
theme.layout_cornersw                           = theme.layouts_icon .. "cornersw.png"
theme.layout_dwindle                            = theme.layouts_icon .. "dwindle.png"
theme.layout_fairh                              = theme.layouts_icon .. "fairh.png"
theme.layout_fairv                              = theme.layouts_icon .. "fairv.png"
theme.layout_floating                           = theme.layouts_icon .. "floating.png"
theme.layout_fullscreen                         = theme.layouts_icon .. "fullscreen.png"
theme.layout_magnifier                          = theme.layouts_icon .. "magnifier.png"
theme.layout_max                                = theme.layouts_icon .. "max.png"
theme.layout_spiral                             = theme.layouts_icon .. "spiral.png"
theme.layout_tile                               = theme.layouts_icon .. "tile.png"
theme.layout_tilebottom                         = theme.layouts_icon .. "tilebottom.png"
theme.layout_tileleft                           = theme.layouts_icon .. "tileleft.png"
theme.layout_tiletop                            = theme.layouts_icon .. "tiletop.png"

theme.widget_ac                                 = theme.icons_dir .. "ac.png"
theme.widget_battery                            = theme.icons_dir .. "battery.png"
theme.widget_battery_low                        = theme.icons_dir .. "battery_low.png"
theme.widget_battery_empty                      = theme.icons_dir .. "battery_empty.png"
theme.widget_mem                                = theme.icons_dir .. "mem.png"
theme.widget_cpu                                = theme.icons_dir .. "cpu.png"
theme.widget_temp                               = theme.icons_dir .. "temp.png"
theme.widget_pacman                             = theme.icons_dir .. "pacman.png"
theme.widget_users                              = theme.icons_dir .. "user.png"
theme.widget_net                                = theme.icons_dir .. "net.png"
theme.widget_hdd                                = theme.icons_dir .. "hdd.png"
theme.widget_music                              = theme.icons_dir .. "note.png"
theme.widget_music_on                           = theme.icons_dir .. "note_on.png"
theme.widget_music_pause                        = theme.icons_dir .. "pause.png"
theme.widget_music_stop                         = theme.icons_dir .. "stop.png"
theme.widget_vol                                = theme.icons_dir .. "vol.png"
theme.widget_vol_low                            = theme.icons_dir .. "vol_low.png"
theme.widget_vol_no                             = theme.icons_dir .. "vol_no.png"
theme.widget_vol_mute                           = theme.icons_dir .. "vol_mute.png"
theme.widget_mail                               = theme.icons_dir .. "mail.png"
theme.widget_mail_on                            = theme.icons_dir .. "mail_on.png"
theme.widget_task                               = theme.icons_dir .. "task.png"
theme.widget_scissors                           = theme.icons_dir .. "scissors.png"

theme.titlebar_close_button_focus               = theme.icons_dir .. "/titlebar_light/close_focus.png"
theme.titlebar_close_button_normal              = theme.icons_dir .. "/titlebar_light/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.icons_dir .. "/titlebar_light/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.icons_dir .. "/titlebar_light/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.icons_dir .. "/titlebar_light/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.icons_dir .. "/titlebar_light/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.icons_dir .. "/titlebar_light/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.icons_dir .. "/titlebar_light/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.icons_dir .. "/titlebar_light/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.icons_dir .. "/titlebar_light/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.icons_dir .. "/titlebar_light/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.icons_dir .. "/titlebar_light/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.icons_dir .. "/titlebar_light/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.icons_dir .. "/titlebar_light/floating_normal_inactive.png"
theme.titlebar_minimize_button_focus_active     = theme.icons_dir .. "/titlebar_light/minimized_focus_active.png"
theme.titlebar_minimize_button_normal_active    = theme.icons_dir .. "/titlebar_light/minimized_normal_active.png"
theme.titlebar_minimize_button_focus_inactive   = theme.icons_dir .. "/titlebar_light/minimized_focus_inactive.png"
theme.titlebar_minimize_button_normal_inactive  = theme.icons_dir .. "/titlebar_light/minimized_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.icons_dir .. "/titlebar_light/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.icons_dir .. "/titlebar_light/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.icons_dir .. "/titlebar_light/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.icons_dir .. "/titlebar_light/maximized_normal_inactive.png"

theme.notification_fg                           = theme.fg_normal
theme.notification_bg                           = theme.bg_normal
theme.notification_border_color                 = theme.border_normal
theme.notification_border_width                 = theme.border_width
theme.notification_icon_size                    = dpi(80)
-- theme.notification_opacity                      = 0.9
theme.notification_max_width                    = dpi(600)
theme.notification_max_height                   = dpi(400)
theme.notification_margin                       = dpi(20)
theme.notification_shape                        = function(cr, width, height)
                                                      gears.shape.rounded_rect(cr, width, height, theme.border_radius or 0)
                                                  end

naughty.config.padding                          = dpi(15)
naughty.config.spacing                          = dpi(10)
naughty.config.defaults.timeout                 = 5
naughty.config.defaults.margin                  = theme.notification_margin
naughty.config.defaults.border_width            = theme.notification_border_width

naughty.config.presets.normal                   = {
                                                      font         = theme.font,
                                                      fg           = theme.notification_fg,
                                                      bg           = theme.notification_bg,
                                                      border_width = theme.notification_border_width,
                                                      margin       = theme.notification_margin,
                                                  }

naughty.config.presets.low                      = naughty.config.presets.normal
naughty.config.presets.ok                       = naughty.config.presets.normal
naughty.config.presets.info                     = naughty.config.presets.normal
naughty.config.presets.warn                     = naughty.config.presets.normal

naughty.config.presets.critical                 = {
                                                      font         = theme.font,
                                                      fg           = bw9,
                                                      bg           = red_dark,
                                                      border_width = theme.notification_border_width,
                                                      margin       = theme.notification_margin,
                                                      timeout      = 0,
                                                  }




theme.arrl                          = theme.icons_dir .. "../powerarrow-dark/arrl.png"
theme.arrl_dl                       = theme.icons_dir .. "../powerarrow-dark/arrl_dl.png"
theme.arrl_ld                       = theme.icons_dir .. "../powerarrow-dark/arrl_ld.png"

theme.email_icon 					= theme.icons_dir .. "mail.png"
theme.email_on_icon 				= theme.icons_dir .. "mail_on.png"
theme.volume_icon 					= theme.icons_dir .. "vol.png"
theme.volume_low_icon 				= theme.icons_dir .. "vol_low.png"
theme.volume_mute_icon 				= theme.icons_dir .. "vol_mute.png"
theme.volume_no_icon 				= theme.icons_dir .. "vol_no.png"
theme.music_icon	 				= theme.icons_dir .. "note.png"
theme.music_on_icon	 				= theme.icons_dir .. "note_on.png"
theme.memory						= theme.icons_dir .. "mem.png"
theme.cpu							= theme.icons_dir .. "cpu.png"


return theme
