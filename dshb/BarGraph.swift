/*
 * BarGraph
 * dshb
 *
 * Copyright (C) 2014  beltex <https://github.com/beltex>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

import Foundation

/**
Bar graph (meter) used to display a metric.
*/
public class BarGraph {
    
    
    public enum Unit : String {
        case Celsius    = "°C"
        case Fahrenheit = "°F"
        case Gigabyte   = "GB"
        case Kelvin     = "K"
        case Percentage = "%"
        case Megabyte   = "MB"
        case None       = ""
        case RPM        = "RPM"
    }
    
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC PROPERTIES
    //--------------------------------------------------------------------------
    
    
    let name : String
    let unit : Unit
    
    var value : Double = 0
    var size  : (length : Int32, width : Int32)
    var pos   : (x : Int32, y : Int32)
    let max   : Int
    
    
    //--------------------------------------------------------------------------
    // MARK: PRIVATE PROPERTIES
    //--------------------------------------------------------------------------
    
    
    /**
    The ncurses window.
    */
    //private var win : COpaquePointer
    
    private var space = String()
    
    private let nameLen  : Int
    private let unitLen  : Int
    private var spaceLen : Int = 0
    //private var zones : (low : Int, mid : Int, high : Int)
    
    
    //--------------------------------------------------------------------------
    // MARK: INITIALIZERS
    //--------------------------------------------------------------------------

    
    init(name : String, length : Int32, width : Int32, x    : Int32,
                                                       y    : Int32,
                                                       max  : Int,
                                                       unit : Unit) {
        self.name = name
        self.unit = unit
        self.max = max
        size.length = length
        size.width  = width
        pos.x = x
        pos.y = y
        
        
        nameLen = countElements(name)
        unitLen = countElements(unit.rawValue)
                                                        
        //win = newwin(size.width, size.length, pos.y, pos.x)
    }
    
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC METHODS
    //--------------------------------------------------------------------------
    
   /* 
    func move(x : Int, y : Int) {
        
    }
    */
    
    func resize(length : Int, width : Int) {
        
    }
    
    
    /**
    Update the value of the meter.
    */
    func update(val : Int) {
        move(pos.y, pos.x)                                                  
        var spaceLen = size.length - (countElements(name) + countElements(String(val)) + countElements(unit.rawValue))
        //var range = 105
        var perct : Double = Double(val) / Double(max)
        var valRange = Int(floor(Double(size.length) * perct))
        var space = String()
        
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
        
        var char_array = Array(name + space + String(val) + unit.rawValue)
        var color_array = [Int](count: Int(size.length), repeatedValue: 4)
        
        
        // Setup
        attroff(COLOR_PAIR(Int32(1)))
        attroff(COLOR_PAIR(Int32(2)))
        attroff(COLOR_PAIR(Int32(3)))
        attroff(COLOR_PAIR(Int32(4)))
        attroff(COLOR_PAIR(Int32(5)))
        //clear(win)
        
        var low = Int(ceil(Double(size.length) * 0.45))
        var mid = Int(floor(Double(size.length) * 0.30)) + low
        var high = Int(floor(Double(size.length) * 0.25))
        
        var count = 0
        for char in char_array {
            if (count < valRange) {
                if (count < low) {
                    // Green
                    attrset(COLOR_PAIR(Int32(1)))
                    addstr(String(char))
                }
                else if (count >= low && count < mid) {
                    // Yellow
                    attrset(COLOR_PAIR(Int32(2)))
                    addstr(String(char))
                }
                else {
                    // Red
                    // > 23
                    attrset(COLOR_PAIR(Int32(3)))
                    addstr(String(char))
                }
            }
            else {
                attrset(COLOR_PAIR(Int32(4)))
                addstr(String(char))
            }
            
            ++count
        }
        
        move(0,0)
        refresh()
    }
}
