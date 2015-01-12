//
// BarGraph.swift
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

///
public struct Meter {
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC ENUMS
    //--------------------------------------------------------------------------
    
    public enum Unit : String {
        case Celsius         = "°C"
        case Fahrenheit      = "°F"
        case Gigabyte        = "GB"
        case Kelvin          = "K"
        case Percentage      = "%"
        case Megabyte        = "MB"
        case MilliampereHour = " mAh"
        case None            = ""
        case RPM             = " RPM"
    }
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC PROPERTIES
    //--------------------------------------------------------------------------
    
    let name : String
    var unit : Unit
    
    var value : Double = 0
    var winCoords : Window
    var max   : Double
    
    var lowPercentage  = 0.45
    var midPercentage  = 0.30
    var highPercentage = 0.20
    
    
    var lowColour  : Int32 = 1
    var midColour  : Int32 = 2
    var highColour : Int32 = 3
    
    
    //--------------------------------------------------------------------------
    // MARK: PRIVATE PROPERTIES
    //--------------------------------------------------------------------------

    private let nameLength : Int
    private var unitLength : Int
    private var lastValue  = String()
    private var lastPercentage = 0.0
    
    private var low  : Int = 0
    private var mid  : Int = 0
    private var high : Int = 0
    
    //--------------------------------------------------------------------------
    // MARK: INITIALIZERS
    //--------------------------------------------------------------------------
    
    init(name: String, winCoords: Window, max: Double, unit: Unit) {
        self.name      = name
        self.winCoords = winCoords
        self.unit      = unit
        self.max       = max
        
        nameLength     = countElements(name)
        unitLength     = countElements(unit.rawValue)
        
        computeRanges()
    }
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC METHODS
    //--------------------------------------------------------------------------
    
    mutating func draw(value: String, percentage: Double) {
        lastValue = value
        lastPercentage = percentage
        let valueLength = countElements(value)
        
        // Name setup
        let numberChars = winCoords.length - (2 + valueLength + unitLength)
        
        var nameEdit = name
        if (nameLength > Int(numberChars) && Int(numberChars) > 0) {
            nameEdit = (name as NSString).substringToIndex(Int(numberChars - 1))
            nameEdit.append(UnicodeScalar("…"))
        }
        else if (Int(numberChars) < 0) {
            return
        }
        
        let spaceLen = winCoords.length - (countElements(nameEdit) + valueLength + unitLength)

        
        // Range setup
        //let percentage = Double(value) / Double(max)
        var valueRange = Int(floor(Double(winCoords.length) * percentage))
        
        var space = String()
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
    
        var char_array = Array(nameEdit + space + value + unit.rawValue)
        
        var count = 0
        move(winCoords.pos.y, winCoords.pos.x)
        for char in char_array {
            if (count < valueRange) {
                if (valueRange < low) {
                    // Green
                    attrset(COLOR_PAIR(lowColour))
                    addstr(String(char))
                }
                else if (valueRange >= low && valueRange < mid) {
                    // Yellow
                    attrset(COLOR_PAIR(midColour))
                    addstr(String(char))
                }
                else {
                    // Red
                    // > 23
                    attrset(COLOR_PAIR(highColour))
                    addstr(String(char))
                }
            }
            else {
                attrset(COLOR_PAIR(Int32(4)))
                addstr(String(char))
            }
            
            ++count
        }
    }
    
    
    mutating func resize(winCoords: Window) {
        self.winCoords = winCoords
        computeRanges()
        draw(lastValue, percentage: lastPercentage)
    }
    
    
    private mutating func computeRanges() {
        low  = Int(ceil(Double(winCoords.length) * lowPercentage))
        mid  = Int(floor(Double(winCoords.length) * midPercentage)) + low
        high = Int(floor(Double(winCoords.length) * highPercentage))
    }
}
