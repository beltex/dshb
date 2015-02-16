//
// WidgetTitle.swift
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

struct WidgetTitle {

    let title     : String
    let colour    : Int32
    var winCoords : Window
    
    private var titlePadding = String()
    
    
    init(title: String, winCoords: Window, colour: Int32) {
        self.title     = title
        self.colour    = colour
        self.winCoords = winCoords
        
        computeTitlePadding()
    }
    
    
    func draw() {
        move(winCoords.pos.y, winCoords.pos.x)
        attrset(colour)
        addstr(title + titlePadding)
    }
    
    
    mutating func resize(winCoords: Window) {
        self.winCoords = winCoords
        computeTitlePadding()
        draw()
    }
    
    
    private mutating func computeTitlePadding() {
        titlePadding = String()
        let spaceLength = Int(winCoords.length) - count(title)
        
        for var i = 0; i < spaceLength; ++i {
            titlePadding.append(UnicodeScalar(" "))
        }
    }
}
