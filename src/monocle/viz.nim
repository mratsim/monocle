# Copyright 2018 Mamy André-Ratsimbazafy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import webview
import os, strformat, strutils, json

const # TODO use staticRead, but webview on Mac doesn't display anything with staticRead
  currDir    = "file://" & currentSourcePath.rsplit(DirSep, 1)[0] & "/vega"
  vega       = currDir & "/vega.js"       # staticRead"vega/vega@4.js"
  vega_lite  = currDir & "/vega-lite.js"  # staticRead"vega/vega-lite@2.js"
  vega_embed = currDir & "/vega-embed.js" # staticRead"vega/vega-embed@3.js"

const indexHTML = &"""
<!doctype html>
<html>
  <head>
    <script src="{vega}" charset="UTF-8"></script>
    <script src="{vega_lite}" charset="UTF-8"></script>
    <script src="{vega_embed}" charset="UTF-8"></script>
  </head>
  <body>
    <div id="vis"></div>
    <script type="text/javascript">
      vegaEmbed('#vis', $1).then(function(result) {{}}).catch(console.error);
    </script>
  </body>
</html>
"""

proc show*(data: JsonNode) =
  # TODO: embed the template and don't require a temp file
  let fn="$1/monocle.html"%[getTempDir()]
  let content = indexHtml % [$data]
  writeFile(fn, content)
  defer: removeFile(fn)

  var w = newWebView("Simple window demo2", "file://" & fn)
  w.run()
  w.exit()

when isMainModule:

  import httpclient

  let data = getContent("https://raw.githubusercontent.com/vega/vega/master/docs/examples/bar-chart.vg.json")
    .parseJson
  show(data)
