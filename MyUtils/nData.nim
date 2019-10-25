import strutils
import streams
import nimdata
import nimdata/utils
import os

proc main() =

  if paramCount() < 5:
    quit("synopsis: " & getAppFilename() & " filename old new outname filtername")

  const schema = [
    strCol("uid"),
    floatCol("result"),
    strCol("appVer"),
    #dateCol("date", format="dd/MM/yyyy hh:mm:ss "),
    strCol("date"),
    strCol("host"),
    strCol("rwVer")
  ]
  let fName = paramStr(1)
  let filterO = paramStr(2)
  let filterN = paramStr(3)
  let outname = paramStr(4)
  let filtername = paramStr(5)
    
  let df = DF.fromFile(fName)
             .map(schemaParser(schema, ','))
             .map(record => record.projectAway(host))
             .cache()

  let coldDF =   df.filter(record =>
      record.uid.startsWith("CACHE")
    )
  
  coldDF.histPlot(result)
    .title("Distribution of Cold Results")
    .show()
  
  echo "Cache count: ",coldDF.count()
  
  let coldOld =   df.filter(record => record.uid.startsWith("CACHE"))
      .filter(record => record.rwVer.startsWith(filterO)
    )
  echo "filter old:" , coldOld.count() 
  let coldNew =   df.filter(record => record.uid.startsWith("CACHE"))
      .filter(record => record.rwVer.startsWith(filterN)
    )
  echo "filter new:" , coldNew.count()
  
  let matches = joinTheta(
    coldOld,
    coldNew,
    (a, b) => a.uid == b.uid,
    (a, b) => mergeTuple(a, b, ["uid"])
  )
  
  matches.take(5).show()
#  var fs = newFileStream(outname, fmWrite)
#  matches.show(fs)
  matches.toCSV(outname)
  
  let seven = coldOld
    .map(record => record.result)
    .collect()
  #echo seven
  let eight = coldNew
    .map(record => record.result)
    .collect()
  #echo eight

  var both:seq[string] = @[]
  var tmp: string
  if(eight.len > seven.len):
    for i in countup(0,seven.len-1):
      tmp = $seven[i]
      tmp.add(",")
      tmp.add($eight[i])
      both.add(tmp)
    for i in countup(seven.len, eight.len-1):
      tmp = "0"
      tmp.add(",")
      tmp.add($eight[i])
      both.add(tmp)
  else:
    for i in countup(0,eight.len-1):
      tmp = $seven[i]
      tmp.add(",")
      tmp.add($eight[i])
      both.add(tmp)
    for i in countup(eight.len, seven.len-1):
      tmp = $seven[i]
      tmp.add(",")
      tmp.add("0")
      both.add(tmp)
  
  var filterOutput = open(filtername, fmWrite)
  filterOutput.writeLine(filterO & "," & filterN)
  for bb in both:
    filterOutput.writeLine(bb)
  
  #const schema2 = [
  #  floatCol("Seven"),
  #  floatCol("Eight")
  #]
  
  #let sevenEight = DF.fromSeq(both)
  #  .map(schemaParser(schema2, ','))
  #echo "sevenEight:",sevenEight.count()
  
main()  