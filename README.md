# ECCCCRSBTFS
EC Computer Craft Create Rails Server Basic Text Formatting System. Shortened to `TF`, is a basic text formatting system to be used on the computers for the EC gamers discord server Create Rails server.
# How to use
## Formatting
Tags are used to swich or suggest the formatting of the text. Tags always start with a `$` therefore in order to have a `$` as text you need to type `$$`. The current tags are shown in the table below.
| Tag        | Purpose                                                                                                                                                          |
| :--------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `$f{1}`    | Switch the colour of the text to be `{1}` where `{1}` is a hexadecimal digit referring to the colour in the current colour palette.                              |
| `$b{1}`    | Switch the colour of the background below the current text to be `{1}` where `{1}` is a hexadecimal digit referring to the colour in the current colour palette. |
| `$c{1}{2}` | Switch the foreground  and background colour of the text to be `{1}` and `{2}` respectively.                                                                     |
| `$n`       | Force the following text to be on a new. line.                                                                                                                   |
| `$s`       | Suggest an optional split point, useful for part way through a long word.                                                                                        |
| `$$`       | Writes a single $ character.                                                                                                                                     |

For example, to send a message such as `ERROR    Turtle is on fire!` with the word `ERROR` having a red background and the word `fire` in orange, you would use `$beERROR$bf    Turtle is on $f1fire$f0!`.
## Implementation
### Installing
Type the following command into the terminal.
```
wget https://raw.githubusercontent.com/Mcrevs/text-generator/main/TF.lua
```
### Importing
```lua
local TF = require("TF")
```
### Creating a `Text` instance
The example below uses the example message text from the formatting example.
```lua
local in_text = "$beERROR$bf    Turtle is on $f1fire$f0!"
local text = TF.Text:new(in_text)
```
### Splitting text by lines
Optional if text can be forced on one line.
```lua
local width, height = term.getSize()
text:split(width)
```
To specify how much blank space can be left at the end of a line.
```lua
local width, height = term.getSize()
local blank_space = 5
text:split(width, blank_space)
```
### Getting the line count
To get the number of lines that the text takes up after it has been split.
```lua
text:getLineCount()
```
### Drawing text
To draw the text to the screen.
```lua
text:print()
```
To specify what screen to draw the text to, for use with monitors. Drawn at the current cursor position.
```lua
local monitor = term
text:print(monitor)
```
To specify the coordinates (top left) to draw the text from.
```lua
local monitor = term
local x = 5
local y = 5
text:print(monitor, x, y)
```
To specify the range of lines of text to be drawn, useful for scrolling.
```lua
local monitor = term
local x = 5
local y = 5
local first_line = 2
local last_line = 5
text:print(term, x, y, first_line, last_line)
```
## Basic example
```lua
local TF = require("TF")

local in_text = "$beHELP$bf The turtle is on $f1fire$f0! Someone get some $f3water$f0 to help put it out."
local text = TF.Text:new(in_text)

local width, height = term.getSize()
text:split(width)

text:print()
```