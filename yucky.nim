import sequtils, tables, strutils, strformat, os

let NEXT_PLAYER = {"X":"O", "O":"X"}.toTable
let BdSz = 7

type
  IntArray = array[0..48, int] 

var
  bd: IntArray
  dark: IntArray
  light: IntArray
  black: seq[int] = @[]
  white: seq[int] = @[]

black.add(31)
white.add(13)

proc showBd(tbd: IntArray, BdSize: int): int =
  var
    outString: string
  for i in 0 .. BdSize - 1:
    outString = ""
    for j in 0 .. BdSize - 1:
      outString.add(tbd[i * BdSize + j])
      outString.add(",")
    echo outString   
  return 1

proc colorBd(board: var IntArray, b, w: seq[int]): void =
  for i, j in b:
    # i is the ordinal and j is the value
    board[j] = 9
  for i, j in w:
    board[j] = 1


proc shadeBd(board, bdShade : var IntArray; clr: seq[int] ): void =
  for i, j in board:
    bdShade[j] = 1

let top = BdSz * BdSz
colorBd(bd, black, white)
let a = showBd(bd, BdSz)

#pass 1 set light and dark to equal 1 if a stone parsent
#pass 2 colour surounding stones if ==0
# if overlap -1
#pass 3 colour surrounding 2s if ==0
# if overlap -1