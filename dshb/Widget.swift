//
// Widget.swift
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

//------------------------------------------------------------------------------
// MARK: PROTOCOLS
//------------------------------------------------------------------------------

protocol WidgetType {
    init(var window: Window)
    mutating func draw()
    mutating func resize(window: Window) -> Int32
}

//------------------------------------------------------------------------------
// MARK: STRUCTS
//------------------------------------------------------------------------------

/// Like an ncurses window
struct Window {
    var length                      = 0
    var point: (x: Int32, y: Int32) = (0, 0)
}

/// Base (parent) widget
struct WidgetBase {
    var title: WidgetTitle
    var meters = [Meter]()
    
    init(name: String, window: Window = Window()) {
        title = WidgetTitle(name: name, window: window, colour: COLOR_PAIR(5))
    }
    
    mutating func resize(var window: Window) -> Int32 {
        var test = window
        title.resize(window)
        
        window.point.y++    // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(window)
            window.point.y++
        }
        
        return window.point.y
    }
}