import winim, pixie
import winim/inc/windef
import times

proc takeScreenshot*: Image=
  # get size of the main screen
  var screenRect: windef.Rect
#  GetClientRect GetDesktopWindow(), addr screenRect
#  GetClientRect GetForegroundWindow(), addr screenRect
  GetWindowRect GetForegroundWindow(), addr screenRect
  let
    x = screenRect.left
    y = screenRect.top
    w = (screenRect.right - screenRect.left)
    h = (screenRect.bottom - screenRect.top)
    mx = (int32)(screenRect.left/2)
    my = (int32)(screenRect.top/2)
    mw = (int32)((screenRect.right - screenRect.left)/2)
    mh = (int32)((screenRect.bottom - screenRect.top)/2)

  # create an image
  var image = newImage(mw, mh)

  # copy screen data to bitmap
  var
    hScreen = GetDC(cast[HWND](nil))
    hDC = CreateCompatibleDC(hScreen)
    hBitmap = CreateCompatibleBitmap(hScreen, int32 w, int32 h)


  discard SelectObject(hDC, hBitmap)
  #discard BitBlt(hDC, x, y, int32 w, int32 h, hScreen, int32 x, int32 y, SRCCOPY)
  #discard BitBlt(hDC, 0, 0, int32 w, int32 h, hScreen, int32 x, int32 y, SRCCOPY) #This is correct for a straight copy

#https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-stretchblt
  discard StretchBlt(hDC,0,0,mw,mh, hScreen, int32 x, int32 y, int32 w, int32 h,SRCCOPY)

  # setup bmi structure,
  var mybmi: BITMAPINFO
  mybmi.bmiHeader.biSize = int32 sizeof(mybmi)
#  mybmi.bmiHeader.biWidth = w
#  mybmi.bmiHeader.biHeight = h
  mybmi.bmiHeader.biWidth = mw
  mybmi.bmiHeader.biHeight = mh
  mybmi.bmiHeader.biPlanes = 1
  mybmi.bmiHeader.biBitCount = 32
  mybmi.bmiHeader.biCompression = BI_RGB
#  mybmi.bmiHeader.biSizeImage = w * h * 4
  mybmi.bmiHeader.biSizeImage = w * h

  # copy data from bmi structure to the flippy image
  discard CreateDIBSection(hdc, addr mybmi, DIB_RGB_COLORS, cast[ptr pointer](unsafeAddr image.data[0]), 0, 0)
#  discard GetDIBits(hdc, hBitmap, 0, h, cast[ptr pointer](unsafeAddr image.data[0]), addr mybmi, DIB_RGB_COLORS)
  discard GetDIBits(hdc, hBitmap, 0, mh, cast[ptr pointer](unsafeAddr image.data[0]), addr mybmi, DIB_RGB_COLORS)

  # for some reason windows bitmaps are flipped? flip it back
  # image.flipVertical()

  # for some reason windows uses BGR, convert it to RGB
  # for i in 0 ..< image.height * image.width:
  #   swap image.data[i].r, image.data[i].b

  # delete data [they are not needed anymore]
  DeleteObject hdc
  DeleteObject hBitmap

  # image.writeFile "screenshot.png"
  image

let a = cputime()
var i = takeScreenshot()
let c = cputime()
i.writeFile "screenshot.png"
let b = cputime()
echo c - a
echo b - a

#how quickly can we take these?

