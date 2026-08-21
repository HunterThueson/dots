# Hestia

A new host to be added to the fleet: a Raspberry Pi-based server for self-hosting services, backing up files, and
acting as an NAS.

## Features

### Self-hosted Services

* Firefly III
* Penpot
* Pi-hole

### Network Attached Storage

Once prices of storage & RAM drops (fingers crossed), `hestia` will also be acting as a file backup server/NAS for
all of my media, home videos, personal photos, etc.

### Web Server

In the not-so-near future, I'll be working on a personal website (hopefully `hunter.thueson.com`, if I can get the
domain name) and it will need to be hosted. I'd rather do that myself and learn something than pay someone else to
do it, so let's plan on adding web hosting functionality to `hestia` at some as-yet-unknown future date.

This doesn't need a lot of attention right now, we just need to make sure that when we're wiring things together we
don't shoot ourselves in the foot later on down the line without realizing it. A web server is coming eventually,
so all design decisions should be made with that info in the back of our minds and should not make the eventual web
server implementation any more difficult than necessary.

### Extensibility

`hestia` is a Raspberry Pi-based server, and Raspberry Pi hardware lends itself well to setting up clusters when
more processing power is needed. All setup should keep the probability of re-configuring the hardware down the line
when demand for power/bandwidth grows in mind. Don't hard-code anything that might be upgraded/extended a month
from now.
