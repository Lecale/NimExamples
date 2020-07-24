# Totally a work in progress
# should have labels around the edge of the board
# Idea is to have a keyboard based UI to create diagrams

import nigui
import strutils

proc butty(xy: string) : void =
  
  return

proc mkLabel(a,b,c,d: int, l: Label, con: Container) : void =
  con.add(l)
  l.x = a
  l.y = b
  l.height = c
  l.width = d
  return

app.init()
let xyyx: string = "abcdefghjklmnopqrst"
var window = newWindow()
var bigcontainer = newContainer()
let MODES: seq[string] = @["PLAY_B","PLAY_W","MARK","ADD+B","ADD_W","PRINT"]
let MARKS: seq[string] = @["","T","S","C","A","1"]
var current_mode:int = 0
var current_mark:int = 0
var instruction: string = ""
window.add(bigcontainer)

var xy:seq[Button] = @[]
var yOrigin: int = 0
for i in xyyx:
    var xOrigin:int = 0
    for j in xyyx:
        var ab = newButton(i&j)
        bigcontainer.add(ab)
        ab.y = 1 + yOrigin
        ab.x = 1 + xOrigin
        ab.height = 25;
        ab.width = 25;
        xy.add(ab)
        xOrigin = xOrigin + 25
    yOrigin = yOrigin + 25

var status = newLabel()
mkLabel(1,500,25,500,status,bigcontainer)

var label = newLabel()
mkLabel(1,530,25,500,label,bigcontainer)

var markUpOne = newLabel()
mkLabel(501,1,25,25,markUpOne,bigcontainer)
markUpOne.backgroundColor = rgb(0, 255, 0) # lime

var markUpTwo = newLabel()
mkLabel(501,26,25,25,markUpTwo,bigcontainer)
markUpTwo.backgroundColor = rgb(0, 0, 255) # lime

var toggle = newLabel()
mkLabel(501,51,25,50,toggle,bigcontainer)
toggle.text = "#"

# Unicode loves you
# 65-90  A-Z
# 97-122 a-z
# 0 arrow keys or other things
# 13 is ENTER
window.onKeyDown = proc(event: KeyboardEvent) =
  if event.unicode == 0 :
    echo "KEYCODE " & $event.key
    # loop through MODES
    if $event.key == "Key_Up":
      current_mode = current_mode + 1
    if $event.key == "Key_Down":
      current_mode = current_mode - 1
    if $event.key == "Key_Right":
      current_mode = current_mark + 1
    if $event.key == "Key_Left":
      current_mode = current_mark - 1
    if current_mark == -1 :
      current_mark = MARKS.len - 1
    if current_mode == -1 :
      current_mode = MODES.len - 1
    if current_mark == MODES.len :
      current_mark = 0
    if current_mode == MARKS.len :
      current_mode = 0
    status.text = MODES[current_mode] & "[" & MARKS[current_mark] & "]"

  if event.unicode == 13 :
    echo "ENTER"
    status.text = instruction
    # take the instruction
    # apply coloring to grid or markup to grid
    instruction = ""
  if event.unicode > 96 :
    if event.unicode < 123 :
      if instruction.len < 2 :
        instruction = instruction & event.character
      else :
        instruction = event.character
      label.text = instruction

  if event.unicode > 64 :
    if event.unicode < 91 :
      if instruction.len < 2 :
        instruction = instruction & toLower(event.character)
      else :
        instruction = toLower(event.character)
      label.text = instruction

#  echo label.text & ", unicode: " & $event.unicode

  # Ctrl + Q -> Quit application
  if Key_Q.isDown() and Key_ControlL.isDown():
    app.quit()

#textBox.onKeyDown = proc(event: KeyboardEvent) =
#  label.text = "TextBox KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & ", down keys: " & $downKeys() & "\n"

  # Accept only digits
  if event.character.len > 0 and event.character[0].ord >= 32 and (event.character.len != 1 or event.character[0] notin '0'..'9'):
    event.handled = true

window.show()
app.run()
