import winim
import flippy

proc getScreenWidth*(): cint {.cdecl, exportc, dynlib.} =
  ## Screen Width as cint.
  result = GetSystemMetrics(78)
  
proc getScreenHeight*(): cint {.cdecl, exportc, dynlib.} =
  ## Screen Height as cint.
  result = GetSystemMetrics(79)
  
proc reduceImage*(inFile, outFile: string, scale: cint): cint {.cdecl, exportc, dynlib.} =
  ## reduces image
  var image = loadImage(inFile)
  image = image.minify(scale)
  image.save(outFile)
  result = scale
  
  #$ nim c -d:release --header --noMain --app:lib adder.nim