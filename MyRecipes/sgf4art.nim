import strutils, random

let start = readFile("blank.svg") 
let startSeq = start.splitLines()

var sgf = readfile("a.sgf")
var xOrd: seq[int] = @[]
var yOrd: seq[int] = @[]
const colors =  ["aqua","blue","fuschia","gray","green","lime","maroon","navy","olive","purple","red","teal","yellow"]
let ply: seq[string] = sgf.split(  ";"  )
var art: seq[string] = @[]
var endFile:string = "</g></g></svg>"

for i in countup(2, ply.len-1):
# unicode alignment
  var turns: seq[string] = ply[i].split( { '[' , ']' }  )
  xOrd.add(ord(turns[1][0])-97)
  yOrd.add(ord(turns[1][1])-97)
  #echo "move ", xOrd[i-2] , "," , yOrd[i-2] , colors[i mod colors.len]
  
var brush: string
for i in countup(0,xOrd.len-1):
  let x = 12 + xOrd[i]*24
  let y = 12 + yOrd[i]*24
  let r = 10 + rand(1)
  brush = "<circle cx=\""
  brush.add($x)
  brush.add("\" cy=\"")
  brush.add($y)
  brush.add("\" r=\"")
  brush.add($r)
  brush.add("\" fill=\"")
  brush.add(colors[i mod colors.len])
  brush.add("\"/>")
  #output.writeline(brush)
  art.add(brush)

for i in countup(0,xOrd.len-1):
  var fName = ".\\art\\t"
  fName.add($(i+1000))
  fName.add(".svg")
  var output = open(fName, fmWrite)
  for ss in startSeq:
    output.writeLine(ss)
  for aa in countup(0,i):
    output.writeLine(art[aa])
  output.writeLine(endFile)