//
// Widget.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014-2016  beltex <http://beltex.github.io>
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

//------------------------------------------------------------------------------
// MARK: PROPERTIES
//------------------------------------------------------------------------------

// Color pair refs
enum WidgetUIColor: Int32 {
    case Background = 1
    case Title = 2
    case WarningLevelCool = 3
    case WarningLevelNominal = 4
    case WarningLevelDanger = 5
    case WarningLevelCrisis = 6
}

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

    mutating func resize(window: Window) -> Int32 {
        title.resize(window)

        var windowVar = window
        windowVar.point.y += 1    // Becuase of title
        for index in 0..<stats.count {
            stats[index].resize(windowVar)
            windowVar.point.y += 1
        }

        return windowVar.point.y
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

    // FIXME: Bad temporary hack to make proc list optional. Same further below
    let range = CLIExperimentalOption.wasSet ? widgets.count - 1 : widgets.count

    for index in 0..<range {
        // Are we on a new row?
        if index % Int(maxWidgetsPerRow) == 0 {
            y_pos_new += maxHeight - y_pos_new
            widgetRowCount = 0
        }

        result_pos = widgets[index].resize(Window(length: widgetLength,
                                              point: (x: (widgetLength + widgetSpacing) * widgetRowCount,
                                                      y: y_pos_new)))

        // While the width of each widget is fixed, the height is not, so
        // we need to know the max height of a row of widgets
        if result_pos > maxHeight {
            maxHeight = result_pos
        }

        widgetRowCount += 1
    }

    if CLIExperimentalOption.wasSet {
        widgets[widgets.count - 1].resize(Window(length: Int(COLS), point: (x: 0, y: maxHeight)))
    }

    refresh()
}
