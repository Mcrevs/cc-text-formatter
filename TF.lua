Symbol = {character = " ", fg = "0", bg = "f", control = false}
Line = {text = "", fg = "", bg = ""}
Text = {coloured = {}, lines = {}}

function Symbol:new(character, fg, bg, control, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.character = character or " "
    o.fg = fg or "0"
    o.bg = bg or "f"
    o.control = control or false

    return o
end


function Line:new(text, fg, bg, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.text = text or ""
    o.fg = fg or ""
    o.bg = bg or ""

    return o
end

function Line:addChar(char, fg, bg)
    self.text = self.text .. char
    self.fg = self.fg .. fg
    self.bg = self.bg .. bg
end

function Line:addSymbol(symbol)
    self.text = self.text .. symbol.character
    self.fg = self.fg .. symbol.fg
    self.bg = self.bg .. symbol.bg
end

function Line:appendLine(line)
    self.text = self.text .. line.text
    self.fg = self.fg .. line.fg
    self.bg = self.bg .. line.bg
end


function Text:new(text, o)
    -- Class setup
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.coloured = {};
    o.lines = {}

    --String interpretation
    text = text or "$feH$f1E$f4L$f5L$fbL$faO$f0 $cfeW$b1O$b4R$b5L$bbD$ba!$c0f $$"
    text = string.gsub(text, "[\n\r]", "$n")
    local fg = "0"
    local bg = "f"

    local i = 1
    while i <= #text do
        if string.find(string.sub(text, i), "^$f%x") ~= nil then
            fg = string.sub(text, i+2, i+2)
            i = i + 3
        elseif string.find(string.sub(text, i), "^$b%x") ~= nil then
            bg = string.sub(text, i+2, i+2)
            i = i + 3
        elseif string.find(string.sub(text, i), "^$c%x") ~= nil then
            fg = string.sub(text, i+2, i+2)
            bg = string.sub(text, i+3, i+3)
            i = i + 4
        elseif string.find(string.sub(text, i), "^$n") ~= nil then
            o.coloured[#o.coloured+1] = Symbol:new("n", fg, bg, true)
            i = i + 2
        elseif string.find(string.sub(text, i), "^$s") ~= nil then
            o.coloured[#o.coloured+1] = Symbol:new("s", fg, bg, true)
            i = i + 2
        elseif string.find(string.sub(text, i), "^$[$]") ~= nil then
            o.coloured[#o.coloured+1] = Symbol:new("$", fg, bg)
            i = i + 2
        else
            o.coloured[#o.coloured+1] = Symbol:new(string.sub(text, i, i), fg, bg)
            i = i + 1
        end
    end

    --One line output processing
    o.lines[#o.lines+1] = Line:new()
    for k, s in ipairs(o.coloured) do
        if not s.control then
            o.lines[#o.lines]:addChar(s.character, s.fg, s.bg)
        end
    end

    return o
end

function Text:split(width, max_backtrack)
    width = width or 1000000000000
    if width > 2 then
        max_backtrack = max_backtrack or math.floor(1.5 * math.sqrt(width - 2))
    end
    max_backtrack = max_backtrack or 0

    self.lines = {}

    local line = Line:new()
    local line_length = 0

    local join_char = Symbol:new("", "", "")
    local join_char_length = 0

    local working_line = Line:new()
    local working_line_length = 0

    local i = 1
    while i <= #self.coloured do
        local good_split = self.coloured[i].control
        good_split = good_split or string.find(self.coloured[i].character, "^[%s]") ~= nil

        local delete_on_split = self.coloured[i].control
        delete_on_split = delete_on_split or string.find(self.coloured[i].character, "^[%s]") ~= nil

        local will_fit = line_length + join_char_length + working_line_length < width
        local will_fit_if_deleted = line_length + join_char_length + working_line_length <= width and good_split and delete_on_split
        local require_new_line = self.coloured[i].control and self.coloured[i].character == "n"
        local can_put_char = will_fit or will_fit_if_deleted

        if can_put_char then
            if good_split then
                --Add the working line to the line with the join character
                line:addSymbol(join_char)
                line:appendLine(working_line)
                line_length = line_length + join_char_length + working_line_length
                working_line = Line:new()
                working_line_length = 0
                --Update the join_char
                if delete_on_split then
                    join_char = self.coloured[i]
                    join_char_length = 1
                else
                    join_char = Symbol:new("", "", "")
                    join_char_length = 0
                    line:addSymbol(self.coloured[i])
                    line_length = line_length + 1
                end
            else
                if not self.coloured[i].control then
                    working_line:addSymbol(self.coloured[i])
                    working_line_length = working_line_length + 1
                end
            end
        end

        if not (can_put_char) or require_new_line then
            if working_line_length < max_backtrack then
                self.lines[#self.lines+1] = line

                line = working_line
                line_length = working_line_length

                join_char = Symbol:new("", "", "")
                join_char_length = 0

                working_line = Line:new()
                working_line_length = 0
            else
                line:addSymbol(join_char)
                line:appendLine(working_line)
                self.lines[#self.lines+1] = line

                line = Line:new()
                line_length = 0

                join_char = Symbol:new("", "", "")
                join_char_length = 0

                working_line = Line:new()
                working_line_length = 0
            end
        end

        if can_put_char then
            i = i + 1
        end
    end

    line:addSymbol(join_char)
    line:appendLine(working_line)
    self.lines[#self.lines+1] = line
end

function Text:print(out, x, y, start_line, end_line)
    out = out or term

    local cx, cy = out.getCursorPos()
    local width, height = out.getSize()
    x = x or cx
    y = y or cy
    out.setCursorPos(x, y)

    local lines_specified = start_line ~= nil
    start_line = start_line or 1
    end_line = end_line or #self.lines

    for i = start_line, end_line do
        local s = self.lines[i] or Line:new("", "", "")
        out.blit(s.text, s.fg, s.bg)

        if y >= height and not lines_specified then
            out.scroll(1)
            out.setCursorPos(x, y)
        else
            y = y + 1
            out.setCursorPos(x, y)
        end
    end
end

function Fill(x, y, width, height, out, bg)
    out = out or term
    bg = bg or "f"
    local cx, cy = out.getCursorPos()

    local text = string.rep(" ", width)
    local fg = string.rep("0", width)
    bg = string.rep(bg, width)

    for i = 0, height - 1 do

        out.setCursorPos(x, y + i)
        out.blit(text, fg, bg)
    end

    out.setCursorPos(cx, cy)
end

function Text:getLineCount()
    return #self.lines
end

return {Text = Text, Fill = Fill}