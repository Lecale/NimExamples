import os
import strutils
import math

# Return % Processor Time
proc getAvgs( csvFile: string, pName: string, interval: int) : int =
    var cpPosn :seq[int] = @[]
    var cpu: seq[float] = @[] #hold cpu per second
    var cpuMvAvg: seq[float] = @[] #moving avg
    var ln1 :bool = true
    var totCp: float = 0 #misleading name alert
    var localCount: float = 0
    var std: float = 0
    for ln in lines csvFile:
        if(ln1):
            let lnf = ln.replace("\"","")
            let hdrs = lnf.split({','})
            ln1 = false
            for i in 1 .. hdrs.len-1:
                if(hdrs[i].contains(pName)):
                    if(hdrs[i].contains("% Processor Time")):
                        if(hdrs[i].contains("_Total")==false):
                            cpPosn.add(i)
        else:
        # Process the running averages and put in summary csv
            localCount = localCount + 1
            var cpAvg: float64 = 0
            var cpLcAvg: float64 = 0
            let lnf = ln.replace("\"","")
            let guts = lnf.split({','})
            for cp in cpPosn:
                try:
                    cpAvg = cpAvg + parseFloat(guts[cp])
                    cpLcAvg = cpLcAvg + parseFloat(guts[cp])
                except: discard    
            totCp = totCp + cpAvg
            cpu.add(cpLcAvg)

    totCp = totCp / localCount # this is the average
    echo "Average(" & csvFile & ") cpu: " & $totCp.formatFloat(ffDecimal, 2)
    
    # now construct moving averages
    # and a standard deviation
    for z in 0 .. cpu.len - 1:
        var mvc: float = 0
        var mv: float = 0
        for y in z-interval .. z+interval:
            try:
                mv = mv + cpu[y]
                mvc = mvc + 1
            except: discard
        if mvc != 0:
            cpuMvAvg.add(mv/mvc)
        else:
            cpuMvAvg.add(0)
        #std = std + ((cpu[z]-totCp)*(cpu[z]-totCp))
        std = std + ((cpuMvAvg[z]-totCp)*(cpuMvAvg[z]-totCp))

    std = std / localCount
    std = sqrt(std)
    echo "StDev(" & csvFile & ") cpu: " & $std.formatFloat(ffDecimal, 2)

    # now when is the last moving average ABOVE the averge
    var HOLD:int = -1
    for z in 0 .. cpuMvAvg.len - 1:
        if cpuMvAvg[z] > totCp:
            HOLD = z
    echo "Last moving average " , $HOLD 
    # must refine this by finding last point within moving average
    var HOLD2: int = HOLD
    for z in HOLD .. HOLD + interval:
        echo $z ," ", $cpu[z] , " ",$totCp
        if cpu[z] > totCp:
            HOLD2 = z
    echo "Last average " , $HOLD2 

    return HOLD2 + 1

discard getAvgs("cpuTrace3.csv","c",3)
discard getAvgs("cpuTrace3.csv","c",4)
