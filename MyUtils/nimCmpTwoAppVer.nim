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
  echo "Make sure you have enough Headers in the csv file !"
  echo "nMlAppVer filename appVerField# rwVersion# [By]"
  echo ">> AppName appVerField# rwVersion#"
  if paramCount() < 3:
    quit("synopsis: " & getAppFilename() & " filename appVerField# rwVersion# [By]")

  let
    filename = paramStr(1)
    avIndex = parseInt(paramStr(2))
    rwIndex = parseInt(paramStr(3))
  echo "We need first the New version, then the Old version."
  echo "Please tell the first rwVersion which you want to query?"
  let correctVersion1 = readLine(stdin)
  echo "Please tell the second rwVersion which you want to query?"
  let correctVersion2 = readLine(stdin)
  
  if(paramCount() == 4):
    Delim = '\t'

  var file = newFileStream(filename, fmRead)
  var matches1 = initTable[string, string]()
  var matches2 = initTable[string, string]()
  var rwVer = ""
  var appver:seq[string] = @[]
  
  if file == nil:
    quit("cannot open the file " & filename)
  defer: file.close()

  var csv: CsvParser
  open(csv, file, filename, separator=Delim)
  csv.readHeaderRow()
  while csv.readRow():
    try :
      rwVer = strip(csv.rowEntry(csv.headers[rwIndex]))
      if rwVer == correctVersion1 :
        appver = getAppVersion(csv.rowEntry(csv.headers[avIndex])).split(',')
        if matches1.hasKey(appver[0]) == false :
          matches1.add(appver[0],appver[1]) 
      if rwVer == correctVersion2 :
        appver = getAppVersion(csv.rowEntry(csv.headers[avIndex])).split(',')
        if matches2.hasKey(appver[0]) == false :
          matches2.add(appver[0],appver[1]) 
        
    except : discard
  
  echo "Key counts as follows"
  echo correctVersion1 , "\t" , matches1.len
  echo correctVersion2 , "\t" , matches2.len
  
  echo "Where would you like the output to be written to?"
  let outfile = readLine(stdin)
  var outfileoutfile = open(outfile, fmWrite)
  var tCount = 0
  for k, v in matches2.pairs :
    if matches1.hasKey(k) :
      outfileoutfile.writeLine(k & "\t" & v & "\t" & matches1[k]) 
    else :
      outfileoutfile.writeLine(k & "\t" & v & "\tABSENT"  ) 
      tNew = tNew + 1
  outfileoutfile.writeLine("");
  outfileoutfile.writeLine("Unique Old\t"&matches1.len);
  outfileoutfile.writeLine("Unique New\t"&matches2.len);
  outfileoutfile.writeLine("New app versions\t"&tNew);
main()
