-- MIT License

-- Copyright (c) 2024 Mcrevs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- A table to store a single line of text and its colouring.
local String = {string = "", fg = "", bg = ""}

--- Find out weather or not a table is likely to be a valid coloured string.
--- @param str table The coloured string to validate.
--- @return boolean valid Weather or not the string is a valid coloured string.
local function isString(str)
    if type(str) ~= "table" then return false end
    if type(str.string) ~= "string" then return false end
    if type(str.fg) ~= "string" then return false end
    if type(str.bg) ~= "string" then return false end
    if #str.fg ~= #str.string then return false end
    if #str.bg ~= #str.string then return false end
    return true
end

--- Create a coloured string from a raw string input.
--- @param text string The string to be converted.
--- @return table string A coloured string.
local function createString(text)
    assert(type(text) == "string", "Text input must be a string.")

    local o = {}
    o.string = "";
    o.fg = "";
    o.bg = "";

    --String interpretation
    local fg = "_"
    local bg = "_"

    local i = 1
    while i <= #text do
        if string.find(string.sub(text, i), "^$f[%x_]") ~= nil then
            fg = string.sub(text, i+2, i+2)
            i = i + 3
        elseif string.find(string.sub(text, i), "^$b[%x_]") ~= nil then
            bg = string.sub(text, i+2, i+2)
            i = i + 3
        elseif string.find(string.sub(text, i), "^$c[%x_][%x_]") ~= nil then
            fg = string.sub(text, i+2, i+2)
            bg = string.sub(text, i+3, i+3)
            i = i + 4
        elseif string.find(string.sub(text, i), "^$[$]") ~= nil then
            o.string = o.string .. "$"
            o.fg = o.fg .. fg
            o.bg = o.bg .. bg
            i = i + 2
        else
            o.string = o.string .. string.sub(text, i, i)
            o.fg = o.fg .. fg
            o.bg = o.bg .. bg
            i = i + 1
        end
    end

    return o
end

--- Display a coloured string to the terminal at the current cursor position, forground, and background colour.
--- @param str table The coloured string to be displayed.
--- @param monitor table | nil The terminal/monitor to display the text to.
local function write(str, monitor)
    assert(isString(str), "Input string must be a valid coloured string.")

    monitor = monitor or term

    local monitor_fg = colours.toBlit(term.getTextColour())
    local monitor_bg = colours.toBlit(term.getBackgroundColour())
    local fg = string.gsub(str.fg, "_", monitor_fg)
    local bg = string.gsub(str.bg, "_", monitor_bg)

    monitor.blit(str.string, fg, bg)
end

--- Get the length of a coloured string.
--- @param str table The coloured string to find the length of.
--- @return number length The length of the sring.
local function length(str)
    assert(isString(str), "Input string must be a valid coloured string.")

    return #str.string
end

--- Get a substring from a coloured string.
--- @param str table The source coloured string.
--- @param i number The starting index to get the substring from.
--- @param j number The ending index to get the substring from.
--- @return table string The sub string.
local function sub(str, i, j)
    assert(isString(str), "Input string must be a valid coloured string.")

    local o = {}
    o.string = string.sub(str.string, i, j)
    o.fg = string.sub(str.fg, i, j)
    o.bg = string.sub(str.bg, i, j)
    return o
end

--- Join two coloured strings together.
--- @param str1 table The first coloured string.
--- @param str2 table The second coloured string.
--- @return table string The joined string.
local function join(str1, str2)
    assert(isString(str1), "Input string must be a valid coloured string.")
    assert(isString(str2), "Input string must be a valid coloured string.")

    local o = {}
    o.string = str1.string .. str2.string
    o.fg = str1.fg .. str2.fg
    o.bg = str1.bg .. str2.bg
    return o
end

