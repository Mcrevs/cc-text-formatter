local TF = require("TF")

term.clear()
term.setCursorPos(1, 1)

local x, y = 10, 3
local width, height = term.getSize()
TF.Fill(1, 1, width, height, term, "7")
width = width - 19
height = height - 5

local text = TF.Text:new("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ullamcorper, ex id ullamcorper tempus, nisi lectus placerat nisl, vitae finibus felis quam et ex. Vivamus elementum magna vitae ultrices laoreet. Maecenas pulvinar sem scelerisque, malesuada ipsum sed, consectetur nulla. Nulla facilisi. Interdum et malesuada fames ac ante ipsum primis in faucibus.$nVivamus id enim ac nunc semper congue vel quis nisl. Nullam ac vestibulum risus, nec pulvinar nisi. Sed nec consectetur enim. Interdum et malesuada fames ac ante ipsum primis in faucibus.")
text:split(width)

TF.Fill(x, y, width, height, term, "f")
text:print(term, x, y, 1, height)

local position = 1
while true do
    local event, dir, ex, ey = os.pullEvent("mouse_scroll")
    position = position + dir

    TF.Fill(x, y, width, height)
    text:print(term, x, y, position, position + height - 1)
end