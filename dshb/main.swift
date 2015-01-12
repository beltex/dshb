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
import Dispatch
import Foundation

//------------------------------------------------------------------------------
// MARK: GLOBAL PROTOCOLS
//------------------------------------------------------------------------------

protocol Widget {
    init(win: Window)
    mutating func draw()
    mutating func resize(newCoords: Window) -> Int32
}

//------------------------------------------------------------------------------
// MARK: GLOBAL STRUCTS
//------------------------------------------------------------------------------

/// Like an ncurses window
struct Window {
    var length = 0
    var pos    : (x: Int32, y: Int32) = (0, 0)
}

//------------------------------------------------------------------------------
// MARK: GLOBAL PROPERTIES
//------------------------------------------------------------------------------

/// Application version
let DSHB_VERSION = "0.0.1"

/// Does this machine have a battery?
var hasBattery = false

/// Does this machine have a SMC (System Management Controller)?
var hasSMC = false

/// Statistic update frequency in seconds
var FREQ: UInt64 = 1

/// Gap between widgets
var gap: Int32 = 1

/// Statistic widgets that are on (displayed)
var widgets = [Widget]()

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
noecho()                    // Don't echo user input
nonl()                      // Disable newline mode
intrflush(stdscr, true)     // Prevent flush
keypad(stdscr, true)        // Enable function and arrow keys
curs_set(0)                 // Set cursor to invisible


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
bkgd(UInt32(COLOR_PAIR(Int32(4))))

//------------------------------------------------------------------------------
// MARK: WIDGET SETUP
//------------------------------------------------------------------------------

func computeWidgetLength() -> Int {
    // 3 = max widgets per row
    return Int(floor(Double((COLS - (gap * Int32(3 - 1)))) / Double(3)))
}

widgets.append(CPUWidget())
widgets.append(MemoryWidget())
widgets.append(SystemWidget())

// Do this before SMC, since temperature widget needs to know about battery
var battery = Battery()
if (battery.open() == kIOReturnSuccess) {
    // TODO: Could this change during use? MacBook with removeable battery?
    hasBattery = true
    widgets.append(BatteryWidget())
}

var smc = SMC()
if (smc.open() == kIOReturnSuccess) {
    hasSMC = true
    widgets.append(TMPWidget())
    widgets.append(FanWidget())
}

func draw_all() {
    let widgetLength = computeWidgetLength()
    
    var result_pos: Int32 = 0
    var result_max: Int32 = 0
    var y_pos_new: Int32 = 0
    var x_multi: Int32 = 0
    for var i = 0; i < widgets.count; ++i {
        if (i % 3 == 0) {
            y_pos_new += result_max
            x_multi = 0
        }
        
        result_pos = widgets[i].resize(Window(length: widgetLength,
                                              pos: (x: (widgetLength + gap) * x_multi,
                                                    y: y_pos_new)))
        
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

// TODO: Custom serial attr prop creation is new to 10.10
let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                    dispatch_queue_create("com.beltex.dshb",
                                                         DISPATCH_QUEUE_SERIAL))

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
// MARK: MAIN (EVENT) LOOP
//------------------------------------------------------------------------------

while true {
    // TODO: Why does esc (27) cause such a slow response, as oppossed to
    //       something like 'q'?
    let key = getch()
    
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
