

import Foundation

/**
Bar graph (meter) used to display a metric.

TODO: Op direction of meter. Battery health, battery life.
*/
public class Meter {
    
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC ENUMS
    //--------------------------------------------------------------------------
    
    
    public enum Unit : String {
        case Celsius    = "°C"
        case Fahrenheit = "°F"
        case Gigabyte   = "GB"
        case Kelvin     = "K"
        case Percentage = "%"
        case Megabyte   = "MB"
        case None       = ""
        case RPM        = " RPM"
    }
    
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC PROPERTIES
    //--------------------------------------------------------------------------
    
    
    let name : String
    let unit : Unit
    
    var value : Double = 0
    var winCoords : Window
    let max   : Int
    
    
    //--------------------------------------------------------------------------
    // MARK: PRIVATE PROPERTIES
    //--------------------------------------------------------------------------

    
    private let nameLength : Int
    private let unitLength : Int
    private var spaceLen   : Int = 0
    private var lastValue  : Int = 0
    
    var low  : Int
    var mid  : Int
    var high : Int
    
    
    //--------------------------------------------------------------------------
    // MARK: INITIALIZERS
    //--------------------------------------------------------------------------

    
    init(name : String, winCoords : Window, max  : Int, unit : Unit) {
        self.name      = name
        self.winCoords = winCoords
        self.unit      = unit
        self.max       = max
        
        nameLength     = countElements(name)
        unitLength     = countElements(unit.rawValue)
        
        low  = Int(ceil(Double(winCoords.size.length) * 0.45))
        mid  = Int(floor(Double(winCoords.size.length) * 0.30)) + low
        high = Int(floor(Double(winCoords.size.length) * 0.25))
    }
    
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC METHODS
    //--------------------------------------------------------------------------
    

    func draw(value : Int) {
        lastValue = value
        let valueLength = countElements(String(value))
        
        
        // Name setup
        let numberChars = winCoords.size.length - (2 + valueLength + unitLength)
        
        var nameEdit = name
        if (nameLength > Int(numberChars)) {
            nameEdit = (name as NSString).substringToIndex(Int(numberChars - 1))
            nameEdit.append(UnicodeScalar("…"))
        }
        
        let spaceLen = winCoords.size.length - (countElements(nameEdit) + valueLength + unitLength)

        
        // Range setup
        let percentage = Double(value) / Double(max)
        var valueRange = Int(floor(Double(winCoords.size.length) * percentage))
        
        var space = String()
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
    
        var char_array = Array(nameEdit + space + String(value) + unit.rawValue)
        
        
        // Setup
        attroff(COLOR_PAIR(Int32(1)))
        attroff(COLOR_PAIR(Int32(2)))
        attroff(COLOR_PAIR(Int32(3)))
        attroff(COLOR_PAIR(Int32(4)))
        attroff(COLOR_PAIR(Int32(5)))
        
        var count = 0
        move(winCoords.pos.y, winCoords.pos.x)
        for char in char_array {
            if (count < valueRange) {
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
    }
    
    
    func resize(winCoords: Window) {
        self.winCoords = winCoords
        low  = Int(ceil(Double(winCoords.size.length) * 0.45))
        mid  = Int(floor(Double(winCoords.size.length) * 0.30)) + low
        high = Int(floor(Double(winCoords.size.length) * 0.25))
        
        draw(lastValue)
    }
}
