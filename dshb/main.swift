//
// main.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014, 2015  beltex <https://github.com/beltex>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import IOKit
import Darwin
import Darwin.ncurses
import Dispatch
import Foundation

//------------------------------------------------------------------------------
// MARK: GLOBAL PROPERTIES
//------------------------------------------------------------------------------

/// Application version
let DSHB_VERSION = "0.0.3"

/// Does this machine have a battery?
let hasBattery: Bool

/// Does this machine have a SMC (System Management Controller)?
let hasSMC: Bool

/// Statistic update frequency in seconds
let FREQ: UInt64

/// Statistic widgets that are on (displayed)
var widgets = [WidgetType]()

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
else {
    FREQ = 1
}

//------------------------------------------------------------------------------
// MARK: NCURSES SETTINGS
//------------------------------------------------------------------------------

setlocale(LC_ALL, "")
initscr()                   // Init window. Must be first
cbreak()
noecho()                    // Don't echo user input
nonl()                      // Disable newline mode
intrflush(stdscr, true)     // Prevent flush
keypad(stdscr, true)        // Enable function and arrow keys
curs_set(0)                 // Set cursor to invisible

// Init terminal colours
// TODO: Do has_color() check when we have a way to log the error, println()
//       won't work
start_color()
init_pair(Int16(WidgetUIColorBackground),  Int16(COLOR_WHITE),
                                           Int16(use_default_colors()))
init_pair(Int16(WidgetUIColorTitle),       Int16(COLOR_WHITE),
                                           Int16(COLOR_CYAN))
init_pair(Int16(WidgetUIColorStatGood),    Int16(COLOR_BLACK),
                                           Int16(COLOR_GREEN))
init_pair(Int16(WidgetUIColorStatWarning), Int16(COLOR_BLACK),
                                           Int16(COLOR_YELLOW))
init_pair(Int16(WidgetUIColorStatDanger),  Int16(COLOR_BLACK),
                                           Int16(COLOR_RED))

bkgd(UInt32(COLOR_PAIR(WidgetUIColorBackground)))

//------------------------------------------------------------------------------
// MARK: WIDGET SETUP
//------------------------------------------------------------------------------

widgets.append(WidgetCPU())
widgets.append(WidgetMemory())
widgets.append(WidgetSystem())

// Do this before SMC, since temperature widget needs to know about battery
var battery = Battery()
if (battery.open() == kIOReturnSuccess) {
    // TODO: Could this change during use? MacBook with removeable battery?
    hasBattery = true
    widgets.append(WidgetBattery())
} else {
    hasBattery = false
}

var smc = SMC()
if (smc.open() == kIOReturnSuccess) {
    hasSMC = true
    widgets.append(WidgetTemperature())
    widgets.append(WidgetFan())
}
else {
    hasSMC = false
}

drawAllWidgets()

//------------------------------------------------------------------------------
// MARK: GCD TIMER SETUP
//------------------------------------------------------------------------------

// TODO: Custom serial attr prop creation is new to 10.10
// dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL,
//                                         QOS_CLASS_USER_INITIATED, 0)

let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                    dispatch_queue_create("com.beltex.dshb",
                                                         DISPATCH_QUEUE_SERIAL))

// TODO: What about dispatch_after?
dispatch_source_set_timer(source,
                          dispatch_time(DISPATCH_TIME_NOW, 0),
                          FREQ * NSEC_PER_SEC, 0)

dispatch_source_set_event_handler(source) {
    for var i = 0; i < widgets.count; ++i {
        widgets[i].draw()
    }
    refresh()
}

// We have to resume the the dispatch source as it is paused by default
dispatch_resume(source)

//------------------------------------------------------------------------------
// MARK: MAIN (EVENT) LOOP
//------------------------------------------------------------------------------

while true {
    // TODO: Why does 'esc' (27) cause such a slow response, as oppossed to
    //       something like 'q'?
    
    switch getch() {
        // TODO: has_key() check for KEY_RESIZE?
        case KEY_RESIZE:
            // This could be done through GCD signal handler as well
            dispatch_suspend(source)
            // If this takes too long, queue will build up. Also, there is the 
            // issue of mutiple resize calls.
            drawAllWidgets()
            refresh()
            dispatch_resume(source)
        case Int32(UnicodeScalar("q").value):
            dispatch_source_cancel(source)
            endwin()    // ncurses cleanup
            if (hasSMC)     { smc.close()     }
            if (hasBattery) { battery.close() }
            exit(EX_OK)
        default:
            true
    }
}
