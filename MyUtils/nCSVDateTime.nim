import os, strutils, streams, parsecsv, times
# correct output of nData.nim

var Delim = ';'
proc main() =
  if paramCount() < 2:
    quit("synopsis: " & getAppFilename() & " filename , outfile")

  let
    filename = paramStr(1)
    outfile = paramStr(2)
    file = newFileStream(filename, fmRead)
  
  var stringOne: string
  var transform: string
  var output = open(outfile, fmWrite)
  var csv: CsvParser
  
  open(csv, file, filename, separator=Delim)
  csv.readHeaderRow()
  
  while csv.readRow():
    transform = ""
    for col in items(csv.headers):
      stringOne = csv.rowEntry(col)
      if(stringOne.contains("nanoseconds")):
        stringOne = stringOne.replace("(seconds: ","")
        stringOne = stringOne.replace(", nanosecond: 0)","")
        transform.add($fromUnix(parseInt(stringOne)).utc)
        transform.add(",")
      else:
        transform.add(stringOne)
        transform.add(",")
    output.writeLine(transform)
  
main()