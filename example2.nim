import registry, osproc

echo countProcessors()
#  HKLM\Software\Microsoft\Windows NT\CurrentVersion
var handle = registry.HKEY_LOCAL_MACHINE
try:
  echo getUnicodeValue("Software\\Microsoft\\Windows NT\\CurrentVersion", "CurrentVersion", handle)
except: discard
