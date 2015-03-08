//
// WidgetMemory.swift
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

struct WidgetMemory: WidgetType {
    
    private var widget: WidgetBase
    private static let maxValueGB = System.physicalMemory(unit: .Gigabyte)
    private static let maxValueMB = System.physicalMemory(unit: .Megabyte)
    
    init(window: Window = Window()) {
        widget = WidgetBase(name: "Memory", window: window)

        
        let stats = ["Free", "Wired", "Active", "Inactive", "Compressed"]

        for stat in stats {
            widget.stats.append(WidgetUIStat(name: stat,
                                       max: WidgetMemory.maxValueGB,
                                       unit: .Gigabyte))
        }
        
        widget.stats[0].lowPercentage = 0.20
        widget.stats[0].highPercentage = 0.45
        widget.stats[0].lowColor  = WidgetUIColorStatDanger
        widget.stats[0].highColor = WidgetUIColorStatGood
    }
    
    mutating func draw() {
        let values = System.memoryUsage()
        unitCheck(values.free, index: 0)
        unitCheck(values.wired, index: 1)
        unitCheck(values.active, index: 2)
        unitCheck(values.inactive, index: 3)
        unitCheck(values.compressed, index: 4)
    }
    
    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
    
    private mutating func unitCheck(val: Double, index: Int) {
        if (val < 1.0) {
            widget.stats[index].unit = .Megabyte
            let value = val * 1000.0
            widget.stats[index].draw(String(Int(value)),
                               percentage: value / WidgetMemory.maxValueMB)
        }
        else {
            widget.stats[index].unit = .Gigabyte
            widget.stats[index].draw(NSString(format:"%.2f", val) as String,
                               percentage: val / WidgetMemory.maxValueGB)
        }
    }
}
