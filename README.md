# Text Formatter
Text formatter (tf) is a basic computer craft text formatting system used for creating inline coloured text.

# How to use
## Formatting
Tags are used to swich or suggest the formatting of the text. Tags always start with a `$` therefore in order to have a `$` as text you need to type `$$`. The current tags are shown in the table below.
| Tag        | Purpose                                                                                                                                                                                                                   |
| :--------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `$f{1}`    | Switch the colour of the text to be `{1}` where `{1}` is a hexadecimal digit referring to the colour in the current colour palette or a `_` specifying to use the default foreground colour.                              |
| `$b{1}`    | Switch the colour of the background below the current text to be `{1}` where `{1}` is a hexadecimal digit referring to the colour in the current colour palette or a `_` specifying to use the default background colour. |
| `$c{1}{2}` | Switch the foreground  and background colour of the text to be `{1}` and `{2}` respectively. Equivelent to `$f{1}$b{2}.`                                                                                                  |
| `$$`       | Writes a single $ character.                                                                                                                                                                                              |

For example, to send a message such as `ERROR    Turtle is on fire!` with the word `ERROR` having a red background and the word `fire` in orange, you would use `$beERROR$bf    Turtle is on $f1fire$f0!`.
## Quick start guide
### Installing
Type the following command into the terminal to download the required lua file.
```
wget https://raw.githubusercontent.com/Mcrevs/text-formatter/v2.0.0/tf.lua
```
### Importing
Add this to the start of your program file to include the library. 
```lua
local tf = require("tf")
```
### Printing
Print a coloured string accross multiple lines if required. **NOT YET IMPLEMENTED**
```lua
tf.print("$feH$f1E$f4L$f5L$fbL$faO$f0 $cfeW$b1O$b4R$b5L$bbD$ba!")
```