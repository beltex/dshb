dshb
====

An OS X system monitor in Swift, inspired by
[iStat Pro](https://www.apple.com/downloads/dashboard/status/istatpro.html),
[htop](https://github.com/hishamhm/htop) & [top](http://opensource.apple.com/source/top/).

- Low overhead


### Why?

- Exploration of Swift. In particular, systems programming and interfacing with
  low-level C APIs in Swift
- Improved top*
- Improved htop (for OS X)*. htop was originally written for Linux. It was forked
  at some point and ported over to OS X. However, the port is now using what is
  a 5 year old fork. Working is being done on this front:
  https://www.bountysource.com/teams/htop/fundraiser
  Also, more OS X native stats
- Usage of SMCKit & SystemKit libraries 

* Of course, these are yet to come to fruition, as both have been around for
  some time and are battle tested.

### Install

Via [Homebrew](http://brew.sh)

```bash
$ brew install dshb
```

This will auto init all submodules as well.

```bash
git clone --recursive git@github.com:beltex/dshb.git
```

### Requirements

- OS X 10.9+
    - This is due to Swift  

### Stack

- [Xcode 6.1](https://developer.apple.com/xcode/downloads/)
- [ncurses](https://www.gnu.org/software/ncurses/ncurses.html)
- [SystemKit](https://github.com/beltex/SystemKit)
- [SMCKit](https://github.com/beltex/SMCKit)


### Manual page

- Via [ronn](https://github.com/rtomayko/ronn)


### References

- [NCURSES Programming HOWTO](http://www.tldp.org/HOWTO/NCURSES-Programming-HOWTO/index.html)
- [Programmer's Guide to ncurses](http://www.c-for-dummies.com/ncurses/)
- [Writing Programs with NCURSES](http://invisible-island.net/ncurses/ncurses-intro.html)


### License

This project is under the **MIT License**.
