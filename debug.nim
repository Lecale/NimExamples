import wAuto
import os
import Active
import pixie

for p in processes("chrome.exe"):
  for w in windows(p):
    if isVisible(w):
      show(w)
      sleep(500)
      focus(w)
      sleep(500)
      echo getTitle(w) , " size " , getSize(w) , " parent " , getRect(w)
      var i = takescreenshot(1,getHandle(w))
      i.writeFile("img\\" & getTitle(w) & ".png")
      i = takescreenshot(2.5,getHandle(w))
      i.writeFile("img\\baby_" & getTitle(w) & ".png")
