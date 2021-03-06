local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = beautiful.battery_bar_active_color or "#5AA3CC"
local background_color = beautiful.battery_bar_background_color or "#222222"

-- Configuration
local update_interval = 30            -- in seconds

local battery_bar = wibox.widget{
  max_value     = 100,
  value         = 50,
  forced_height = 10,
  margins       = {
    top = 10,
    bottom = 10,
  },
  forced_width  = 200,
  shape         = gears.shape.rounded_bar,
  bar_shape     = gears.shape.rounded_bar,
  color         = active_color,
  background_color = background_color,
  border_width  = 0,
  border_color  = beautiful.border_color,
  widget        = wibox.widget.progressbar,
}

local function update_widget(bat)
  battery_bar.value = bat
end

local bat_script = [[
  bash -c '
  upower -i $(upower -e | grep BAT) | grep percentage
  ']]

awful.widget.watch(bat_script, update_interval, function(widget, stdout)
                     local bat = stdout:match(':%s*(.*)..')
                     -- bat = string.gsub(bat, '^%s*(.-)%s*$', '%1')
                     update_widget(bat)
end)

return battery_bar
