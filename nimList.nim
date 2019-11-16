import os

var nstart:string = paramStr(1)
var nmatch:string = paramStr(2)

nstart.add("\\*.")
nstart.add(nmatch)

for file in walkFiles nstart:
  echo file
