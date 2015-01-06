
import IOKit
import Darwin
import Dispatch
import Foundation

//------------------------------------------------------------------------------
// MARK: GLOBAL STRUCTS
//------------------------------------------------------------------------------


/**
Like an ncurses window
*/
struct Window {
    var size : (length: Int32, width: Int32) = (0, 0)
    var pos  : (x: Int32, y: Int32) = (0, 0)
}


//------------------------------------------------------------------------------
// MARK:  GLOBAL PROTOCOLS
//------------------------------------------------------------------------------


protocol Widget {
    mutating func draw()
    mutating func resize(newCoords: Window) -> Int32
}


//------------------------------------------------------------------------------
// MARK: GLOBAL PROPERTIES
//------------------------------------------------------------------------------


/**
dshb version
*/
let DSHB_VERSION = "0.0.1"


/**
Does the machine have a battery?
*/
var HAS_BATTERY = false


/**
Does the machine have a SMC (System Management Controller)?
*/
var HAS_SMC = false


/**
Statistic update frequency in seconds
*/
var FREQ: UInt64 = 1


/**
Gap between widgets
*/
var gap: Int32 = 1


/**
Statistic widgets that are on (displayed)
*/
var widgets = [Widget]()


// TODO: This should probably be a serial queue
// TODO: Custom serial attr prop creation causes runtime crash - Swift bug?
var source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                    dispatch_get_global_queue(
                                               DISPATCH_QUEUE_PRIORITY_HIGH, 0))


//------------------------------------------------------------------------------
// MARK: CLI
//------------------------------------------------------------------------------


let CLI = CommandLine()

let CLI_VERSION = BoolOption(shortFlag: "v", longFlag: "version",
                             helpMessage: "Show dshb version and exit.")
let CLI_USER = StringOption(shortFlag: "u", longFlag: "user", required: false,
                            helpMessage: "Show only processes of a given user.")
let CLI_HELP = BoolOption(shortFlag: "h", longFlag: "help",
                          helpMessage: "Show help message.")
let CLI_FREQ = IntOption(shortFlag: "f", longFlag: "frequency", required: false,
                         helpMessage: "Statistic update frequency in seconds.")

CLI.addOptions(CLI_VERSION, CLI_USER, CLI_HELP, CLI_FREQ)
let (success, error) = CLI.parse()
if (!success) {
    println(error!)
    CLI.printUsage()
    exit(EX_USAGE)
}

if (CLI_HELP.value) {
    CLI.printUsage()
    exit(EX_USAGE)
}
else if (CLI_VERSION.value) {
    println(DSHB_VERSION)
    exit(EX_USAGE)
}

if let user_freq = CLI_FREQ.value {
    FREQ = UInt64(user_freq)
}


//------------------------------------------------------------------------------
// MARK: NCURSES SETTINGS
//------------------------------------------------------------------------------


setlocale(LC_ALL, "")
initscr()                   // Init window. Must be first
cbreak()
//nodelay(stdscr, true)     // Make input reads non-blocking - WARN - HIGH CPU!!
noecho()                    // Don't echo user input
nonl()                      // Disable newline mode
intrflush(stdscr, true)     // Prevent flush
keypad(stdscr, true)        // Enable function and arrow keys
//timeout(0)
curs_set(0)                 // Set cursor to invisible
//idlok(stdscr, true)
//scrollok(stdscr, true)


// TODO: If no colour support, is it still safe to make colour related ncurses
//       calls?
if (!has_colors()) {
    println("WARN: Terminal doesn't have support for colours")
}

// Init terminal colours
start_color()
init_pair(1, Int16(COLOR_BLACK), Int16(COLOR_GREEN))
init_pair(2, Int16(COLOR_BLACK), Int16(COLOR_YELLOW))
init_pair(3, Int16(COLOR_BLACK), Int16(COLOR_RED))
init_pair(4, Int16(COLOR_WHITE), Int16(use_default_colors()))
init_pair(5, Int16(COLOR_WHITE), Int16(COLOR_CYAN))


//------------------------------------------------------------------------------
// MARK: WIDGET SETUP
//------------------------------------------------------------------------------


func computeWidgetLength() -> Int32 {
    //return Int32(floor(Double((COLS - (gap * Int32(widgets.count - 1)))) / Double(widgets.count)))
    return Int32(floor(Double((COLS - (gap * Int32(3 - 1)))) / Double(3)))
}

widgets.append(CPUWidget(win: Window()))
widgets.append(MemoryWidget(win: Window()))
widgets.append(SystemWidget(win: Window()))


var smc = SMC()
if (smc.open() == kIOReturnSuccess) {
    HAS_SMC = true
    widgets.append(TMPWidget(win: Window()))
    widgets.append(FanWidget(win: Window()))
}

var battery = Battery()
if (battery.open() == kIOReturnSuccess) {
    // TODO: Could this change during use? MacBook with removeable battery?
    HAS_BATTERY = true
    widgets.append(BatteryWidget(win: Window()))
}

var widgetLength: Int32 = 0

func draw_all() {
    widgetLength = computeWidgetLength()
    
    var result_pos: Int32 = 0
    var result_max: Int32 = 0
    var y_pos_new: Int32 = 0
    var x_multi: Int32 = 0
    for var i = 0; i < widgets.count; ++i {
        if (i % 3 == 0) {
            y_pos_new += result_max
            x_multi = 0
        }
        
        result_pos = widgets[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: (widgetLength + gap) * x_multi, y: y_pos_new)))
        
        if (result_pos > result_max) {
            result_max = result_pos
        }
        ++x_multi
    }
}

draw_all()


//------------------------------------------------------------------------------
// MARK: GCD TIMER SETUP
//------------------------------------------------------------------------------


dispatch_source_set_timer(source,
                          dispatch_time(DISPATCH_TIME_NOW, 0),
                          FREQ * NSEC_PER_SEC, 0)

dispatch_source_set_event_handler(source, {
    for var i = 0; i < widgets.count; ++i {
        widgets[i].draw()
    }
    refresh()
})

// We have to resume the the dispatch source as it is paused by default
dispatch_resume(source)


//------------------------------------------------------------------------------
// MARK: MAIN (EVENT) LOOP - WHERE THE MAGIC HAPPENS :)
//------------------------------------------------------------------------------


var key : Int32 = 0
var quit = false

while (!quit) {
    // TODO: Why does esc (27) cause such a slow response, as oppossed to
    //       something like 'q'?
    key = getch()
    
    switch key {
        // TODO: has_key() check for KEY_RESIZE?
        case KEY_RESIZE:
            // This could be done through GCD signal handler as well
            dispatch_suspend(source)
            // If this takes too long, queue will build up. Also, there is the 
            // issue of mutiple resize calls.
            clear()
            draw_all()
            refresh()
            dispatch_resume(source)
        case 113:
            dispatch_source_cancel(source)
            endwin()    // Close window. Must call before exit
            quit = true
            break
        case KEY_DOWN:
            // FIXME: This is just temp, for testing
            var x = getcurx(stdscr)
            var y = getcury(stdscr)
            move(y + 1, x)
            refresh()
        default:
            true
    }
}

// Cleanup

if (HAS_SMC) { smc.close() }
if (HAS_BATTERY) { battery.close() }
