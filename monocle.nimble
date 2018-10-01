# Package

version       = "0.0.1"
author        = "Mamy André-Ratsimbazafy"
description   = "A data visualization library"
license       = "Apache-2.0"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.0", "https://github.com/mratsim/Arraymancer#master", "webview"

##########################################################################
## Testing tasks

proc test(name: string, lang: string = "c") =
  if not dirExists "build":
    mkDir "build"
  if not dirExists "nimcache":
    mkDir "nimcache"
  --run
  switch("out", ("./build/" & name))
  setCommand lang, "tests/" & name & ".nim"
