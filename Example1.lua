local TF = require("TF")

term.clear()
term.setCursorPos(1, 1)

local x, y = 11, 4
local width, height = term.getSize()
width = width - 20
height = height - 6

local text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ullamcorper, ex id ullamcorper tempus, nisi lectus placerat nisl, vitae finibus felis quam et ex. Vivamus elementum magna vitae ultrices laoreet. Maecenas pulvinar sem scelerisque, malesuada ipsum sed, consectetur nulla. Nulla facilisi. Interdum et malesuada fames ac ante ipsum primis in faucibus.$nVivamus id enim ac nunc semper congue vel quis nisl. Nullam ac vestibulum risus, nec pulvinar nisi. Sed nec consectetur enim. Interdum et malesuada fames ac ante ipsum primis in faucibus."
local textBox = TF.TextBox:new(text, x, y, width, height, "f", "0", true)

while true do
    textBox:print()

    local event, dir, ex, ey = os.pullEvent("mouse_scroll")

    textBox:scroll(dir, ex, ey)
end