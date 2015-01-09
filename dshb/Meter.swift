

import Foundation

public struct Meter {
    
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
    var unit : Unit
    
    var value : Double = 0
    var winCoords : Window
    var max   : Double
    
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
        let numberChars = winCoords.size.length - (2 + valueLength + unitLength)
        
        var nameEdit = name
        if (nameLength > Int(numberChars)) {
            nameEdit = (name as NSString).substringToIndex(Int(numberChars - 1))
            nameEdit.append(UnicodeScalar("…"))
        }
        
        let spaceLen = winCoords.size.length - (countElements(nameEdit) + valueLength + unitLength)

        
        // Range setup
        //let percentage = Double(value) / Double(max)
        var valueRange = Int(floor(Double(winCoords.size.length) * percentage))
        
        var space = String()
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
    
        var char_array = Array(nameEdit + space + value + unit.rawValue)
        
        
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
                if (valueRange < low) {
                    // Green
                    attrset(COLOR_PAIR(Int32(1)))
                    addstr(String(char))
                }
                else if (valueRange >= low && valueRange < mid) {
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
    
    
    mutating func resize(winCoords: Window) {
        self.winCoords = winCoords
        computeRanges()
        draw(lastValue, percentage: lastPercentage)
    }
    
    
    private mutating func computeRanges() {
        low  = Int(ceil(Double(winCoords.size.length) * 0.45))
        mid  = Int(floor(Double(winCoords.size.length) * 0.30)) + low
        high = Int(floor(Double(winCoords.size.length) * 0.25))
    }
}
