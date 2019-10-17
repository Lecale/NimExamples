import nimsvg, ospaths, random, strutils

buildSvgFile("examples" / sourceBaseName() & ".svg"):
  var sgf = readfile("a.sgf")
  const abc: string = "abcdefghijklmnopqrs"
  var xOrd: seq[int] = @[]
  var yOrd: seq[int] = @[]
  const colors =  ["aqua","blue","fuschia","green","lime","maroon","navy","olive","purple","red","teal","yellow"]
  let ply: seq[string] = sgf.split(  ";"  )

  for i in countup(2, ply.len-1):
    var turns: seq[string] = ply[i].split( { '[' , ']' }  )
    xOrd.add(ord(turns[1][0])-97)
    yOrd.add(ord(turns[1][1])-97)
    echo "move ", x , "," , y , colors[i mod colors.len]  
  
  let size = 800
  svg(width=size, height=size, xmlns="http://www.w3.org/2000/svg", version="1.1"):
    for ii in countup(2, ply.len-1):
      #let x = 12 + (xOrd[ii-2]*20)
      #let y = 12 + (yOrd[ii-2]*20
      let x = random(size)
      let y = random(size)
      let radius = 8 + random(2)
      let colorz = colors[ii mod colors.len] 
      circle(cx=x, cy=y, r=radius, stroke="#111122", fill="#DDD", `fill-opacity`=0.5)
      
# magick -delay 80 *.svg animated.gif