import os, strutils, streams, tables, parsecsv

# Parse field in csv file and show histograms

var
  Delim = '\t'

proc main() =
  if paramCount() < 4:
    quit("synopsis: " & getAppFilename() & " filename keyField limits")

  let
    filename = paramStr(1)
    keyFieldIndex = parseInt(paramStr(2))
    altFieldIndex = parseInt(paramStr(3))
    limits: seq[string] = paramStr(4).split(',')
  echo "limits:  ", limits
  
  if(paramCount() == 5):
    Delim = ','

  var
    binmen: seq[int] = @[]
    cinmen: seq[int] = @[]
    file = newFileStream(filename, fmRead)

  for l in limits:
    binmen.add(0)
    cinmen.add(0)
  var blen = binmen.len
  binmen.add(0)
  cinmen.add(0)
#  echo binmen
  
  if file == nil:
    quit("cannot open the file " & filename)
  defer: file.close()

  var tv: float = 0
  var csv: CsvParser
  open(csv, file, filename, separator=Delim)
  csv.readHeaderRow()
  while csv.readRow():
    binmen[blen] = binmen[blen] + 1
    cinmen[blen] = cinmen[blen] + 1
    tv = parseFloat(csv.rowEntry(csv.headers[keyFieldIndex]))
    for i in countup(0, limits.len - 1): #binmen 1 longer than limits
      if tv < parseFloat(limits[i]):
        binmen[i] = binmen[i] + 1   
        binmen[binmen.len-1] = binmen[binmen.len-1] - 1
        break
    tv = parseFloat(csv.rowEntry(csv.headers[altFieldIndex]))
    for i in countup(0, limits.len - 1): #binmen 1 longer than limits
      if tv < parseFloat(limits[i]):
        cinmen[i] = cinmen[i] + 1   
        cinmen[cinmen.len-1] = cinmen[cinmen.len-1] - 1
        break
  
  echo "result: ", binmen
  echo "result: ", cinmen
  
main()
