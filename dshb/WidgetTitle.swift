

public struct WidgetTitle {

    private var space = String()
    public var colour : Int32
    public var title  : String
    
    init(title : String, winCoords : Window, colour : Int32) {
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
    
    
    func update() {
        
    }
    
    
    func resize() {
        
    }
    
    
    func moveTitle() {
        
    }
}
