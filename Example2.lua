local TF = require("TF")

term.clear()
term.setCursorPos(1, 1)

local width, height = term.getSize()
local text = TF.Text:new("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ullamcorper, ex id ullamcorper tempus, nisi lectus placerat nisl, vitae finibus felis quam et ex. Vivamus elementum magna vitae ultrices laoreet. Maecenas pulvinar sem scelerisque, malesuada ipsum sed, consectetur nulla. Nulla facilisi. Interdum et malesuada fames ac ante ipsum primis in faucibus.$nVivamus id enim ac nunc semper congue vel quis nisl. Nullam ac vestibulum risus, nec pulvinar nisi. Sed nec consectetur enim. Interdum et malesuada fames ac ante ipsum primis in faucibus.")
text:split(width)
text:print(term, 1, 1)

while true do
    local event, dir, ex, ey = os.pullEvent("mouse_scroll")
    width = math.max(width + dir, 1)

    term.clear()
    text:split(width)
    text:print(term, 1, 1)
end