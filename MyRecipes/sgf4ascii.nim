import strutils, os

type aMkUp = object
       colour: string 
       colou2: string
       number: int
       text: string
       xOrd: int
       yOrd: int

let start = readFile("medium.svg") 
let startSeq = start.splitLines()
let abc: string = "abcdefghi"

var markUp: seq[aMkUp] = @[]
var line: seq[string] = @[]
var art: seq[string] = @[]

var whiteFirst: bool = false
var x:int
var y:int

proc main() =
  let fName = paramStr(1)
  var sgf = readfile("ascii.txt")
  let ply: seq[string] = sgf.split("$$")
  if ply[1].contains("W") :
    whiteFirst = true
  for i in countup(2,ply.len-1):
    line = ply[i].split(" ")
    for j in countup(2,line.len-2):
      y = i-3
      x = j-2
      try: 
      #first check for a number
        var move:int = parseInt(line[j])
        if whiteFirst :
          if move mod 2 == 0 :
            markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "blue", number: move , colou2: "aqua"))
          else :
            markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "green", number: move, colou2: "lime"))
        else :  
          if move mod 2 == 0 :
            markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "green", number: move, colou2: "aqua"))
          else :
            markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "blue", number: move, colou2: "lime"))
      
      except:
        if line[j] == "X" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "blue"))
        if line[j] == "O" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "green"))
        # circle B W
        # square # @ 
        # triangle Y Q
        # cross Z P
        if line[j] == "#" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "blue", text: "square", colou2: "aqua"))
        if line[j] == "@" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "green", text: "square", colou2: "lime"))
        if line[j] == "B" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "blue", text: "circle", colou2: "aqua"))
        if line[j] == "W" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "green", text: "circle", colou2: "lime"))
        # S
        # T
        # M
        if line[j] == "S" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "none", text: "smudge"))
        if line[j] == "T" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "none", text: "smudge"))
        if line[j] == "M" :
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "none", text: "smudge"))
        
        # abcdefghijklm
        if abc.contains(line[j]) :
          let qk = line[j] 
          markUp.add(aMkUp(xOrd: x , yOrd: y, colour: "none", text: qk))
  echo "MarkUp count: ", markUp.len
  
  for i in countup(0, markUp.len-1):
    var brush: string
    var xX: int
    var yY: int
    if markUp[i].text.len == 1:
      xX = 10 + 20*markUp[i].xOrd
      yY = 15 + 20*markUp[i].yOrd
      brush = "<text x=\""
      brush.add($xX)
      brush.add("\" y=\"")
      brush.add($yY)
      brush.add("\" style=\"stroke:none; font-family:MS Shell Dlg 2, sans-serif; text-anchor: middle;")
      brush.add("fill: red; font-size: 18px;\">")
      brush.add(markUp[i].text)
      brush.add("</text>")
      art.add(brush)
    else:
      # no background
      if markUp[i].text == "smudge":
        xX = 5 + 20*markUp[i].xOrd
        yY = 5 + 20*markUp[i].yOrd
        brush = "<rect x=\""
        brush.add($xX)
        brush.add("\" y=\"")
        brush.add($yY)
        brush.add("\" width=\"10\" height=\"10\" ry=\"2\" rx=\"2\" fill=\"red\"/>")
        art.add(brush)
      else :  
        xX = 10 + 20*markUp[i].xOrd
        yY = 10 + 20*markUp[i].yOrd
        brush = "<circle cx=\""
        brush.add($xX)
        brush.add("\" cy=\"")
        brush.add($yY)
        brush.add("\" r=\"9\" fill=\"")
        brush.add(markUp[i].colour)
        brush.add("\"/>")
        art.add(brush)  
        if markUp[i].colou2.len > 1:
          if markUp[i].text == "square":
            xX = 6 + 20*markUp[i].xOrd
            yY = 6 + 20*markUp[i].yOrd
            brush = "<rect x=\""
            brush.add($xX)
            brush.add("\" y=\"")
            brush.add($yY)
            brush.add("\" width=\"8\" height=\"8\" ry=\"1\" rx=\"1\" fill=\"")
            brush.add(markUp[i].colou2)
            brush.add("\"/>")
            art.add(brush)
          if markUp[i].text == "circle":
            xX = 10 + 20*markUp[i].xOrd
            yY = 10 + 20*markUp[i].yOrd
            brush = "<circle cx=\""
            brush.add($xX)
            brush.add("\" cy=\"")
            brush.add($yY)
            brush.add("\" r=\"7\" fill=\"none\" stroke-width=\"0.9px\" stroke=\"")
            brush.add(markUp[i].colou2)
            brush.add("\"/>")
            art.add(brush)
          if markUp[i].number > 0:
            xX = 10 + 20*markUp[i].xOrd
            yY = 15 + 20*markUp[i].yOrd
            brush = "<text x=\""
            brush.add($xX)
            brush.add("\" y=\"")
            brush.add($yY)
            brush.add("\" style=\"stroke:none; font-family:MS Shell Dlg 2, sans-serif; text-anchor: middle;")
            brush.add("fill:")
            brush.add(markUp[i].colou2)
            brush.add("; font-size: 16px;\">")
            brush.add($markUp[i].number)
            brush.add("</text>")
            art.add(brush)
      
    var output = open(fName, fmWrite)
    for ss in startSeq:
      output.writeLine(ss)
    for aa in art:
      output.writeLine(aa)
    output.writeLine("</g></g></svg>")
    
  
main()  