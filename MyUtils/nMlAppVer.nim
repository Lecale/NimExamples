import os, strutils, streams, tables, parsecsv

# Parse field in csv file and show histograms

var
  Delim = ','

proc getAppVersion (a: var string) : string =
  a = strip(a)
  if a.contains("/cms/") :
    return "PageExpress,?"
  if a.contains("lipper.cp.") :
    return "lipper,?"
  if a.contains("ifrmarkets.cp.") :
    return "ifrmarkets,?"
  if a.contains("/Explorer/") :
    if a.contains(".aspx") :
      return "MaelstromView,?"
  a = a.replace("app/app.html","") #strange calc cases
  let b = a.split('/')
  var c = b[b.len-3]
  c.add(",")
  c.add(b[b.len-2])
  #echo c
  return c

  
proc main() =
  echo "nMlAppVer filename appVerField# rwVersion# [By]"
  echo ">> AppName appVerField# rwVersion#"
  if paramCount() < 3:
    quit("synopsis: " & getAppFilename() & " filename appVerField# rwVersion# [By]")

  let
    filename = paramStr(1)
    avIndex = parseInt(paramStr(2))
    rwIndex = parseInt(paramStr(3))
  echo "Which rwVersion do you want to query?"
  let correctVersion = readLine(stdin)
  
  if(paramCount() == 4):
    Delim = '\t'

  var file = newFileStream(filename, fmRead)
  var matches = initTable[string, string]()
  var rwVer = ""
  
  if file == nil:
    quit("cannot open the file " & filename)
  defer: file.close()

  var csv: CsvParser
  open(csv, file, filename, separator=Delim)
  csv.readHeaderRow()
  while csv.readRow():
    try :
      rwVer = strip(csv.rowEntry(csv.headers[rwIndex]))
      if rwVer == correctVersion :
        let appver = getAppVersion(csv.rowEntry(csv.headers[avIndex])).split(',')
        if matches.hasKey(appver[0]) == false :
          matches.add(appver[0],appver[1]) 
        #else :
        # echo appver
      
    except : discard
  
  echo "Where would you like the output to be written to?"
  let outfile = readLine(stdin)
  var outfileoutfile = open(outfile, fmWrite)
  for k, v in matches.pairs :
    outfileoutfile.writeLine(k & "\t" & v) 
  
main()
