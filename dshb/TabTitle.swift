

public struct TabTitle {

    //private var win   : COpaquePointer
    private var space = String()
    
    public var colour : Int32
    public let title  : String
    
    init(title : String, winCoords : WinCoords, colour : Int32) {
        self.title  = title
        self.colour = colour
        move(winCoords.pos.y, winCoords.pos.x) 
        attrset(colour)
        
        var spaceLen = winCoords.size.length - countElements(title)
        
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
        
        addstr(title + space)
        move(0,0) 
        refresh()
    }
}
