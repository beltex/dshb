//
// WidgetUITitle.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014-2017  beltex <https://beltex.github.io>
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

import Darwin.ncurses

struct WidgetUITitle {

    let name     : String
    let nameCount: Int
    var window   : Window
    
    fileprivate var padding = String()
    
    init(name: String, window: Window) {
        self.name   = name
        self.window = window
        nameCount   = name.characters.count

        generatePadding()
    }
    
    func draw() {
        move(window.point.y, window.point.x)
        attrset(COLOR_PAIR(WidgetUIColor.title.rawValue))
        addstr(name + padding)
    }
    
    mutating func resize(_ window: Window) {
        self.window = window
        generatePadding()
        draw()
    }
    
    fileprivate mutating func generatePadding() {
        var paddingSize = window.length - nameCount

        if paddingSize < 0 { paddingSize = 0 }

        padding = String(repeating: " ", count: paddingSize)
    }
}
