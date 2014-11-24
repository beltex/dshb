

public class WidgetTitle {

    let title     : String
    let colour    : Int32
    var winCoords : Window
    
    private var titlePadding = String()
    
    
    init(title : String, winCoords : Window, colour : Int32) {
        self.title     = title
        self.colour    = colour
        self.winCoords = winCoords
        
        computeTitlePadding()
    }
    
    
    func draw() {
        move(winCoords.pos.y, winCoords.pos.x)
        attrset(colour)
        addstr(title + titlePadding)
    }
    
    
    func resize(winCoords : Window) {
        self.winCoords = winCoords
        computeTitlePadding()
        draw()
    }
    
    
    private func computeTitlePadding() {
        titlePadding = String()
        let spaceLength = Int(winCoords.size.length - countElements(title))
        
        for var i = 0; i < spaceLength; ++i {
            titlePadding.append(UnicodeScalar(" "))
        }
    }
}
