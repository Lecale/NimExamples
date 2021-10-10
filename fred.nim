import os,osproc
import strutils
import threadpool

# threaded start logman & start process

proc prepLogman(cfFile: string, oFile: string) =
  try:
    discard startProcess("logman", args=["delete","BASE"])
  except: discard
  try:
    removeFile(oFile & ".blg")
  except: discard
  discard startProcess("logman",args=["create","counter","BASE","-f","bin","-a","--v","-si","1","-o" ,oFile,"-cf",cfFile])
  echo "created"

proc startLogman() {.thread.} =
  discard startProcess("logman",args=["start","BASE"] )
echo "started"
proc stopLogman() =
  discard startProcess("logman",args=["stop","BASE"] )

#working dir , args, pipes, etc
proc startExe(cmd: string) {.thread.} =
  discard startProcess(cmd)

prepLogman("Basic.config", "example1")
sleep(5000)
echo "start logman"
spawn startLogman()
echo "start proc"
spawn startExe("notepad.exe")
sleep(10000)
stopLogman()
