//
// CPUWidget.swift
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

public struct CPUWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    private var sys = System()
    
    private let stats = ["System", "User", "Idle", "Nice"]
    
    init(win: Window = Window()) {
        // win.size.width not currently used
        self.win = win
        
        // Title init
        let titleCoords = Window(length: win.length, pos: (x:win.pos.x,
                                                           y:win.pos.y))
        title = WidgetTitle(title: "CPU", winCoords: titleCoords,
                                          colour: COLOR_PAIR(5))
        
        var yShift = 1
        for stat in stats {
            meters.append(Meter(name: stat,
                                winCoords: Window(length: win.length,
                                                  pos: (x:win.pos.x,
                                                        y:win.pos.y + yShift)),
                                max: 100.0,
                                unit: Meter.Unit.Percentage))
            ++yShift
        }

        meters[2].lowColour = Int32(3)
        meters[2].highColour = Int32(1)
    }
    
    
    mutating func draw() {
        let values = sys.usageCPU()
        meters[0].draw(String(Int(values.system)),
                       percentage: values.system / 100.0)
        meters[1].draw(String(Int(values.user)),
                       percentage: values.user / 100.0)
        meters[2].draw(String(Int(values.idle)),
                       percentage: values.idle / 100.0)
        meters[3].draw(String(Int(values.nice)),
                       percentage: values.nice / 100.0)
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        win = newCoords
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