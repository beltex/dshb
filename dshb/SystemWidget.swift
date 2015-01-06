

import Foundation

public struct SystemWidget: Widget {
    
    private var stats = [Stat]()
    var title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "System", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        stats.append(Stat(name: "Processes", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1))))
        stats.append(Stat(name: "Threads", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2))))
        stats.append(Stat(name: "Load Avg", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3))))
        stats.append(Stat(name: "Mach factor", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4))))

    }
    
    
    mutating func draw() {
        stats[0].draw(String(System.processCount()))
        stats[1].draw(String(System.threadCount()))
        
        let loadAverage = System.loadAverage()
        let v1 = NSString(format:"%.2f", loadAverage[0])
        let v2 = NSString(format:"%.2f", loadAverage[1])
        let v3 = NSString(format:"%.2f", loadAverage[2])
        stats[2].draw("\(v1), \(v2), \(v3)")
        
        let machFactor = System.machFactor()
        stats[3].draw("\(machFactor.0), \(machFactor.1), \(machFactor.2)")
    }
    
    
    mutating func resize(newCoords: Window) {
        self.win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < stats.count; ++i {
            stats[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
    }
}