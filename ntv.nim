import os
import osproc
import strutils
import threadpool

#
# This program makes use of this utility
# https://www.nirsoft.net/utils/network_traffic_view.html
# The exe file needs to be run in Admin mode
#

proc taskList(a: string, b: int): int =
  let posnM: int = 4
  let posnC: int = 8
  var t:string = "tasklist /FI \"IMAGENAME eq " & a & "\" /NH /v"
  var o = execProcess(t).splitLines()
  var mem: int = 0
  var timeUnit: int = 0

  for ol in o:
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
      discard

  let a:string = "" & $(mem/1024) & "\t" & $timeUnit & "\t#" & $b
  let f = open("rc.txt", fmAppend)
  defer: f.close()
  f.writeLine(a)

############################################################

proc bw(win: int): int =
  let ntv: string = "NetworkTrafficView.exe /shtml \"record.html\" /sort \"Data Speed\" /CaptureTime " & $win
# nirsoft's exe file should have a config change to group by process name
  discard execProcess(ntv)
  return 0
############################################################


echo "nim resource consumption utility"
var pNom: string = "chrome.exe"
var bwWindow: int = 60
let nap:int = (int)(100 * bwWindow)
try:
  pNom = paramStr(1)
except:
  echo "nimMgr [processName] [window_size]"
try:
  bwWindow = parseInt(paramStr(2))
except:
  echo "nimMgr [processName] [window_size]"

var f1 = spawn bw(bwWindow)
var cnt:int = 0
while not f1.isReady:
  discard spawn taskList(pNom,cnt)
  cnt = cnt + 1
  sleep(nap)
