

import Foundation

public struct SystemWidget: Widget {
    
    private var stats = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    init(win: Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "System", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        
        stats.append(Meter(name: "Uptime", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: 100, unit: Meter.Unit.None))
        stats.append(Meter(name: "Processes", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: 100, unit: Meter.Unit.None))
        stats.append(Meter(name: "Threads", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2)), max: 100, unit: Meter.Unit.None))
        stats.append(Meter(name: "Load Avg", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3)), max: 100, unit: Meter.Unit.None))
        stats.append(Meter(name: "Mach factor", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4)), max: 100, unit: Meter.Unit.None))
    }
    
    
    mutating func draw() {
        stats[1].draw(String(System.processCount()), percentage: 0.0)
        stats[2].draw(String(System.threadCount()), percentage: 0.0)
        
        let loadAverage = System.loadAverage()
        let v1 = NSString(format:"%.2f", loadAverage[0])
        let v2 = NSString(format:"%.2f", loadAverage[1])
        let v3 = NSString(format:"%.2f", loadAverage[2])
        stats[3].draw("\(v1), \(v2), \(v3)", percentage: 0.0)

        let machFactor = System.machFactor()
        stats[4].draw("\(machFactor.0), \(machFactor.1), \(machFactor.2)", percentage: 0.0)
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < stats.count; ++i {
            stats[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }

        return y_pos
    }
}