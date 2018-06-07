# crDroid Dockerfile [![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg?style=for-the-badge)](https://www.paypal.me/HaoZeke/)
> Copyright (C) 2017  Rohit Goswami <rohit1995@mail.ru>

Meant for compiling finicky android systems with an archlinux box.

Works as a self contained setup for [crDroid](https://github.com/crdroidandroid).

## Usage

The recommended usage leverages your existing build tree so you only need this as your build environment.

```bash
docker run -it -h crdroid -v $SOURCE_LOCATION:/home/build/Android -v $HOME/.ccache/:/home/build/.ccache -v $HOME.cache/:/home/build/.cache HaoZeke/crdroid
```
