-- Inspiration from http://awesome.naquadah.org/wiki/Volume_control_and_display

local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()

    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("%3d", volume)

    status = string.match(status, "%[(o[^%]]*)%]")

    if string.find(status, "on", 1, true) then
        volume = volume.."%"
    else
        volume = volume .. "M"
    end
    widget:set_markup("Vol: "..volume)
end

update_volume(volume_widget)
volume_timer = timer({ timeout = 1 })
volume_timer:connect_signal("timeout",
    function () update_volume(volume_widget) end)
volume_timer:start()
