# build-blink1

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Fbuild-blink1%2Fmain&style=flat-square)](https://jenkins.sudo.is/job/ben/job/build-blink1/)
[![git](https://git.sudo.is/shieldsio/static/v1?label=git&message=git.sudo.is/ben/build-blink1&logo=gitea&style=flat-square&logoWidth=20&color=darkgreen)](https://git.sudo.is/ben/build-blink1)
[![BSD-3-Clause-No-Military-License](https://git.sudo.is/shieldsio/badge/license-BSD-blue?style=flat-square)](LICENSE)

custom build of [`blink1-tool`](https://github.com/todbot/blink1-tool/) for the [blink(1)](https://blink1.thingm.com/).

## usage

```
$ blink1-tiny-server --help
Usage:
  blink1-tiny-server [options]
where [options] can be:
  --port port, -p port           port to listen on (default 8934)
  --host host, -H host           host to listen on ('127.0.0.1' or '0.0.0.0')
  --no-html                      do not serve static HTML help
  --logging                      log accesses to stdout
  --version                      version of this program
  --help, -h                     this help page

Supported URIs:
  /blink1/ -- simple status page
  /blink1/id -- get blink1 serial number
  /blink1/on -- turn blink(1) full bright white
  /blink1/off -- turn blink(1) dark
  /blink1/red -- turn blink(1) solid red
  /blink1/green -- turn blink(1) solid green
  /blink1/blue -- turn blink(1) solid blue
  /blink1/cyan -- turn blink(1) solid cyan
  /blink1/yellow -- turn blink(1) solid yellow
  /blink1/magenta -- turn blink(1) solid magenta
  /blink1/fadeToRGB -- turn blink(1) specified RGB color by 'rgb' arg
  /blink1/blink -- blink the blink(1) the specified RGB color
  /blink1/pattern/play -- play color pattern specified by 'pattern' arg
  /blink1/random -- turn the blink(1) a random color
  /blink1/servertickle/on -- Enable servertickle, uses 'millis' or 'time' arg
  /blink1/servertickle/off -- Disable servertickle

Supported query arguments: (not all urls support all args)
  'rgb'    -- hex RGB color code. e.g. 'rgb=FF9900' or 'rgb=%23FF9900
  'time'   -- time in seconds. e.g. 'time=0.5'
  'bright' -- brightness, 1-255, 0=full e.g. half-bright 'bright=127'
  'ledn'   -- which LED to set. 0=all/1=top/2=bot, e.g. 'ledn=0'
  'millis' -- milliseconds to fade, or blink, e.g. 'millis=500'
  'count'  -- number of times to blink, for /blink1/blink, e.g. 'count=3'
  'pattern'-- color pattern string (e.g. '3,00ffff,0.2,0,000000,0.2,0')

Examples:
  /blink1/blue?bright=127 -- set blink1 blue, at half-intensity
  /blink1/fadeToRGB?rgb=FF00FF&millis=500 -- fade to purple over 500ms
  /blink1/pattern/play?pattern=3,00ffff,0.2,0,000000,0.2,0 -- blink cyan 3 times
```
