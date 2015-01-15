dshb
====

An OS X system monitor in Swift, inspired by
<a href="https://en.wikipedia.org/wiki/Top_(software)">top</a> &
[htop](https://github.com/hishamhm/htop).

![alt text](http://beltex.github.io/dshb/dshb.png)


### Why?

- Exploration of Swift. In particular, systems programming and interfacing with
  low-level C APIs
- Improved top
- Improved htop (for OS X). htop was originally written for Linux. It was forked
  at some point and ported over to OS X. However, the port is now using what is
  a 5 year old fork. Work is being done to address
  [this](https://www.bountysource.com/teams/htop/fundraiser)

> Of course, the last two are far from being true! :) dshb is still early in
> development.


### Requirements

- [Xcode 6.1](https://developer.apple.com/xcode/downloads/)
- OS X 10.9+
    - This is due to Swift  


### Clone

Make sure to use the recursive option on clone to auto init all submodules.

```sh
git clone --recursive https://github.com/beltex/dshb
```

Incase you have already cloned the repository.

```sh
# Inside the project directory
git submodule update --init --recursive
```


### Build

Besides building from inside of Xcode, you can compile dshb from the command
line like so

```sh
make
```

The resulting binary will be found inside the `bin/` directory. If you copy it
to either `/usr/bin/` (requires `sudo`) or `/usr/local/bin/` (assuming it's in
your `PATH` - Homebrew would have done this for you), you can then run `dshb`
from anywhere.


### Stack

- [ncurses](https://www.gnu.org/software/ncurses/ncurses.html)
- [SystemKit](https://github.com/beltex/SystemKit)
- [SMCKit](https://github.com/beltex/SMCKit)
- [CommandLine](https://github.com/jatoben/CommandLine)
- [ronn](https://github.com/rtomayko/ronn)


### References

- [top](http://www.opensource.apple.com/source/top/)
- [NCURSES Programming HOWTO](http://www.tldp.org/HOWTO/NCURSES-Programming-HOWTO/index.html)
- [Programmer's Guide to ncurses](http://www.c-for-dummies.com/ncurses/)
- [Writing Programs with NCURSES](http://invisible-island.net/ncurses/ncurses-intro.html)


### License

This project is under the **MIT License**.


##### _P.S._

Working on this always brought a smile to my face. I hope it brings a smile to
yours too.
[Enjoy](http://hypem.com/track/23j7h/First+Aid+Kit+-+My+Silver+Lining) :)
 
