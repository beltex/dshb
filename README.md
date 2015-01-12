dshb
====

An OS X system monitor in Swift, inspired by
[top](https://en.wikipedia.org/wiki/Top_(software) &
[htop](https://github.com/hishamhm/htop).


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


### Requirements

- OS X 10.9+
    - This is due to Swift  


### Install

This will auto init all submodules as well.

```bash
git clone --recursive git@github.com:beltex/dshb.git
```


### Stack

- [Xcode 6.1](https://developer.apple.com/xcode/downloads/)
- [ncurses](https://www.gnu.org/software/ncurses/ncurses.html)
- [SystemKit](https://github.com/beltex/SystemKit)
- [SMCKit](https://github.com/beltex/SMCKit)
- [CommandLine](https://github.com/jatoben/CommandLine)


### Manual page

- Via [ronn](https://github.com/rtomayko/ronn)


### References

- [top](http://www.opensource.apple.com/source/top/)
- [NCURSES Programming HOWTO](http://www.tldp.org/HOWTO/NCURSES-Programming-HOWTO/index.html)
- [Programmer's Guide to ncurses](http://www.c-for-dummies.com/ncurses/)
- [Writing Programs with NCURSES](http://invisible-island.net/ncurses/ncurses-intro.html)


### License

This project is under the **MIT License**.
