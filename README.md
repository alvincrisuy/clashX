# ClashX

A rule based proxy For Mac base on [clash](https://github.com/Dreamacro/clash).

# Features

HTTP/HTTPS and SOCKS proxy
Surge like configuration
GeoIP rule support

# Install

You can download from [release](https://github.com/yichengchen/clashX/releases) page


# Config
You can use config generator in Status Bar Menu "Config" section.
Config support most of surge rules.

Configuration file at $HOME/.config/clash/config.ini

Below is a simple demo configuration file:
```
[General]
port = 7890
socks-port = 7891

[Proxy]
# name = ss, server, port, cipter, password
Proxy = ss, server, port, AEAD_CHACHA20_POLY1305, password

[Rule]
DOMAIN-SUFFIX,google.com,Proxy
DOMAIN-KEYWORD,google,Proxy
DOMAIN-SUFFIX,ad.com,REJECT
GEOIP,CN,DIRECT
FINAL,,Proxy // notice there is two ","

```
