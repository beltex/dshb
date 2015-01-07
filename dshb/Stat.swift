

import Foundation

public struct Stat {
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC PROPERTIES
    //--------------------------------------------------------------------------
    
    
    let name : String
    var value     = String()
    var winCoords : Window
    
    
    //--------------------------------------------------------------------------
    // MARK: PRIVATE PROPERTIES
    //--------------------------------------------------------------------------
    
    
    private let nameLength : Int
    private var spaceLen   : Int = 0
    private var lastValue = String()

    
    //--------------------------------------------------------------------------
    // MARK: INITIALIZERS
    //--------------------------------------------------------------------------
    
    
    init(name: String, winCoords: Window) {
        self.name = name
        self.winCoords = winCoords
        
        nameLength = countElements(name)
    }
    
    
    //--------------------------------------------------------------------------
    // MARK: PUBLIC METHODS
    //--------------------------------------------------------------------------
    
    
    mutating func draw(value: String) {
        attroff(COLOR_PAIR(Int32(1)))
        attroff(COLOR_PAIR(Int32(2)))
        attroff(COLOR_PAIR(Int32(3)))
        attroff(COLOR_PAIR(Int32(4)))
        attroff(COLOR_PAIR(Int32(5)))
        
        lastValue = value
        let valueLength = countElements(value)
        
        // Name setup
        let numberChars = winCoords.size.length - (2 + valueLength)
        
        // TODO: What if numberChars is less than zero? Crash
        var nameEdit = name
        if (nameLength > Int(numberChars) && Int(numberChars) > 0) {
            nameEdit = (name as NSString).substringToIndex(Int(numberChars - 1))
            nameEdit.append(UnicodeScalar("…"))
        }
        else if (Int(numberChars) < 0) {
            return
        }
        
        let spaceLen = winCoords.size.length - (countElements(nameEdit) + valueLength)
        
        
        var space = String()
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
        
        
        move(winCoords.pos.y, winCoords.pos.x)
        addstr(nameEdit + space + value)
    }
    
    
    mutating func resize(winCoords: Window) {
        self.winCoords = winCoords
        draw(lastValue)
    }
}
