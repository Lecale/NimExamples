import winim, pixie
import winim/inc/windef

proc vrx*: float =

  let x1 = (float) GetSystemMetrics(SM_CXSCREEN)
  let x2 = (float) GetSystemMetrics(SM_CXVIRTUALSCREEN)
  return x2 / x1

proc vry*: float =

  let x1 = (float) GetSystemMetrics(SM_CYSCREEN)
  let x2 = (float) GetSystemMetrics(SM_CYVIRTUALSCREEN)
  return x2 / x1
 
proc takeScreenshot*(tCompress:float , win: HWND ): Image=
  # get size of the main screen
  var screenRect: windef.Rect
  GetWindowRect win, addr screenRect
  var
    x =  (float)screenRect.left
    y = (float)screenRect.top
    w = (float)(screenRect.right - screenRect.left)
    h = (float)(screenRect.bottom - screenRect.top)
  x = x * vrx()
  y = y * vry()
  w = w * vrx()
  h = h * vry()
  let
    mw = w/tCompress
    mh = h/tCompress
  echo "xy " , x , "," , y
  # create an image
  var image = newImage(int32 mw, int32 mh)

  # copy screen data to bitmap
  var
    hScreen = GetDC(cast[HWND](nil))
    hDC = CreateCompatibleDC(hScreen)
    hBitmap = CreateCompatibleBitmap(hScreen, int32 w, int32 h)

  discard SelectObject(hDC, hBitmap)
  discard StretchBlt(hDC,0,0,int32 mw, int32  mh, hScreen, int32 x, int32 y, int32 w, int32 h,SRCCOPY)

  # setup bmi structure,
  var mybmi: BITMAPINFO
  mybmi.bmiHeader.biSize = int32 sizeof(mybmi)
  mybmi.bmiHeader.biWidth = int32 mw
  mybmi.bmiHeader.biHeight = int32 mh
  mybmi.bmiHeader.biPlanes = 1
  mybmi.bmiHeader.biBitCount = 32
  mybmi.bmiHeader.biCompression = BI_RGB
  mybmi.bmiHeader.biSizeImage = (int32)(w * h * 4 / (tCompress * tCompress))

  # copy data from bmi structure to the flippy image
  discard CreateDIBSection(hdc, addr mybmi, DIB_RGB_COLORS, cast[ptr pointer](unsafeAddr image.data[0]), 0, 0)
  discard GetDIBits(hdc, hBitmap, 0, int32 mh, cast[ptr pointer](unsafeAddr image.data[0]), addr mybmi, DIB_RGB_COLORS) #this might be h, not mh
  # h = number of scan lines to retrieve

  # delete data [they are not needed anymore]
  DeleteObject hdc
  DeleteObject hBitmap

  image