import os
import osproc
import strutils

#
# This program makes use of this utility
# https://www.nirsoft.net/utils/network_traffic_view.html
#

echo "nimMgr"
var pNom: string = "chrome.exe"
var bwWindow: int = 60
let posnM: int = 4
let posnC: int = 8
try:
  pNom = paramStr(1)
except:
  echo "nimMgr [processName] [window_size]"
try:
  bwWindow = parseInt(paramStr(2))
except:
  echo "nimMgr [processName] [window_size]"
  
var t:string = "tasklist /FI \"IMAGENAME eq " & pNom & "\" /NH /v"
# with /v we can add extra params like CPUTIME and window title 
var ntv: string = "NetworkTrafficView.exe /shtml \"record.html\" /sort \"Data Speed\" /CaptureTime " & $bwWindow
#   "
discard execProcess(ntv)
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
echo "Memory for process group:\t" , mem/1024 , "\tMb" 
echo "Time Units for process group:\t" , timeUnit 

# discard execShellCmd("ls -la")