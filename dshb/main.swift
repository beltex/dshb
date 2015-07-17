//
// main.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2015  beltex <http://beltex.github.io>
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
import Darwin.ncurses

//------------------------------------------------------------------------------
// MARK: GLOBAL PROPERTIES
//------------------------------------------------------------------------------

/// Application version
let dshbVersion = "0.1.0-dev"

/// Statistic update frequency in seconds. Default is 1
let updateFrequency: UInt64

/// Does this machine have a battery?
let hasBattery: Bool

/// Does this machine have a SMC (System Management Controller)?
let hasSMC: Bool

/// Statistic widgets that are on (displayed)
var widgets: [WidgetType] = [WidgetCPU(), WidgetMemory(), WidgetSystem()]

//------------------------------------------------------------------------------
// MARK: COMMAND LINE INTERFACE
//------------------------------------------------------------------------------

let CLIFrequencyOption = IntOption(shortFlag: "f", longFlag: "frequency",
             helpMessage: "Statistic update frequency in seconds. Default is 1")
let CLIHelpOption      = BoolOption(shortFlag: "h", longFlag: "help",
                                    helpMessage: "Print the list of options")
let CLIVersionOption   = BoolOption(shortFlag: "v", longFlag: "version",
                                    helpMessage: "Print dshb version")

let CLI = CommandLine()
CLI.addOptions(CLIFrequencyOption, CLIHelpOption, CLIVersionOption)

do {
    try CLI.parse()
} catch {
    CLI.printUsage(error)
    exit(EX_USAGE)
}


// Give precedence to help flag
if CLIHelpOption.wasSet {
    CLI.printUsage()
    exit(EX_OK)
} else if CLIVersionOption.wasSet {
    print(dshbVersion)
    exit(EX_OK)
}


if let customFrequency = CLIFrequencyOption.value {
    if customFrequency < 1 {
        print("Usage: Statistic update frequency must be >= 1")
        exit(EX_USAGE)
    }

    updateFrequency = UInt64(customFrequency)
}
else { updateFrequency = 1 }

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
// TODO: Do has_color() check when we have a way to log the error, print()
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

// Do this before SMC, since temperature widget needs to know about battery
var battery = Battery()

if battery.open() == kIOReturnSuccess {
    // TODO: Could this change during use? Old MacBook with removeable battery?
    hasBattery = true
    widgets.append(WidgetBattery())
} else { hasBattery = false }


var smc = SMC()
if smc.open() == kIOReturnSuccess {
    hasSMC = true
    widgets.append(WidgetTemperature())

    // For the new fanless MacBook8,1
    if smc.getNumFans().numFans > 0 { widgets.append(WidgetFan()) }
}
else { hasSMC = false }

widgets.sortInPlace { $0.displayOrder < $1.displayOrder }

drawAllWidgets()

//------------------------------------------------------------------------------
// MARK: GCD TIMER SETUP
//------------------------------------------------------------------------------

// See comment for background for reference.
// https://github.com/beltex/dshb/issues/16#issuecomment-70699890

let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                    dispatch_queue_create("com.beltex.dshb",
                                                         DISPATCH_QUEUE_SERIAL))

dispatch_source_set_timer(source,
                          dispatch_time(DISPATCH_TIME_NOW, 0),
                          updateFrequency * NSEC_PER_SEC, 0)

dispatch_source_set_event_handler(source) {
    // TODO: If we call clear() here, can help address display "race condition"
    //       mentioned in issue #16 (see URL above). Though we'd have to redraw
    //       titles too
    for var i = 0; i < widgets.count; ++i { widgets[i].draw() }
    refresh()
}

// We have to resume the dispatch source as it is paused by default
dispatch_resume(source)

//------------------------------------------------------------------------------
// MARK: MAIN (EVENT) LOOP
//------------------------------------------------------------------------------

while true {
    switch getch() {
        // TODO: has_key() check for KEY_RESIZE?
    case KEY_RESIZE:
        // This could be done through GCD signal handler as well
        dispatch_suspend(source)
        // If this takes too long, queue will build up. Also, there is the
        // issue of mutiple resize calls.
        drawAllWidgets()
        dispatch_resume(source)
    case Int32(UnicodeScalar("q").value):
        dispatch_source_cancel(source)
        endwin()    // ncurses cleanup
        if hasSMC     { smc.close()     }
        if hasBattery { battery.close() }
        exit(EX_OK)
    default: true
    }
}
