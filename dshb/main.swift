import IOKit
import Darwin
import Dispatch


/**
App version.

TODO: -v command line arg
*/
let VERSION = "0.0.1"


// Setup Signal handler for window resize
var source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL,
                                    UInt(SIGWINCH), 0,
                                    dispatch_get_global_queue(0, 0))

dispatch_source_set_event_handler(source, {
    addstr("HELLO - YEAH GCD")
    refresh()
})

// We have to resume the the dispatch source as it is paused by default
dispatch_resume(source)



public struct WinCoords {
    var size  : (length : Int32, width : Int32)
    var pos   : (x : Int32, y : Int32)
}




setlocale(LC_ALL, "")

// ncurses settings
initscr()                // Init window. Must be first
cbreak()
noecho()                 // Don't echo user input
nonl()                   // Disable newline mode
intrflush(stdscr, false) // Prevent flush
keypad(stdscr, true)     // Enable function and arrow keys
curs_set(0)              // Set cursor to invisible


if (!has_colors()) {
    println("WARN: Terminal doesn't have support for colours")
}
// do custom colors check

// Init terminal colours
start_color()
init_pair(1, Int16(COLOR_BLACK), Int16(COLOR_GREEN))
init_pair(2, Int16(COLOR_BLACK), Int16(COLOR_YELLOW))
init_pair(3, Int16(COLOR_BLACK), Int16(COLOR_RED))
init_pair(4, Int16(COLOR_WHITE), Int16(use_default_colors()))
init_pair(5, Int16(COLOR_WHITE), Int16(COLOR_CYAN))
var y2 = "Lines: " + String(LINES) + " COLS: " + String(COLS)
addstr("-- Hello")
addstr(y2)
refresh()



// newwin null check
var gap : Int32 = 5
var bar_size = Int32(ceil(Double((COLS - gap)) / 2.0))
addstr("bar size: " + String(bar_size))
refresh()
var bar_size2 = bar_size + gap


var tmpTitleCoords = WinCoords(size: (length: bar_size, width: 1), pos: (x:0, y:9))
var tmpTitle = TabTitle(title: "TMPs", winCoords: tmpTitleCoords, colour: COLOR_PAIR(5))

var fanTitleCoords = WinCoords(size: (length: bar_size, width: 1), pos: (x:bar_size2, y:9))
var fanTitle = TabTitle(title: "FANS", winCoords: fanTitleCoords, colour: COLOR_PAIR(5))


func compare(s1 : String, s2 : String) -> Bool {
    return s1 < s2
}

let  smc = SMC()
assert(smc.open() == kIOReturnSuccess, "ERROR: Connection to SMC failed")

var tmpKeys = smc.getAllValidTMPKeys()

var sort = sorted(tmpKeys.values.array, compare)

var bars = [BarGraph]()

var temp :Int32 = 10
for name in sort {
    addstr(name + "//")
    refresh()
    //bars.append(BarGraph(name: SMCKey, length: bar_size, width: 1, x: 0, y: temp, max: 105, unit: BarGraph.Unit.Celsius))
    bars.append(BarGraph(name: name, length: bar_size, width: 1, x: 0, y: temp, max: 105, unit: BarGraph.Unit.Celsius))
    ++temp
}


var numFans = smc.getNumFans().numFans
var fans = [BarGraph]()

var temp2 : Int32 = 10
for var x : UInt = 0; x < numFans; ++x {
    fans.append(BarGraph(name: smc.getFanName(x).name, length: bar_size, width: 1, x: bar_size2, y: temp2, max: Int(smc.getFanMaxRPM(x).rpm), unit: BarGraph.Unit.RPM))
    ++temp2
}



for var i = 0; i < 20; ++i {
    
    for b in bars {
        b.update(Int(smc.getTMP(SMC.TMP.allValues[b.name]!).tmp))
    }
    
    for var x = 0; x < fans.count; ++x {
        fans[x].update(Int(smc.getFanRPM(UInt(x)).rpm))
    }
    sleep(1)
}

smc.close()


addstr("DONE")
refresh()

var ch = getchar()

endwin()    // Close window. Must call before exit
