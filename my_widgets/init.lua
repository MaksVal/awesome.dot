local module_path = (...):match ("(.+/)[^/]+$") or ""

package.loaded.my_widgets = nil

local my_widgets = {
   pulseaudio   = require(module_path .. "my_widgets.pulseaudio"),
   music		= require(module_path .. "my_widgets.music"),
   brightness	= require(module_path .. "my_widgets.brightness"),
   memory 		= require(module_path .. "my_widgets.memory"),
   cpu 		= require(module_path .. "my_widgets.cpu")
   -- awesompd		= require(module_path .. "my_widgets.awesompd.awesompd"),
}

return my_widgets
