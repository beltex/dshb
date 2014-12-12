
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
    func draw()
    func resize(newCoords: Window)
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
    return Int32(floor(Double((COLS - (gap * Int32(widgets.count - 1)))) / Double(widgets.count)))
}


let smc = SMC()
if (smc.open() == kIOReturnSuccess) {
    HAS_SMC = true
    widgets.append(TMPWidget(win: Window()))
    widgets.append(FanWidget(win: Window()))
}

let battery = Battery()
if (battery.isLaptop()) {
    HAS_BATTERY = true
    battery.open()
    widgets.append(BatteryWidget(win: Window()))
}


var widgetLength = computeWidgetLength()
for var i = 0; i < widgets.count; ++i {
    widgets[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: (widgetLength + gap) * Int32(i), y: 0)))
}


//------------------------------------------------------------------------------
// MARK: GCD TIMER SETUP
//------------------------------------------------------------------------------


dispatch_source_set_timer(source,
                          dispatch_time(DISPATCH_TIME_NOW, 0),
                          FREQ * NSEC_PER_SEC, 0)

dispatch_source_set_event_handler(source, {
    for widget in widgets {
        widget.draw()
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
            clear()
            widgetLength = computeWidgetLength()
            for var i = 0; i < widgets.count; ++i {
                widgets[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: (widgetLength + gap) * Int32(i), y: 0)))
            }
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
smc.close()
battery.close()
