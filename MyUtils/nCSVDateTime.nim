import os, strutils, streams, tables, parsecsv, times
# correct output of nData.nim

var Delim = ';'
var unix: int

#var testData:string = "(seconds: 1560336389, nanosecond: 0)" #they seem to always be 0
#testData = testData.replace("(" , "")
#testData = testData.replace(")" , "")
#testData = testData.replace(" " , "")
#testData = testData.replace("nanoseconds:" , "")
#testData = testData.replace("seconds:" , "")
#echo testData
#let td = testData.split(',')
#echo $fromUnix(1560336389).utc
#echo $fromUnix(parseInt(td[0])).utc

proc main() =
  if paramCount() < 4:
    quit("synopsis: " & getAppFilename() & " filename , outfile")

  let
    filename = paramStr(1)
    outfile = paramStr(2)
    file = newFileStream(filename, fmRead)
  
  var stringOne: string
  var transform: string
  var csv: CsvParser
  
  open(csv, file, filename, separator=Delim)
  csv.readHeaderRow()
  
  while csv.readRow():
    transform = ""
    for col in items(csv.headers):
      stringOne = csv.rowEntry(col)
      if(stringOne.contains("nanoseconds")):
        stringOne.replace("(seconds: ","")
        stringOne.replace(", nanosecond: 0)","")
        transform.add($fromUnix(parseInt(stringOne).utc)
        transform.add(",")
      transform.add(stringOne)
      transform.add(",")
  
main()