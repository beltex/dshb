//
// WidgetUIStat.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2104-2015  beltex <http://beltex.github.io>
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

typealias WarningLevel = (range: HalfOpenInterval<Double>, color: WidgetUIColor)


enum Unit: String {
    case Celsius = "°C"
    case Fahrenheit = "°F"
    case Gigabyte = "GB"
    case Kelvin = "K"
    case Percentage = "%"
    case Megabyte = "MB"
    case MilliampereHour = " mAh"
    case None = ""
    case RPM = " RPM"
}


struct WidgetUIStat {
    
    let name: String

    var unit: Unit {
        didSet {
            unitCount = unit.rawValue.characters.count
        }
    }

    var maxValue: Double
    var window: Window

    var Cool: WarningLevel = (-Double.infinity..<0, WidgetUIColor.Cool)
    var Nominal: WarningLevel = (0..<0.45, WidgetUIColor.Nominal)
    var Danger: WarningLevel = (0.45..<0.75, WidgetUIColor.Danger)
    var Crisis: WarningLevel = (0.75..<Double.infinity, WidgetUIColor.Crisis)
    
    var lowColor = WidgetUIColorStatGood
    var midColor = WidgetUIColorStatWarning
    var highColor = WidgetUIColorStatDanger

    private let nameCount: Int
    private var unitCount = 0
    private var lastStr = String()
    private var lastPercentage = 0.0

    init(name: String, unit: Unit, max: Double, window: Window = Window()) {
        self.name = name
        self.unit = unit
        self.maxValue = max
        self.window = window

        nameCount = name.characters.count
        unitCount = unit.rawValue.characters.count
    }

    mutating func draw(str: String, percentage: Double) {
        lastStr = str
        lastPercentage = percentage

        let spaceCount = window.length - nameCount - str.characters.count - unitCount
        let space = String(count: max(spaceCount, 2), repeatedValue: Character(" "))


        var shortenedName = name
        if spaceCount <= 0 {
            shortenedName = (name as NSString).substringToIndex(nameCount + spaceCount - 2)
            shortenedName.extend("…")
        }


        let charactersToColorCount = Int(Double(window.length) * percentage)
        let fullStr = (shortenedName + space + str + unit.rawValue) as NSString
        let coloredStr = fullStr.substringToIndex(charactersToColorCount)
        let uncoloredStr = fullStr.substringFromIndex(charactersToColorCount)


        move(window.point.y, window.point.x)
        switch percentage {
        case Cool.range:    attrset(COLOR_PAIR(Cool.color.rawValue))
        case Nominal.range: attrset(COLOR_PAIR(Nominal.color.rawValue))
        case Danger.range:  attrset(COLOR_PAIR(Danger.color.rawValue))
        case Crisis.range:  attrset(COLOR_PAIR(Crisis.color.rawValue))
        default:            true
        }

        addstr(coloredStr)
        attrset(COLOR_PAIR(WidgetUIColor.Background.rawValue))
        addstr(uncoloredStr)
    }
    
    mutating func resize(window: Window) {
        self.window = window
        draw(lastStr, percentage: lastPercentage)
    }
}
