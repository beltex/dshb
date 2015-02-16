//
// FanWidget.swift
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


struct FanWidget: Widget {
    
    private var meters = [Meter]()
    //let maxValue : Int
    var title : WidgetTitle
    var win   : Window
    
    init(win: Window = Window()) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(length: win.length, pos: (x: win.pos.x,
                                                           y: win.pos.y))
        title = WidgetTitle(title: "Fan", winCoords: titleCoords,
                                          colour: COLOR_PAIR(5))
        
        let numFans = smc.getNumFans().numFans
        var y_pos = win.pos.y + 1 // Becuase of title
        
        // TODO: Sort fan names
        
        for var x : UInt = 0; x < numFans; ++x {
            let winCoords = Window(length: win.length, pos: (x: win.pos.x,
                                                             y: y_pos))
            meters.append(Meter(name: smc.getFanName(x).name,
                                winCoords: winCoords,
                                max: Double(smc.getFanMaxRPM(x).rpm),
                                unit: Meter.Unit.RPM))
            ++y_pos
        }
    }
    
    
    mutating func draw() {
        for var x = 0; x < meters.count; ++x {
            let value = smc.getFanRPM(UInt(x)).rpm
            meters[x].draw(String(value),
                           percentage: Double(value) / meters[x].max)
        }
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(length: win.length,
                                    pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}