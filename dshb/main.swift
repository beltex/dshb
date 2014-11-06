
import IOKit
import Darwin
import Dispatch
import Foundation


/**
App version.

TODO: -v command line arg
*/
let VERSION = "0.0.1"
let MAX_WIDTH = 20.0



var source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                    0, 0,
                                    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))

dispatch_source_set_timer(source, dispatch_walltime(nil, 0), 1000000000, 1000000000)

//
//dispatch_source_set_event_handler(source, {
//    // getyx is complex macro
//    var x = getcurx(stdscr)
//    var y = getcury(stdscr)
//    
//    //getyx(stdscr,row,col)
//    move(20, 20)
//    addstr("HELLO - YEAH GCD")
//    move(y, x)
//    refresh()
//})
//
//// We have to resume the the dispatch source as it is paused by default
//dispatch_resume(source)



public struct Window {
    var size  : (length : Int32, width : Int32)
    var pos   : (x : Int32, y : Int32)
}




setlocale(LC_ALL, "")

// ncurses settings
initscr()                // Init window. Must be first
cbreak()

//nodelay(stdscr, true)    // Make input reads non-blocking

noecho()                 // Don't echo user input
nonl()                   // Disable newline mode
intrflush(stdscr, true) // Prevent flush
keypad(stdscr, true)     // Enable function and arrow keys
//curs_set(0)              // Set cursor to invisible


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



// newwin null check
var gap : Int32 = 5
var widgetLength = Int32(ceil(Double((COLS - gap)) / 2.0))

func compare(s1 : String, s2 : String) -> Bool {
    return s1 < s2
}

let  smc = SMC()
smc.open()

// TODO check if laptop
let battery = Battery()
battery.open()

let tmpWidget = TMPWidget(win: Window(size: (length: widgetLength, width: 1), pos: (x: 0, y: 0)))
tmpWidget.updateWidget()

//let fanWidget = FanWidget(win: Window(size: (length: widgetLength, width: 1), pos: (x: widgetLength + gap, y: 0)))

dispatch_source_set_event_handler(source, {
            tmpWidget.updateWidget()
            refresh()
})

dispatch_resume(source)
//for var i = 0; i < 20; ++i {
//    
//    tmpWidget.updateWidget()
//    //fanWidget.updateWidget()
//    sleep(1)
//}

var key : Int32 = 0
var quit = false
while (!quit) {
    key = getch()
    
    // has_key check for KEY_RESIZE?
    
    switch key {
        case KEY_RESIZE:
            dispatch_suspend(source)
            clear()
            tmpWidget.resizeWidget()
                refresh()
            dispatch_resume(source)
        case 27:
            //        move(20,20)
            //        addstr("EXIT")
            //        refresh()
            //        sleep(1)
            dispatch_suspend(source)
            quit = true
            break
        case KEY_DOWN:
            var x = getcurx(stdscr)
            var y = getcury(stdscr)
            move(y + 1, x)
            refresh()
        default:
            true
            //tmpWidget.updateWidget()
    }
    //sleep(1)

    
//    else if (key == 27) {
//
//    }
//    else if (key == KEY_DOWN) {
//
//    }
    //else {
        //fanWidget.updateWidget()
    //}
}

endwin()    // Close window. Must call before exit

smc.close()
battery.close()

//var ch = getchar()


