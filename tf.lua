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
local function writeString(str, monitor)
    assert(isString(str), "Input string must be a valid coloured string.")

    monitor = monitor or term

    local monitor_fg = colours.toBlit(term.getTextColour())
    local monitor_bg = colours.toBlit(term.getBackgroundColour())
    local fg = string.gsub(str.fg, "_", monitor_fg)
    local bg = string.gsub(str.bg, "_", monitor_bg)

    monitor.blit(str.string, str.fg, str.bg)
end

return {isString = isString, createString = createString, writeString = writeString}