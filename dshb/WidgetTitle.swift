

public class WidgetTitle {

    var title     : String
    var colour    : Int32
    var winCoords : Window
    
    
    init(title : String, winCoords : Window, colour : Int32) {
        self.title     = title
        self.colour    = colour
        self.winCoords = winCoords
    }
    
    
    func draw() {
        let x = getcurx(stdscr)
        let y = getcury(stdscr)

        move(winCoords.pos.y, winCoords.pos.x)
        attrset(colour)
        
        var space    = String()
        let spaceLen = winCoords.size.length - countElements(title)

        for var i = 0; i < Int(spaceLen); ++i {
            space.append(UnicodeScalar(" "))
        }
        
        addstr(title + space)
        move(y,x)
    }
    
    
    func resize(winCoords : Window) {
        self.winCoords = winCoords
        draw()
    }
}