--- Split one string into multiple lines based off of width and some control characters.
--- @param str table The coloured string to split.
--- @param width number The maximum widht a line can be.
--- @param backtrack number | nil The maximum empty space that can be left at the end of a line.
--- @param max_lines number | nil How many lines to split.
--- @return table lines, table remaining A list of coloured strings witch are each individual line and optionally any text that was not split.
local function split(str, width, backtrack, max_lines)
    assert(isString(str), "Input string must be a valid coloured string.")
    assert(type(width) == "number", "Width must be a number.")

    if width > 2 then
        backtrack = backtrack or math.floor(1.5 * math.sqrt(width - 2))
    end
    backtrack = backtrack or 0

    max_lines = max_lines or -1

    assert(type(backtrack) == "number", "Backtrack must be a number or nil.")
    assert(type(max_lines) == "number", "Lines must be a number.")

    local lines = {}

    local line = {string = "", fg = "", bg = ""}
    local line_length = 0

    local join_char = {string = "", fg = "", bg = ""}
    local join_char_length = 0

    local working_line = {string = "", fg = "", bg = ""}
    local working_line_length = 0

    local i = 1
    while i <= #str.string and (max_lines < 0 or #lines < max_lines) do
        local good_split = string.find(string.sub(str.string, i, i), "^[%s\n]") ~= nil
        local delete_on_split = string.find(string.sub(str.string, i, i), "^[%s\n]") ~= nil
        local require_new_line = string.find(string.sub(str.string, i, i), "^[\n]") ~= nil

        local will_fit = line_length + join_char_length + working_line_length < width
        local will_fit_if_deleted = line_length + join_char_length + working_line_length <= width and good_split and delete_on_split
        local can_put_char = will_fit or will_fit_if_deleted

        if can_put_char then
            if good_split then
                --Add the working line to the line with the join character
                line = join(line, join_char)
                line = join(line, working_line)
                line_length = line_length + join_char_length + working_line_length
                working_line = {string = "", fg = "", bg = ""}
                working_line_length = 0
                --Update the join_char
                if delete_on_split then
                    join_char = sub(str, i, i)
                    join_char_length = 1
                else
                    join_char = {string = "", fg = "", bg = ""}
                    join_char_length = 0
                    line = join(line, sub(str, i, i))
                    line_length = line_length + 1
                end
            else
                working_line = join(working_line, sub(str, i, i))
                working_line_length = working_line_length + 1
            end
        end

        if not (can_put_char) or require_new_line then
            if working_line_length < backtrack then
                lines[#lines+1] = line

                line = working_line
                line_length = working_line_length

                join_char = {string = "", fg = "", bg = ""}
                join_char_length = 0

                working_line = {string = "", fg = "", bg = ""}
                working_line_length = 0
            else
                line = join(line, join_char)
                line = join(line, working_line)
                lines[#lines + 1] = line

                line = {string = "", fg = "", bg = ""}
                line_length = 0

                join_char = {string = "", fg = "", bg = ""}
                join_char_length = 0

                working_line = {string = "", fg = "", bg = ""}
                working_line_length = 0
            end
        end

        if can_put_char then
            i = i + 1
        end
    end

    line = join(line, join_char)
    line = join(line, working_line)
    if max_lines < 0 or #lines < max_lines then
        lines[#lines + 1] = line
        line = {string = "", fg = "", bg = ""}
    end

    return lines, sub(str, i - length(line), length(str))
end

--- Add characters before a string to align it within a given width.
--- @param str table The coloured string to allign.
--- @param width number The width of the area to align the string to.
--- @param alignment string | nil The alignment of the string, "left", "centre", "right".
--- @param padding string | nil The caracter to be used to pad the string if necessary.
--- @param fill boolean | nil Weather to pad on the right of the string aswell.
--- @return table string The coloured string after being padded and aligned.
local function align(str, width, alignment, padding, fill)
    padding = padding or " "
    fill = fill or false

    assert(isString(str), "Input string must be a valid coloured string.")
    assert(type(width) == "number", "Width must be a number.")
    assert(type(padding) == "string", "Padding character must be a string")
    assert(type(fill) == "boolean", "Fill must be a boolean.")

    local string_length = #str.string

    local padding_length = 0
    if alignment == "left" or alignment == nil then
        padding_length = 0
    elseif alignment == "centre" then
        padding_length = math.floor((width - string_length) / 2)
    elseif alignment == "right" then
        padding_length = width - string_length
    else
        error("Alignment must be nil, \"left\", \"right\" or \"Centre\".")
    end

    local padding_right_length = 0
    if fill then
        padding_right_length = width - padding_length
    end

    local text_padding = string.rep(padding, padding_length)
    local text_padding_right = string.rep(padding, padding_right_length)
    local colour_padding = string.rep("_", padding_length)
    local colour_padding_right = string.rep("_", padding_right_length)

    local o = {}
    o.string = text_padding .. str.string .. text_padding_right;
    o.fg = colour_padding .. str.fg .. colour_padding_right;
    o.bg = colour_padding .. str.bg .. colour_padding_right;
    return o
end

--- Add characters before a string to align it within a given width for every line in a list.
--- @param lines table The list of coloured string to allign.
--- @param width number The width of the area to align the lines to.
--- @param alignment string | nil The alignment of the lines, "left", "centre", "right".
--- @param padding string | nil The caracter to be used to pad the lines if necessary.
--- @param fill boolean | nil Weather to pad on the right of the text aswell.
--- @return table lines The list of coloured strings after being padded and aligned.
local function alignLines(lines, width, alignment, padding, fill)
    local o = {}
    for i, line in ipairs(lines) do
        o[i] = align(line, width, alignment, padding, fill)
    end
    return o
end

--- Print a string to the screen, coloured using the coloured text format.
--- @param str string The raw string to print.
--- @param monitor table | nil The terminal/monitor to display the text to.
local function print(str, monitor)
    assert(type(str) == "string", "Striing input must be a string.")
    monitor = monitor or term

    local x, y = monitor.getCursorPos()
    local width, height = monitor.getSize()

    local backtrack = 0
    if width > 2 then
        backtrack = math.floor(1.5 * math.sqrt(width - 2))
    end

    local coloured_string = createString(str)
    local first_line, remaining = split(coloured_string, width - x, backtrack, 1)
    local remaining_lines = split(remaining, width, backtrack)

    local lines = {}
    lines[1] = first_line[1]
    if length(remaining) ~= 0 then
        for i, line in ipairs(remaining_lines) do
            lines[#lines+1] = line
        end
    end

    local scroll_ammount = math.max(y + #lines - height, 0)
    monitor.scroll(scroll_ammount)
    y = y - scroll_ammount

    monitor.setCursorPos(x, y)

    for i, line in ipairs(lines) do
        write(line, monitor)
        monitor.setCursorPos(1, y + i)
    end
end

return {
    isString = isString,
    createString = createString,
    write = write,
    length = length,
    sub = sub,
    join = join,
    split = split,
    align = align,
    alignLines = alignLines,
    print = print
}