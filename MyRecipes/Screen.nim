import strutils, os, times
import winim
import nimPNG

# Simple benchmarking
let time = cpuTime()
sleep(100) # Replace this with something to be timed
echo "Time taken: ", cpuTime() - time

let width = GetSystemMetrics(78)
let height = GetSystemMetrics(79)
echo width , height
let hDesktopWnd = GetDesktopWindow()
let hDesktopDC = GetDC(hDesktopWnd)
let hCaptureDC = CreateCompatibleDC(hDesktopDC)
let hCaptureBitmap = CreateCompatibleBitmap(hDesktopDC, width, height)

savePNG32("output.png", hCaptureBitmap, width, height)