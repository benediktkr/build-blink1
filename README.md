# build-blink1

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Fbuild-blink1%2Fmain&style=flat-square)](https://jenkins.sudo.is/job/ben/job/build-blink1/)
[![BSD-2-Clause](https://www.sudo.is/readmes/license-BSD-blue.svg)](LICENSE)
![version](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Fbuild-blink1%2Fmain&style=flat-square&status=${description}&subject=version&build=lastStable&color=blue)
[![git](https://www.sudo.is/readmes/git.sudo.is-ben-blink1.svg)](https://git.sudo.is/ben/build-blink1)
[![github](https://www.sudo.is/readmes/github-benediktkr.svg)](https://github.com/benediktkr/build-blink1)
[![matrix](https://www.sudo.is/readmes/matrix-ben-sudo.is.svg)](https://matrix.to/#/@ben:sudo.is)

Custom small and simple build of [`blink1-tool`](https://github.com/todbot/blink1-tool/) for the [blink(1)](https://blink1.thingm.com/).

## Installation

```shell
sudo curl https://apt.sudo.is/KEY.gpg -o /etc/apt/keyrings/apt.sudo.is.gpg
echo "deb [signed-by=/etc/apt/keyrings/apt.sudo.is.gpg] https://apt.sudo.is /" | sudo tee -a /etc/apt/sources.list.d/apt.sudo.is.list
sudo apt update
sudo apt install blink1
```

## Usage

Configure which port it listens to in `/etc/default/blink1-tiny-server`:

```shell
$ cat /etc/default/blink1-tiny-server
BLINK1_TINY_SERVER_PORT=8011
```


Example:

```shell
$ curl -sX GET http://localhost:8011/blink1/fadeToRGB?rgb=ff0ff
```

Nginx config:

```nginx
    location /blink1/ {
        # For html page:
        #rewrite '^/blink1(/.*)$' $1 break;
        #sub_filter_once off;
        #sub_filter '"/' '"./';
        add_header Content-Type 'application/json' always;
        proxy_http_version 1.1;
        proxy_pass http://localhost:8011;

    }
```
Standard systemd service:

```shell
$ sudo systemctl status blink1-tiny-server.service | cat
● blink1-tiny-server.service - blink(1) tiny http server
     Loaded: loaded (/lib/systemd/system/blink1-tiny-server.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2023-10-03 23:48:31 CEST; 1 week 1 day ago
   Main PID: 1644193 (blink1-tiny-ser)
      Tasks: 1 (limit: 8999)
     Memory: 24.0M
        CPU: 54.354s
     CGroup: /system.slice/blink1-tiny-server.service
             └─1644193 /usr/local/bin/blink1-tiny-server -p 8011

Oct 03 23:48:31 mathom.s21.sudo.is systemd[1]: Started blink(1) tiny http server.
Oct 03 23:48:31 mathom.s21.sudo.is blink1-tiny-server[1644193]: blink1-tiny-server version v2.3.0-linux-x86_64: running on http://localhost:8011/ (html help enabeld)
```



The `--help` output from `blink1-tiny-server` is informative:

```shell
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
  'rgb'    -- hex RGB color code. e.g. 'rgb=FF9900' or 'rgb=%23FF9900'
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
