//
// WidgetUITitle.swift
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

struct WidgetUITitle {

    let name  : String
    var window: Window
    let colour: Int32
    
    private var padding = String()
    
    init(name: String, window: Window, colour: Int32) {
        self.name   = name
        self.colour = colour
        self.window = window
        
        generatePadding()
    }
    
    func draw() {
        move(window.point.y, window.point.x)
        attrset(colour)
        addstr(name + padding)
    }
    
    mutating func resize(window: Window) {
        self.window = window
        generatePadding()
        draw()
    }
    
    private mutating func generatePadding() {
        padding = String()
        let spaceLength = Int(window.length) - count(name)
        
        for var i = 0; i < spaceLength; ++i {
            padding.append(UnicodeScalar(" "))
        }
    }
}
