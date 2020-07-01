import os
import osproc
import strutils

echo "nimMgr"
var pNom: string = "chrome.exe"
let posnM: int = 4
let posnC: int = 8
try:
  pNom = paramStr(1)
except:
  echo "nimMgr [processName]"
var t:string = "tasklist /FI \"IMAGENAME eq " & pNom & "\" /NH /v"
# with /v we can add extra params like CPUTIME and window title 
var o = execProcess(t).splitLines()
var mem: int = 0
var timeUnit: int = 0
for ol in o:
#  echo ol
  var p = split(ol)
  var pi:seq[string] = @[]
  # clean data
  for pl in p:
    let fudge:string = (string) pl.replace(",","")
    if(fudge.isNilOrWhitespace == false):
      pi.add(fudge)
  # easy to add the Kb
  try:
    mem = mem + parseInt(pi[posnM])
  except:
    mem = mem + 0
  # CPUTIME is in hours:minutes:seconds
  try:
    var tu = split(pi[posnC],":")
    timeUnit = timeUnit + parseInt(tu[2])
    timeUnit = timeUnit + 60 * parseInt(tu[1])
    timeUnit = timeUnit + 3600 * parseInt(tu[0])
  except:
    echo "handled exception"
echo "Memory for process is " , mem/1024 , "Mb" 
echo "Time Units for process is " , timeUnit 

# discard execShellCmd("ls -la")
