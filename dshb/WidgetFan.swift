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

struct WidgetFan: WidgetType {

    private var widget: WidgetBase

    init(var window: Window = Window()) {
        widget = WidgetBase(name: "Fan", window: window)


        // TODO: Sort fan names
        let numFans = smc.getNumFans().numFans
        
        window.point.y++
        for var i: UInt = 0; i < numFans; ++i {
            widget.meters.append(Meter(name: smc.getFanName(i).name,
                                       winCoords: window,
                                       max: Double(smc.getFanMaxRPM(i).rpm),
                                       unit: .RPM))
            window.point.y++
        }
    }

    mutating func draw() {
        for var i = 0; i < widget.meters.count; ++i {
            let fanRPM = smc.getFanRPM(UInt(i)).rpm
            widget.meters[i].draw(String(fanRPM),
                                  percentage: Double(fanRPM) / widget.meters[i].max)
        }
    }

    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
}

