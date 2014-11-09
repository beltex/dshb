

public struct WidgetTitle {

    private var space = String()
    public var colour : Int32
    public var title  : String
    public var winCoords : Window
    
    
    init(title : String, winCoords : Window, colour : Int32) {
        var x = getcurx(stdscr)
        var y = getcury(stdscr)
        
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
        move(y,x)
    }
    
    
    func update() {
        
    }
    
    
    func resize(winCoords2 : Window) {        
        var x = getcurx(stdscr)
        var y = getcury(stdscr)
        move(winCoords2.pos.y, winCoords2.pos.x)
        attrset(colour)
        var spaceLen = winCoords2.size.length - countElements(title)
        var space_t = String()
        
        for var x = 0; x < Int(spaceLen); ++x {
            space_t.append(UnicodeScalar(" "))
        }
        
        addstr(title + space_t)
        move(y,x)
    }
    
    
    func moveTitle() {
        
    }
}
