//
// WidgetSystem.swift
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

import Foundation

struct WidgetSystem: WidgetType {

    let name = "System"
    let displayOrder = 3
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)

        for stat in ["Uptime", "Processes", "Threads", "Load Average", "Mach Factor"] {
            stats.append(WidgetUIStat(name: stat, unit: .None, max: 1.0))
        }
    }
    
    mutating func draw() {
        let uptime = System.uptime()
        stats[0].draw("\(uptime.days)d \(uptime.hrs)h \(uptime.mins)m",
                      percentage: 0.0)

        let counts = System.processCounts()
        stats[1].draw(String(counts.processCount), percentage: 0.0)
        stats[2].draw(String(counts.threadCount), percentage: 0.0)

        let loadAverage = System.loadAverage().map
                                               { NSString(format:"%.2f", $0) }
        stats[3].draw("\(loadAverage[0]), \(loadAverage[1])," +
                       "\(loadAverage[2])", percentage: 0.0)
        
        let machFactor = System.machFactor().map { NSString(format:"%.2f", $0) }

        stats[4].draw("\(machFactor[0]), \(machFactor[1]), \(machFactor[2])",
                                                            percentage: 0.0)
    }
}
