//
// WidgetCPU.swift
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

struct WidgetCPU: WidgetType {
    
    private var widget: WidgetBase
    private var sys = System()
    
    init(var window: Window = Window()) {
        widget = WidgetBase(name: "CPU", window: window)
        
        
        let stats = ["System", "User", "Idle", "Nice"]

        window.point.y++
        for stat in stats {
            widget.meters.append(Meter(name: stat,
                                       winCoords: window,
                                       max: 100.0,
                                       unit: .Percentage))
            window.point.y++
        }

        widget.meters[2].lowColour = Int32(3)
        widget.meters[2].highColour = Int32(1)
    }
    
    mutating func draw() {
        let values = sys.usageCPU()
        widget.meters[0].draw(String(Int(values.system)),
                       percentage: values.system / 100.0)
        widget.meters[1].draw(String(Int(values.user)),
                       percentage: values.user / 100.0)
        widget.meters[2].draw(String(Int(values.idle)),
                       percentage: values.idle / 100.0)
        widget.meters[3].draw(String(Int(values.nice)),
                       percentage: values.nice / 100.0)
    }
    
    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
}