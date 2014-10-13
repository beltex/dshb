

public struct WidgetTitle {

    private var space = String()
    public var colour : Int32
    public var title  : String
    public var winCoords : Window
    
    
    init(title : String, winCoords : Window, colour : Int32) {
        self.title  = title
        self.colour = colour
        
        self.winCoords = winCoords
        
        move(winCoords.pos.y, winCoords.pos.x) 
        attrset(colour)
        
        var spaceLen = winCoords.size.length - countElements(title)
        
        for var x = 0; x < Int(spaceLen); ++x {
            space.append(UnicodeScalar(" "))
        }
        
        addstr(title + space)
        move(0,0) 
        //refresh()
    }
    
    
    func update() {
        
    }
    
    
    func resize(length : Int, width : Int) {
        move(winCoords.pos.y, winCoords.pos.x)
        attrset(colour)
        var spaceLen = length - countElements(title)
        var space_t = String()
        
        for var x = 0; x < Int(spaceLen); ++x {
            space_t.append(UnicodeScalar(" "))
        }
        
        addstr(title + space_t)
        move(0,0)
        //refresh()
    }
    
    
    func moveTitle() {
        
    }
}
