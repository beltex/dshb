

import Foundation

public struct SystemWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    let stats = ["Uptime", "Processes", "Threads", "Load Avg", "Mach factor"]
    
    
    init(win: Window = Window()) {        
        self.win = win
        
        let titleCoords = Window(length: win.length, pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "System", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        var yShift = 1
        for stat in stats {
            meters.append(Meter(name: stat,
                                winCoords: Window(length: win.length,
                                                  pos: (x:win.pos.x, y:win.pos.y + yShift)),
                                max: 1.0,
                                unit: Meter.Unit.None))
            ++yShift
        }
    }
    
    
    mutating func draw() {
        //meters[0].draw(String(System.uptime()), percentage: 0.0)

        meters[1].draw(String(System.processCount()), percentage: 0.0)
        meters[2].draw(String(System.threadCount()), percentage: 0.0)
        
        let loadAverage = System.loadAverage()
        let v1 = NSString(format:"%.2f", loadAverage[0])
        let v2 = NSString(format:"%.2f", loadAverage[1])
        let v3 = NSString(format:"%.2f", loadAverage[2])
        meters[3].draw("\(v1), \(v2), \(v3)", percentage: 0.0)

        let machFactor = System.machFactor()
        meters[4].draw("\(machFactor.0), \(machFactor.1), \(machFactor.2)", percentage: 0.0)
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(length: win.length, pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }

        return y_pos
    }
}