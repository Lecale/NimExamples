import stb_image/read as stbi
import math

# https://en.wikipedia.org/wiki/Bhattacharyya_distance
proc obc*(image1, image2: string) =
  type IntArray = array[24,int]
  var
    r24: IntArray
    g24: IntArray
    b24: IntArray
    rr24: IntArray
    gg24: IntArray
    bb24: IntArray
  let f:float = 24/256
  var
    w, h , c:int
    data1: seq[uint8]
    data2: seq[uint8]
  data1 = stbi.load(image1,w,h,c,stbi.Default) #uint8
  data2 = stbi.load(image1,w,h,c,stbi.Default)
  var tCnt:int = 0
  for i in countUp(0, data1.len - 3, step = stbi.RGB):
    let
      r1: float = (float)data1[i]
      g1: float = (float)data1[i + 1]
      b1: float = (float)data1[i + 2]
      r2: float = (float)data2[i]
      g2: float = (float)data2[i + 1]
      b2: float = (float)data2[i + 2]
    # fill the bins
    r24[ (int)(r1*f) ] = r24[(int)((float)r1*f)] + 1
    g24[ (int)(g1*f) ] = r24[(int)((float)g1*f)] + 1
    b24[ (int)(b1*f) ] = r24[(int)((float)b1*f)] + 1
    rr24[ (int)(r2*f) ] = r24[(int)((float)r2*f)] + 1
    gg24[ (int)(g2*f) ] = r24[(int)((float)g2*f)] + 1
    bb24[ (int)(b2*f) ] = r24[(int)((float)b2*f)] + 1
    tCnt = tCnt + 1 

  var rSum:float =0
  var gSum:float =0
  var bSum:float =0
  for bc in 0 .. 23:
    #for bb in 0 .. 23:
    rSum = rSum + sqrt((float)(r24[bc] * rr24[bc]))
    gSum = gSum + sqrt((float)(g24[bc] * gg24[bc]))
    bSum = bSum + sqrt((float)(b24[bc] * bb24[bc]))
  rSum = rSum/(float)tCnt
  gSum = gSum/(float)tCnt
  bSum = bSum/(float)tCnt

  echo rSum
  echo gSum
  echo bSum

obc("screenshot.png","screenshot.png")