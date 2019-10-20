import os, strutils, streams, tables, parsecsv

# Parse field in csv file and show histograms

var
  Delim = '\t'

proc main() =
  if paramCount() < 3:
    quit("synopsis: " & getAppFilename() & " filename keyField limits")

  let
    filename = paramStr(1)
    keyFieldIndex = parseInt(paramStr(2))
    limits: seq[string] = paramStr(3).split(',')
  echo "limits: ", limits
  
  if(paramCount() == 4):
    Delim = ','

  var
    #binmen: array[limits.len + 1 , int] # catch other
    binmen: seq[int] = @[]
    file = newFileStream(filename, fmRead)

  for l in limits:
    binmen.add(0)
  var blen = binmen.len
  binmen.add(0)
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
    tv = parseFloat(csv.rowEntry(csv.headers[keyFieldIndex]))
    for i in countup(0, limits.len - 1): #binmen 1 longer than limits
      if tv < parseFloat(limits[i]):
        #echo "dbg: ", tv , " lt " , parseFloat(limits[i])
        binmen[i] = binmen[i] + 1   
        binmen[binmen.len-1] = binmen[binmen.len-1] - 1
        break
  
  echo "result: ", binmen
  
main()
