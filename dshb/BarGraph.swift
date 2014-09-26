

import Foundation


public class BarGraph {

    public enum Unit : String {
        case Celsius    = "°C"
        case Fahrenheit = "°F"
        case Kelvin     = "K"
        case RPM        = "RPM"
    }
    
    private var win   : COpaquePointer
    private var space = String()
    let name  : String
    var value : Double = 0
    var size  : (length : Int32, width : Int32)
    var pos   : (x : Int32, y : Int32)
    let range : (min : Double, max : Double) // Negative temps?
    let unit : Unit
    //var zones : (low : Int, mid : Int, high : Int)
    
    init(name : String, length : Int32, width : Int32, x    : Int32,
                                                       y    : Int32,
                                                       max  : Double,
                                                       unit : Unit) {
        self.name = name
        self.unit = unit
        size.length = length
        size.width  = width
        pos.x = x
        pos.y = y
        
        range.min = 0
        range.max = max
        win = newwin(size.width, size.length, pos.y, pos.x)
    }
    
    
    func move(x : Int, y : Int) {
        
    }
    
    
    func resize(length : Int, width : Int) {
        
    }
    
    
    func update(value : Double) {
        
    }
    
    
    func updateVal(val : Int) {
        var spaceLen = size.length - (countElements(name) + countElements(String(val)) + countElements(unit.rawValue))
        var range = 105
        var perct : Double = Double(val) / Double(range)
        var valRange = Int(floor(Double(size.length) * perct))
        var space = String()
        
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
        
        var char_array = Array(name + space + String(val) + unit.rawValue)
        var color_array = [Int](count: Int(size.length), repeatedValue: 4)
        
        
        // Setup
        wattroff(win, COLOR_PAIR(Int32(1)))
        wattroff(win, COLOR_PAIR(Int32(2)))
        wattroff(win, COLOR_PAIR(Int32(3)))
        wclear(win)
        
        var count = 0
        for char in char_array {
            if (count < valRange) {
                if (count < 14) {
                    // Green
                    wattrset(win, COLOR_PAIR(Int32(1)))
                    waddstr(win, String(char))
                }
                else if (count >= 14 && count < 23) {
                    // Yellow
                    wattrset(win, COLOR_PAIR(Int32(2)))
                    waddstr(win, String(char))
                    //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
                }
                else {
                    // Red
                    // > 23
                    wattrset(win, COLOR_PAIR(Int32(3)))
                    waddstr(win, String(char))
                    //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
                }
            }
            else {
                wattrset(win, COLOR_PAIR(Int32(4)))
                waddstr(win, String(char))
            }
            
            ++count
        }
        
        wrefresh(win)
    }
    
}