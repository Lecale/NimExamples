import strutils, os

type aMkUp = object
       colour: string 
       colou2: string
       number: int
       text: string
       xOrd: int
       yOrd: int

let abc: string = "abcdefghijklm"
let xyz: seq[string] = @["e","d","c","b","a"]
var markUp: seq[aMkUp] = @[]
var line: seq[string] = @[]
var art: seq[string] = @[]
var whiteFirst: bool = false

proc aCircle*(a: var aMkUp, b: bool): string =
  let xX:int = 10 + 20*a.xOrd
  let yY:int = 10 + 20*a.yOrd
  var ac = "<circle cx=\""
  ac.add($xX)
  ac.add("\" cy=\"")
  ac.add($yY)
  if b:
    ac.add("\" r=\"9\" fill=\"")
    ac.add(a.colour)
  else:
    ac.add("\" r=\"7\" fill=\"none\" stroke-width=\"0.9px\" stroke=\"")
    ac.add(a.colou2)
  ac.add("\"/>")
  return ac

# Handle text strings
proc aText*(a: var aMkUp, b: bool): string =
  let xX:int = 10 + 20*a.xOrd
  let yY:int = 15 + 20*a.yOrd
  var ac = "<text x=\""
  ac.add($xX)
  ac.add("\" y=\"")
  ac.add($yY)
  ac.add("\" style=\"stroke:none; font-family:MS Shell Dlg 2, sans-serif; text-anchor: middle; ")
  if b:
    ac.add("fill:")
    ac.add(a.colou2)
    ac.add("; font-size: 16px;\">")
    if a.number > 0 :
      ac.add($a.number)
    else :
      ac.add(xyz[xyz.len + a.number])
  else:
    ac.add("fill: red; font-size: 18px;\">")
    ac.add(a.text)
  ac.add("</text>")
  return ac
  
# ascii4svg outputSVG inputAscii inputSVG 
proc main() =
  let fName = paramStr(1)
  var sgf = readfile(paramStr(2))
  let start = readFile(paramStr(3))

  let startSeq = start.splitLines()
  let ply: seq[string] = sgf.split("$$")
  if ply[1].contains("W") :
    whiteFirst = true
  for i in countup(2,ply.len-1):
    line = ply[i].split(" ")
    for j in countup(2,line.len-2):
      try: 
      #first check for a number
        var move:int = parseInt(line[j]) #can use negative for letters
        if whiteFirst :
          if move mod 2 == 0 :
            markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "blue", number: move , colou2: "aqua"))
          else :
            markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "green", number: move, colou2: "lime"))
        else :  
          if move mod 2 == 0 :
            markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "green", number: move, colou2: "aqua"))
          else :
            markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "blue", number: move, colou2: "lime"))
      
      except:
        if line[j] == "X" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "blue"))
        if line[j] == "O" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "green"))
        # circle B W
        # square # @ 
        # triangle Y Q
        # cross Z P
        if line[j] == "#" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "blue", text: "square", colou2: "aqua"))
        if line[j] == "@" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "green", text: "square", colou2: "lime"))
        if line[j] == "B" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "blue", text: "circle", colou2: "aqua"))
        if line[j] == "W" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "green", text: "circle", colou2: "lime"))
        # S
        # T
        # M
        if line[j] == "S" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "none", text: "smudge"))
        if line[j] == "T" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "none", text: "smudge"))
        if line[j] == "M" :
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "none", text: "smudge"))
        
        # abcdefghijklm
        if abc.contains(line[j]) :
          let qk = line[j] 
          markUp.add(aMkUp(xOrd: j-2 , yOrd: i-3, colour: "none", text: qk))
  echo "MarkUp count: ", markUp.len
  
  for i in countup(0, markUp.len-1):
    var brush: string
    var xX: int
    var yY: int
    if markUp[i].text.len == 1:
      art.add(aText(markUp[i],false))
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
        art.add(aCircle(markUp[i],true))
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
            art.add(aCircle(markUp[i],false))
          if markUp[i].number > 0:
             art.add(aText(markUp[i],true))
          if markUp[i].number < 0:
             art.add(aText(markUp[i],true))
      
    var output = open(fName, fmWrite)
    for ss in startSeq:
      output.writeLine(ss)
    for aa in art:
      output.writeLine(aa)      
    output.writeLine("</g></g></svg>")
    output.close()
  
main()  
