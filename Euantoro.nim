proc addTwoInts*(a, b: cint): cint {.cdecl, exportc, dynlib.} =
  ## addTwoInts adds two integers together.
  result = a + b
  
  #$ nim c -d:release --header --noMain --app:lib adder.nim