//
// Widget.swift
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

//------------------------------------------------------------------------------
// MARK: PROPERTIES
//------------------------------------------------------------------------------

// Color pair refs
let WidgetUIColorBackground : Int32 = 1
let WidgetUIColorTitle      : Int32 = 2
let WidgetUIColorStatGood   : Int32 = 3
let WidgetUIColorStatWarning: Int32 = 4
let WidgetUIColorStatDanger : Int32 = 5

/// Number of pixels between widgets
private let widgetSpacing   : Int32 = 1
private let maxWidgetsPerRow: Int32 = 3

//------------------------------------------------------------------------------
// MARK: PROTOCOLS
//------------------------------------------------------------------------------

protocol WidgetType {
    var name: String          { get     }
    var displayOrder: Int     { get     }
    var title: WidgetUITitle  { get set }
    var stats: [WidgetUIStat] { get set }

    init(window: Window)

    mutating func draw()
    mutating func resize(window: Window) -> Int32
}

extension WidgetType {

    mutating func resize(var window: Window) -> Int32 {
        title.resize(window)

        window.point.y++    // Becuase of title
        for var i = 0; i < stats.count; ++i {
            stats[i].resize(window)
            window.point.y++
        }

        return window.point.y
    }
}

//------------------------------------------------------------------------------
// MARK: STRUCTS
//------------------------------------------------------------------------------

/// Like an ncurses window
struct Window {
    var length                      = 0
    var point: (x: Int32, y: Int32) = (0, 0)
}

//------------------------------------------------------------------------------
// MARK: FUNCTIONS
//------------------------------------------------------------------------------

/// Clear the screen and redraw all widgets from scratch
func drawAllWidgets() {
    clear()

    let widgetLength = Int((COLS - (widgetSpacing * (maxWidgetsPerRow - 1)))
                                                             / maxWidgetsPerRow)
    var result_pos    : Int32 = 0
    var maxHeight     : Int32 = 0
    var y_pos_new     : Int32 = 0
    var widgetRowCount: Int32 = 0

    for var i = 0; i < widgets.count - 1; ++i {
        // Are we on a new row?
        if i % Int(maxWidgetsPerRow) == 0 {
            y_pos_new += maxHeight - y_pos_new
            widgetRowCount = 0
        }

        result_pos = widgets[i].resize(Window(length: widgetLength,
                                              point: (x: (widgetLength + widgetSpacing) * widgetRowCount,
                                                      y: y_pos_new)))

        // While the width of each widget is fixed, the height is not, so
        // we need to know the max height of a row of widgets
        if result_pos > maxHeight {
            maxHeight = result_pos
        }

        widgetRowCount++
    }

    widgets[widgets.count - 1].resize(Window(length: Int(COLS), point: (x: 0, y: maxHeight)))
    refresh()
}
