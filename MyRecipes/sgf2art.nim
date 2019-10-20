import strutils, random

let start = readFile("blank.svg") 
let startSeq = start.splitLines()

const UP:int = 26  
const SIDE:int = 25  

var sgf = readfile("a.sgf")
var xOrd: seq[int] = @[]
var yOrd: seq[int] = @[]
const colors =  ["aqua","blue","fuschia","gray","green","lime","maroon","navy","olive","purple","red","teal","yellow"]
let ply: seq[string] = sgf.split(  ";"  )

echo 4545/4242

for i in countup(2, ply.len-1):
# unicode alignment
  var turns: seq[string] = ply[i].split( { '[' , ']' }  )
  xOrd.add(ord(turns[1][0])-97)
  yOrd.add(ord(turns[1][1])-97)
  #echo "move ", xOrd[i-2] , "," , yOrd[i-2] , colors[i mod colors.len]

var output = open("test.svg", fmWrite)
# Use the lines iterator to traverse the file
for ss in startSeq:
  # And write the output line by line to a new file
  output.writeLine(ss)
  
var brush: string
for i in countup(0,xOrd.len-1):
  let x = 12 + xOrd[i]*24
  let y = 12 + yOrd[i]*24
  brush = "<circle cx=\""
  brush.add($x)
  brush.add("\" cy=\"")
  brush.add($y)
  brush.add("\" r=\"10\" fill=\"")
  brush.add(colors[i mod colors.len])
  brush.add("\"/>")
  output.writeline(brush)

output.writeLine("</g></g></svg>")