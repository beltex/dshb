//
// WidgetSystem.swift
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

struct WidgetSystem: WidgetType {
    
    private var widget: WidgetBase
    
    init(var window: Window = Window()) {
        widget = WidgetBase(name: "System", window: window)

        
        let stats = ["Uptime","Processes","Threads","Load Avg","Mach factor"]
        
        window.point.y++
        for stat in stats {
            widget.meters.append(Meter(name: stat,
                                       window: window,
                                       max: 1.0,
                                       unit: .None))
            window.point.y++
        }
    }
    
    mutating func draw() {
        let uptime = System.uptime()
        widget.meters[0].draw("\(uptime.days)d \(uptime.hrs)h \(uptime.mins)m",
                       percentage: 0.0)

        widget.meters[1].draw(String(System.processCount()), percentage: 0.0)
        widget.meters[2].draw(String(System.threadCount()), percentage: 0.0)
        
        let loadAverage = System.loadAverage().map
                                               { NSString(format:"%.2f", $0) }
        widget.meters[3].draw("\(loadAverage[0]), \(loadAverage[1])," +
                       "\(loadAverage[2])", percentage: 0.0)
        
        let machFactor = System.machFactor().map { NSString(format:"%.2f", $0) }

        widget.meters[4].draw("\(machFactor[0]), \(machFactor[1]), \(machFactor[2])",
                                                            percentage: 0.0)
    }
    
    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
}