//
// SystemWidget.swift
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

import Foundation

public struct SystemWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    let stats = ["Uptime", "Processes", "Threads", "Load Avg", "Mach factor"]
    
    
    init(win: Window = Window()) {        
        self.win = win
        
        let titleCoords = Window(length: win.length, pos: (x:win.pos.x,
                                                           y:win.pos.y))
        title = WidgetTitle(title: "System", winCoords: titleCoords,
                                             colour: COLOR_PAIR(5))
        
        var yShift = 1
        for stat in stats {
            meters.append(Meter(name: stat,
                                winCoords: Window(length: win.length,
                                                  pos: (x:win.pos.x,
                                                        y:win.pos.y + yShift)),
                                max: 1.0,
                                unit: Meter.Unit.None))
            ++yShift
        }
    }
    
    
    mutating func draw() {
        let uptime = System.uptime()
        meters[0].draw("\(uptime.days)d \(uptime.hrs)h \(uptime.mins)m",
                       percentage: 0.0)

        meters[1].draw(String(System.processCount()), percentage: 0.0)
        meters[2].draw(String(System.threadCount()), percentage: 0.0)
        
        let loadAverage = System.loadAverage().map({ NSString(format:"%.2f", $0)
                                                                              })
        meters[3].draw("\(loadAverage[0]), \(loadAverage[1])," +
                       "\(loadAverage[2])", percentage: 0.0)
        
        let machFactor = System.machFactor().map({ NSString(format:"%.2f", $0) }
                                                                               )
        meters[4].draw("\(machFactor[0]), \(machFactor[1]), \(machFactor[2])",
                                                            percentage: 0.0)
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(length: win.length, pos: (x: win.pos.x,
                                                              y: y_pos)))
            y_pos++
        }

        return y_pos
    }
}