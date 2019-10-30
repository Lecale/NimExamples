import os, parsecsv, strutils, streams, tables

type
  nHack* = object
    name*: string
    cCounter*: int
    wCounter*: int
    cold*: float
    warm*: float

proc addWarm*(a: var nHack, w: float) =
  a.wCounter = a.wCounter+1
  a.warm = a.warm+w
  
proc addCold*(a: var nHack, w: float) =
  a.cCounter = a.cCounter+1
  a.cold = a.cold+w
    
proc coldAvg*(a: var nHack): float =
  if a.cCounter == 0:
    result = 0
  else:
    result = a.cold / (float)a.cCounter
        
proc warmAvg*(a: var nHack): float =
  if a.wCounter == 0:
    result = 0
  else:
    result = a.warm / (float)a.wCounter
                
var Delim = ','

if paramCount() < 2:
  quit("usage: " & getAppFilename() & " filename , outfile")

let
  filename = paramStr(1)
  outfile = paramStr(2)
  file = newFileStream(filename, fmRead)

var Scrub = "Apps.Open.Wealth."
var sRisk: string
var sSafe: string
var csv: CsvParser  
var tests: seq[nHack] = @[]
var lookup = initTable[string, int]()
var nh: nHack
  
open(csv, file, filename, separator=Delim)
  # we may have to add one
csv.readHeaderRow()
  
while csv.readRow():
  for col in items(csv.headers):
    sRisk = csv.rowEntry(csv.headers[0]).replace(Scrub,"")
    sSafe = sRisk.replace("CACHE","")
    if lookup.hasKeyOrPut(sSafe, tests.len) :
      # table already contains entry
      if sRisk == sSafe :
         addWarm( tests[lookup[sSafe]] , parseFloat(csv.rowEntry(csv.headers[1])) )
      else :
         addWarm( tests[lookup[sSafe]] , parseFloat(csv.rowEntry(csv.headers[1])) )
    else:
      nh = nHack(name: sSafe)
      if sRisk == sSafe :
        addWarm( nh , parseFloat(csv.rowEntry(csv.headers[1])) )
      else :
        addCold( nh , parseFloat(csv.rowEntry(csv.headers[1])) )
      tests.add(nh)

var output = open(outfile, fmWrite)

for toast in tests :
  nh = toast
  sRisk = nh.name
  sRisk.add(",")
  sRisk.add($coldAvg(nh))
  sRisk.add(",")
  sRisk.add($warmAvg(nh))
  sRisk.add(",")
  sRisk.add($nh.cCounter)
  sRisk.add(",")
  sRisk.add($nh.wCounter)
  sRisk.add(",")
  output.writeLine(sRisk)